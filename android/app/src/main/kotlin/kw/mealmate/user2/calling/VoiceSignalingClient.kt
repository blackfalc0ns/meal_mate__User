package kw.mealmate.user2.calling

import kotlinx.coroutines.*
import okhttp3.*
import org.json.JSONArray
import org.json.JSONObject
import java.net.URLEncoder
import java.util.concurrent.atomic.AtomicInteger

/** SignalR JSON transport. A socket is usable only after the server confirms binding. */
class VoiceSignalingClient(
 private val hubUrl: String = "https://api.trymealmate.com/hubs/voice-call-v2",
 private val tokenProvider: () -> String? = { null },
 private val refreshToken: suspend (String?) -> Boolean = { false }
) {
 private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())
 private val client = OkHttpClient.Builder().readTimeout(0, java.util.concurrent.TimeUnit.MILLISECONDS).build()
 @Volatile private var socket: WebSocket? = null
 @Volatile private var epoch = 0
 @Volatile private var sessionId: String? = null
 @Volatile private var proof: String? = null
 @Volatile private var connecting = false
 @Volatile private var bound = false
 private val ids = AtomicInteger()
 private var reconnect: Job? = null
 var onBound: (() -> Unit)? = null
 var onDisconnected: (() -> Unit)? = null
 var onCallEvent: ((JSONObject) -> Unit)? = null
 var onRtcOffer: ((String, JSONObject, String, Int) -> Unit)? = null
 var onRtcIce: ((String, JSONObject, String, Int) -> Unit)? = null
 fun isBound() = bound
 @Synchronized fun connectAndBind(deviceSessionId: String, controlProof: String) {
  if (sessionId == deviceSessionId && proof == controlProof && (bound || connecting)) return
  disconnect(); sessionId = deviceSessionId; proof = controlProof
  connect()
 }
 @Synchronized private fun connect() {
  val sid = sessionId ?: return
  val secret = proof ?: return
  var token = tokenProvider()?.takeIf { it.isNotBlank() } ?: return
  if (connecting || bound) return
  connecting = true
  val current = ++epoch
  scope.launch { delay(15000); if(current == epoch && !bound) lost(current) }
  scope.launch {
   try {
    val request = Request.Builder().url("$hubUrl/negotiate?negotiateVersion=1")
     .header("Authorization", "Bearer $token").post(RequestBody.create(null, ByteArray(0))).build()
    var response = client.newCall(request).execute()
    if(response.code == 401) {
     response.close()
     check(refreshToken(token)) { "Session refresh failed" }
     token = tokenProvider() ?: error("Missing refreshed token")
     response = client.newCall(request.newBuilder().header("Authorization", "Bearer $token").build()).execute()
    }
    val connection = response.use { response ->
     check(response.isSuccessful) { "Negotiate failed" }
     JSONObject(response.body?.string().orEmpty()).getString("connectionToken")
    }
    if (current != epoch) return@launch
    val url = hubUrl.replaceFirst("https://", "wss://").replaceFirst("http://", "ws://") +
     "?id=${URLEncoder.encode(connection, "UTF-8")}&access_token=${URLEncoder.encode(token, "UTF-8")}"
    synchronized(this@VoiceSignalingClient) {
    if(current != epoch) return@synchronized
    socket = client.newWebSocket(Request.Builder().url(url).header("Authorization", "Bearer $token").build(), object: WebSocketListener() {
     private var pending = ""
     override fun onOpen(ws: WebSocket, response: Response) {
      if (current != epoch) { ws.cancel(); return }
      ws.send("{\"protocol\":\"json\",\"version\":1}" + 30.toChar())
     }
     override fun onMessage(ws: WebSocket, text: String) {
      if (current != epoch) return
      pending += text
      while (pending.contains(30.toChar())) {
       if(current != epoch) return
       val frame = pending.substringBefore(30.toChar()); pending = pending.substringAfter(30.toChar())
       if (frame.isBlank()) continue
       try {
        val json = JSONObject(frame)
        if (!json.has("type")) {
         if (json.has("error")) { ws.cancel(); lost(current); return }
         invoke("BindDeviceSession", JSONArray().put(sid).put(secret), true)
        } else when(json.optInt("type")) {
         6 -> ws.send("{\"type\":6}" + 30.toChar())
         7 -> { ws.cancel(); lost(current) }
         1 -> dispatch(json.optString("target"), json.optJSONArray("arguments") ?: JSONArray())
        }
       } catch (_: Exception) { /* malformed frames cannot change call ownership */ }
      }
     }
     override fun onFailure(ws: WebSocket, error: Throwable, response: Response?) { lost(current) }
     override fun onClosed(ws: WebSocket, code: Int, reason: String) { lost(current) }
     override fun onClosing(ws: WebSocket, code: Int, reason: String) { ws.close(code, reason) }
    })
    }
   } catch (_: Exception) { lost(current) }
  }
 }
 @Synchronized private fun lost(current: Int) {
  if (current != epoch) return
  val retryEpoch = ++epoch
  socket?.cancel(); socket = null
  bound = false; connecting = false; onDisconnected?.invoke()
  reconnect?.cancel()
  reconnect = scope.launch { delay(3000); if (retryEpoch == epoch && sessionId != null) connect() }
 }
 internal fun dispatch(target: String, args: JSONArray) {
  when(target) {
   "bound" -> { bound = true; connecting = false; onBound?.invoke() }
   "call:event", "OnCallEvent", "CallEvent" -> args.optJSONObject(0)?.let { onCallEvent?.invoke(it) }
   "rtc:offer", "rtc:ice-candidate", "rtc:ice" -> {
    val env = args.optJSONObject(0)
    val callId = if(args.length() >= 4) args.optString(0) else env?.optString("callId").orEmpty()
    val payload = if(args.length() >= 4) args.optJSONObject(1) else env?.optJSONObject("payload")
    val messageId = if(args.length() >= 4) args.optString(2) else env?.optString("messageId").orEmpty()
    val generation = if(args.length() >= 4) args.optInt(3) else env?.optInt("negotiationGeneration", env.optInt("generation")) ?: 0
    if (callId.isBlank() || payload == null) return
    if (target == "rtc:offer") onRtcOffer?.invoke(callId, payload, messageId, generation)
    else onRtcIce?.invoke(callId, payload, messageId, generation)
   }
  }
 }
 private fun invoke(target: String, args: JSONArray, binding: Boolean = false): Boolean {
  if (!binding && !bound) return false
  return socket?.send(JSONObject().put("type", 1).put("invocationId", ids.incrementAndGet().toString())
   .put("target", target).put("arguments", args).toString() + 30.toChar()) == true
 }
 fun sendAnswer(callId: String, sdp: String, messageId: String, generation: Int): Boolean =
  sdp.toByteArray().size <= 65536 && invoke("SendAnswer", JSONArray().put(callId).put(JSONObject().put("type", "answer").put("sdp", sdp)).put(messageId).put(generation))
 fun sendIceCandidate(callId: String, candidate: JSONObject, messageId: String, generation: Int): Boolean =
  candidate.toString().toByteArray().size <= 4096 && invoke("SendIceCandidate", JSONArray().put(callId).put(candidate).put(messageId).put(generation))
 @Synchronized fun disconnect() {
  epoch++; reconnect?.cancel(); reconnect = null; bound = false; connecting = false
  sessionId = null; proof = null; socket?.cancel(); socket = null
 }
}
