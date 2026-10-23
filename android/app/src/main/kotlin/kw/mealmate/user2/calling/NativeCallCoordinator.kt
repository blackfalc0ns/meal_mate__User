package kw.mealmate.user2.calling

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioManager
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.content.ContextCompat
import kotlinx.coroutines.*
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

/** The single owner of session signaling, incoming call lifecycle and native audio. */
class NativeCallCoordinator(val context: Context, val stateMachine: CallStateMachine = CallStateMachine()) {
 private val scope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())
 private val handler = Handler(Looper.getMainLooper())
 var sessionStore: VoiceSessionStore? = VoiceSessionStore(context)
 var apiClient: VoiceApiClient? = VoiceApiClient(tokenProvider = { sessionStore?.readAccessToken() }, sessionStore = sessionStore)
 var signalingClient: VoiceSignalingClient? = VoiceSignalingClient(tokenProvider = { sessionStore?.readAccessToken() }, refreshToken = { apiClient?.refreshJwt(it) == true })
 var mediaEngine: VoiceMediaEngine? = VoiceMediaEngine(context, signalingClient!!)
 var telecomController: TelecomCallController? = TelecomCallController(context)
 var notificationController: CallNotificationController? = CallNotificationController(context)
 private var owner: VoiceSessionData? = null
 private var ticker: Job? = null
 private var pendingOffer: Triple<String, JSONObject, Int>? = null
 private val pendingIce = mutableListOf<Triple<String, JSONObject, Int>>()
 private var ringDeadline: java.time.Instant? = null
 private var mediaGeneration = -1
 private var preparingGeneration = -1
 private var mediaCallId: String? = null
 private var preparingCallId: String? = null
 val currentSnapshot get() = stateMachine.currentSnapshot
 init {
  stateMachine.addListener { snapshot -> handler.post {
   if(snapshot.revision != currentSnapshot.revision) return@post
   when(snapshot.phase) {
    CallPhase.RINGING, CallPhase.PERMISSION_REQUIRED -> notificationController?.showIncomingCall(snapshot)
    CallPhase.CONNECTED, CallPhase.CONNECTING, CallPhase.RECONNECTING -> notificationController?.showActiveCall(snapshot)
    CallPhase.ENDED, CallPhase.IDLE -> notificationController?.dismiss(snapshot.callId)
    else -> notificationController?.stopForegroundRingtone()
   }
  } }
  signalingClient?.onBound = { scope.launch { mediaEngine?.resendAnswer(); reconcile() } }
  signalingClient?.onCallEvent = { event -> scope.launch { handleEvent(event) } }
  signalingClient?.onRtcOffer = { id, payload, _, generation -> scope.launch {
   if (id == currentSnapshot.callId && active(id, currentSnapshot.lifecycleId.orEmpty()) && generation >= currentSnapshot.negotiationGeneration) {
    if(payload.optString("sdp").isBlank()) return@launch
    if(pendingOffer?.let { it.first == id && it.third == generation } == true) return@launch
    stateMachine.onNegotiationGeneration(generation)
    pendingOffer = Triple(id, payload, generation); startMediaIfReady()
   }
  } }
  signalingClient?.onRtcIce = { id, payload, _, generation -> scope.launch {
   if (id == currentSnapshot.callId && active(id, currentSnapshot.lifecycleId.orEmpty()) && generation >= currentSnapshot.negotiationGeneration) {
    if (mediaGeneration == generation && mediaCallId == id) addIce(id, payload, generation)
    else if(pendingIce.size < 256) pendingIce.add(Triple(id, payload, generation))
   }
  } }
  mediaEngine?.listener = object: VoiceMediaEngine.Listener {
   override fun onLocalMediaConnected() {
    val s = currentSnapshot
    if (mediaCallId != s.callId || !active(s.callId.orEmpty(), s.lifecycleId.orEmpty())) return
    if(!stateMachine.onMediaConnected(s.callId!!, s.lifecycleId!!, mediaGeneration)) return
    scope.launch { sessionStore?.readSession()?.let { apiClient?.reportConnected(s.callId, mediaGeneration, it.voiceDeviceSessionId, it.controlProof) } }
   }
   override fun onMediaDisconnected() { stateMachine.onMediaDisconnected() }
   override fun onMediaFailed() { currentSnapshot.let { finish(it.callId.orEmpty(), it.lifecycleId.orEmpty(), "media_failed") } }
  }
  sessionChanged()
 }
 fun sessionChanged() { scope.launch {
  val session = sessionStore?.readSession()
  val old = owner
  if (old != null && (session == null || old.accountId != session.accountId || old.voiceDeviceSessionId != session.voiceDeviceSessionId)) {
   currentSnapshot.let { finish(it.callId.orEmpty(), it.lifecycleId.orEmpty(), "session_changed") }
   signalingClient?.disconnect()
  }
  owner = session
  if(session == null) { signalingClient?.disconnect(); ticker?.cancel(); return@launch }
  if(old?.accessToken != session.accessToken) signalingClient?.disconnect()
  signalingClient?.connectAndBind(session.voiceDeviceSessionId, session.controlProof)
  reconcile()
 } }
 fun resume() { sessionChanged() }
 fun serviceStopped(callId: String?) { scope.launch {
  val snapshot=currentSnapshot
  if(callId != null && callId == snapshot.callId && active(callId,snapshot.lifecycleId.orEmpty())) finish(callId,snapshot.lifecycleId.orEmpty(),"foreground_service_stopped")
 } }
 fun handlePush(data: Map<String,String>) { scope.launch {
  val envelope = listOf("envelope", "payload", "data").firstNotNullOfOrNull { key ->
   data[key]?.let { runCatching { JSONObject(it) }.getOrNull() }
  }
  val event = JSONObject(data)
  envelope?.keys()?.forEach { event.put(it, envelope.opt(it)) }
  handleEvent(event)
 } }
 private fun handleEvent(event: JSONObject) {
  val payload = event.optJSONObject("payload") ?: event.optJSONObject("data") ?: event
  val id = event.optString("callId").ifBlank { payload.optString("callId") }
  val nameFields = listOf("callerName", "driverName", "callerRole", "driverRole")
  fun fields(source: JSONObject) = nameFields.joinToString { key ->
   "$key=${if (source.has(key)) source.opt(key) else "<missing>"}"
  }
  Log.d("VoiceCallPush", "callId=$id, type=${event.optString("type")}, envelope={${fields(event)}}, payload={${fields(payload)}}")
  if(id.isBlank() || sessionStore?.readSession() == null) return
  val sequence = event.optInt("sequence", event.optInt("serverSequence", payload.optInt("sequence", 0)))
  if(id == currentSnapshot.callId && sequence in 1..currentSnapshot.serverSequence &&
   currentSnapshot.callerDisplay?.callerName?.let { it.isNotBlank() && it.lowercase() != "null" && it != "Delivery Driver" && it != "مندوب التوصيل" } == true) return
  if(id == currentSnapshot.callId) stateMachine.onServerSequence(id,currentSnapshot.lifecycleId.orEmpty(),sequence)
  val status = payload.optString("status").ifBlank { event.optString("status").ifBlank { event.optString("eventType").ifBlank { event.optString("type") } } }.lowercase()
  if(listOf("ended", "rejected", "cancelled", "canceled", "expired", "failed", "missed", "busy", "completed", "terminated", "timeout").any { status.contains(it) }) {
   if(id == currentSnapshot.callId) finish(id, currentSnapshot.lifecycleId.orEmpty(), status)
   stateMachine.rememberTerminal(id)
   return
  }
  if(status.contains("accepted") || status.contains("connected")) {
   if(id == currentSnapshot.callId && currentSnapshot.phase in listOf(CallPhase.RINGING, CallPhase.PERMISSION_REQUIRED)) finish(id,currentSnapshot.lifecycleId.orEmpty(),"answered_elsewhere")
   // A server status never manufactures local media readiness.
   return
  }
  if(status.contains("ring") || status.contains("invite") || status == "voice-call" || status == "incoming") {
   val deadline = payload.optString("deadlineAtUtc").ifBlank { event.optString("expiresAtUtc") }
   val expiry = runCatching { java.time.Instant.parse(deadline) }.getOrNull()
   if(expiry != null && !expiry.isAfter(java.time.Instant.now())) { stateMachine.rememberTerminal(id); return }
   if(currentSnapshot.phase in listOf(CallPhase.IDLE,CallPhase.ENDED) || currentSnapshot.callId == id) ringDeadline = expiry ?: ringDeadline
   val resolvedName = payload.optString("callerName").ifBlank { payload.optString("driverName").ifBlank { event.optString("callerName").ifBlank { event.optString("driverName", "Delivery Driver") } } }
   val resolvedRole = payload.optString("callerRole").ifBlank { payload.optString("driverRole").ifBlank { event.optString("callerRole").ifBlank { event.optString("driverRole", "مندوب التوصيل") } } }
   val resolvedAvatar = payload.optString("avatarUrl").ifBlank { payload.optString("driverImageUrl").ifBlank { event.optString("avatarUrl").ifBlank { event.optString("driverImageUrl", "") } } }.ifBlank { null }
   val resolvedOrder = payload.optString("orderNumber").ifBlank { payload.optString("orderCode").ifBlank { event.optString("orderNumber").ifBlank { event.optString("orderCode", "") } } }.ifBlank { null }
   handleIncomingInvite(id, callerDisplay = CallerDisplay(resolvedName, resolvedRole, resolvedAvatar, resolvedOrder), sequence = sequence.coerceAtLeast(1))
  }
 }
 fun handleIncomingInvite(callId: String, tripStopId: String? = null, callerDisplay: CallerDisplay? = null, sequence: Int = 1) {
  if(sessionStore?.readSession() == null) return
  val started = stateMachine.onIncomingRinging(callId, callerDisplay = callerDisplay, sequence = sequence,
   micStatus = if(hasMic()) MicrophonePermissionStatus.GRANTED else MicrophonePermissionStatus.DENIED)
  if(!started) return
  val snapshot = currentSnapshot
  val displayed = notificationController?.showIncomingCall(snapshot) == true
  scope.launch {
   val session = sessionStore?.readSession() ?: return@launch
   if(displayed && active(callId, snapshot.lifecycleId.orEmpty())) apiClient?.ringingAck(callId, session.voiceDeviceSessionId, session.controlProof)
  }
  startTicker()
  sessionChanged()
 }
 private fun hasMic() = ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED
 private fun active(id: String, lifecycle: String) = currentSnapshot.let { it.callId == id && it.lifecycleId == lifecycle && it.phase !in listOf(CallPhase.IDLE, CallPhase.ENDED, CallPhase.ENDING) }
 fun answer(callId: String, lifecycleId: String, requestId: String, completion: ((String?) -> Unit)? = null) { scope.launch {
  if(!active(callId,lifecycleId)) { completion?.invoke("stale_call"); return@launch }
  if(!hasMic()) { stateMachine.onPermissionRequired(callId,lifecycleId); completion?.invoke("microphone_permission_required"); return@launch }
  val session = sessionStore?.readSession()
  if(session == null) { completion?.invoke("missing_session"); return@launch }
  if(!stateMachine.onUserAnswer(callId,lifecycleId,requestId)) { completion?.invoke("invalid_phase"); return@launch }
  // Start while the answer gesture grants foreground-service eligibility, before network suspension.
  try { VoiceCallService.start(context, callId, currentSnapshot.callerDisplay?.callerName ?: "Delivery Driver") }
  catch (_: Exception) { finish(callId,lifecycleId,"foreground_service_unavailable"); completion?.invoke("foreground_service_unavailable"); return@launch }
  val ready = withTimeoutOrNull(15000) { while(signalingClient?.isBound() != true) delay(50); true } == true
  if(!active(callId,lifecycleId)) { completion?.invoke("stale_call"); return@launch }
  if(!ready) { finish(callId,lifecycleId,"signaling_unavailable"); completion?.invoke("signaling_unavailable"); return@launch }
  val accepted = apiClient?.answer(callId,session.voiceDeviceSessionId,session.controlProof)?.isSuccess == true
  if(!active(callId,lifecycleId) || owner?.accountId != session.accountId) { completion?.invoke("stale_call"); return@launch }
  if(!accepted) { finish(callId,lifecycleId,"server_answer_rejected"); completion?.invoke("server_answer_rejected"); return@launch }
  stateMachine.onServerAccepted(callId,lifecycleId); startMediaIfReady(); startTicker(); completion?.invoke(null)
 } }
 private fun startMediaIfReady() {
  val s=currentSnapshot
  if(s.phase !in listOf(CallPhase.CONNECTING, CallPhase.CONNECTED, CallPhase.RECONNECTING)) return
  val offer = pendingOffer ?: return
  if(offer.first != s.callId || offer.third < s.negotiationGeneration || (mediaCallId == s.callId && mediaGeneration == offer.third) || (preparingCallId == s.callId && preparingGeneration == offer.third)) return
  preparingCallId=s.callId; preparingGeneration=offer.third
  scope.launch {
   val session=sessionStore?.readSession() ?: return@launch
   val raw=apiClient?.getIceServers(s.callId!!,session.voiceDeviceSessionId,session.controlProof)?.getOrNull()
   if(!active(s.callId!!,s.lifecycleId!!) || pendingOffer != offer) return@launch
   val servers=runCatching {
    val root=JSONObject(raw.orEmpty()); val data=root.optJSONObject("data") ?: root
    val items=data.optJSONArray("iceServers") ?: JSONArray()
    (0 until items.length()).map { i -> val item=items.getJSONObject(i); val urls=item.optJSONArray("urls")
     NativeIceServer(if(urls != null) (0 until urls.length()).map { urls.getString(it) } else listOf(item.getString("urls")),item.optString("username",null),item.optString("credential",null)) }
   }.getOrDefault(emptyList())
   if(servers.isEmpty()) { finish(s.callId,s.lifecycleId,"ice_unavailable"); return@launch }
   stateMachine.onNegotiationGeneration(offer.third)
   apiClient?.reportConnecting(s.callId,offer.third,session.voiceDeviceSessionId,session.controlProof)
   if(!active(s.callId,s.lifecycleId) || pendingOffer != offer) return@launch
   (context.getSystemService(Context.AUDIO_SERVICE) as AudioManager).mode=AudioManager.MODE_IN_COMMUNICATION
   preparingCallId=null; preparingGeneration=-1
   mediaCallId=s.callId; mediaGeneration=offer.third
   mediaEngine?.setMuted(currentSnapshot.isMuted)
   mediaEngine?.startAnswerSession(s.callId,offer.third,servers,offer.second.optString("sdp"))
   pendingIce.filter { it.first == s.callId && it.third == offer.third }.forEach { addIce(it.first,it.second,it.third) }; pendingIce.clear()
  }
 }
 private fun addIce(id:String,p:JSONObject,g:Int) { mediaEngine?.handleRemoteCandidate(id,p.optString("candidate"),g,p.optString("sdpMid",null),p.optInt("sdpMLineIndex")) }
 fun reject(callId:String,lifecycleId:String,requestId:String,completion:((String?)->Unit)?=null) = terminate(callId,lifecycleId,true,completion)
 fun end(callId:String,lifecycleId:String,requestId:String,completion:((String?)->Unit)?=null) = terminate(callId,lifecycleId,false,completion)
 private fun terminate(id:String,lc:String,reject:Boolean,completion:((String?)->Unit)?) { scope.launch {
  if(!active(id,lc) || (reject && currentSnapshot.phase !in listOf(CallPhase.RINGING,CallPhase.PERMISSION_REQUIRED))) { completion?.invoke("stale_call"); return@launch }
  val session=sessionStore?.readSession() ?: run { completion?.invoke("missing_session"); return@launch }
  val result=if(reject) apiClient?.reject(id,session.voiceDeviceSessionId,session.controlProof) else apiClient?.end(id,session.voiceDeviceSessionId,session.controlProof)
  if(result?.isSuccess == true) { finish(id,lc,if(reject) "user_rejected" else "user_ended"); completion?.invoke(null) }
  else { completion?.invoke("server_action_rejected"); reconcile() }
 } }
 fun setMuted(callId:String,lifecycleId:String,requestId:String,muted:Boolean) { if(stateMachine.onMuteToggled(callId,lifecycleId,requestId,muted)) mediaEngine?.setMuted(muted) }
 fun setAudioRoute(callId:String,lifecycleId:String,requestId:String,routeId:String) { if(routeId in listOf("speaker","earpiece") && stateMachine.onAudioRouteChanged(callId,lifecycleId,requestId,routeId)) telecomController?.setAudioRoute(routeId) }
 private fun finish(id:String,lc:String,reason:String) {
  if(currentSnapshot.callId != id || currentSnapshot.lifecycleId != lc) return
  stateMachine.onCallEnded(id,lc,reason); ticker?.cancel(); mediaEngine?.stop(); VoiceCallService.stop(context)
  ringDeadline=null; mediaCallId=null; mediaGeneration=-1; preparingCallId=null; preparingGeneration=-1; pendingOffer=null; pendingIce.clear()
  (context.getSystemService(Context.AUDIO_SERVICE) as AudioManager).mode=AudioManager.MODE_NORMAL
  telecomController?.disconnect(id); notificationController?.dismiss(id)
 }
  private fun startTicker() {
   if(ticker?.isActive == true) return
   ticker=scope.launch {
    var ticks = 0
    while(isActive) {
     delay(1000)
     ticks++
     val s=currentSnapshot
     if(!active(s.callId.orEmpty(),s.lifecycleId.orEmpty())) break
     stateMachine.updateElapsed()
     if(ticks % 5 == 0) {
      if(s.phase in listOf(CallPhase.RINGING,CallPhase.PERMISSION_REQUIRED) && ringDeadline?.isAfter(java.time.Instant.now()) == false) {
       finish(s.callId!!,s.lifecycleId!!,"expired"); break
      }
      if(s.phase in listOf(CallPhase.CONNECTED,CallPhase.CONNECTING,CallPhase.RECONNECTING)) sessionStore?.readSession()?.let { apiClient?.heartbeat(s.callId!!,it.voiceDeviceSessionId,it.controlProof) }
      reconcile()
     }
    } }
  }

  private suspend fun reconcile() {
    val session = sessionStore?.readSession() ?: return
    val before = currentSnapshot
    val result = if (active(before.callId.orEmpty(), before.lifecycleId.orEmpty())) {
      apiClient?.getCall(before.callId!!, session.voiceDeviceSessionId, session.controlProof)
    } else {
      apiClient?.getActive(session.voiceDeviceSessionId, session.controlProof)
    }
    val raw = result?.getOrNull()
    if (!raw.isNullOrBlank()) {
      runCatching {
        val root = JSONObject(raw)
        val call = root.optJSONObject("data") ?: root
        handleEvent(call)
      }
    } else if (result?.isFailure == true && active(before.callId.orEmpty(), before.lifecycleId.orEmpty())) {
      val error = result.exceptionOrNull()?.message.orEmpty()
      if (error.contains("404") || error.contains("not_found") || error.contains("no_active_call")) {
        finish(before.callId!!, before.lifecycleId!!, "not_found_on_reconcile")
      }
    }
  }

  companion object {
    @Volatile
    private var instance: NativeCallCoordinator? = null

    fun getInstance(context: Context): NativeCallCoordinator {
      return instance ?: synchronized(this) {
        instance ?: NativeCallCoordinator(context.applicationContext).also { instance = it }
      }
    }
  }
}
