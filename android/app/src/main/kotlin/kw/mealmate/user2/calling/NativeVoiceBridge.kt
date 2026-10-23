package kw.mealmate.user2.calling

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NativeVoiceBridge(
    private val context: Context,
    private val coordinator: NativeCallCoordinator = NativeCallCoordinator.getInstance(context)
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    private val stateListener: (NativeCallSnapshot) -> Unit = { snapshot ->
        android.os.Handler(android.os.Looper.getMainLooper()).post { eventSink?.success(snapshot.toMap()) }
    }

    fun register(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
        methodChannel?.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        eventChannel?.setStreamHandler(this)
    }

    fun unregister() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null

        eventChannel?.setStreamHandler(null)
        eventChannel = null

        coordinator.stateMachine.removeListener(stateListener)
        eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if(call.method in listOf("answer","reject","end","setMuted","setAudioRoute")) {
            val snapshot = coordinator.currentSnapshot
            if(call.argument<String>("callId") != snapshot.callId || call.argument<String>("lifecycleId") != snapshot.lifecycleId || snapshot.phase in listOf(CallPhase.IDLE,CallPhase.ENDED,CallPhase.ENDING)) {
                result.error("stale_call", "Call lifecycle is no longer active", null); return
            }
        }
        when (call.method) {
            "handlePush" -> { coordinator.handlePush(call.argument<Map<String,String>>("data") ?: emptyMap()); result.success(null) }
            "resume" -> { coordinator.resume(); result.success(null) }
            "getSnapshot" -> {
                result.success(coordinator.currentSnapshot.toMap())
            }
            "setPresentationContext" -> {
                val appVisible = call.argument<Boolean>("appVisible") ?: true
                isFlutterPresenting = appVisible
                android.os.Handler(android.os.Looper.getMainLooper()).post {
                    flutterReadyListener?.invoke(appVisible)
                }
                result.success(null)
            }
            "getMicrophonePermission" -> {
                val granted = androidx.core.content.ContextCompat.checkSelfPermission(
                    context,
                    android.Manifest.permission.RECORD_AUDIO
                ) == android.content.pm.PackageManager.PERMISSION_GRANTED
                result.success(if (granted) "granted" else "denied")
            }
            "getCapabilities" -> {
                val caps = mapOf(
                    "supported" to true,
                    "telecomAvailable" to false,
                    "platform" to "android"
                )
                result.success(caps)
            }
            "answer" -> {
                val callId = call.argument<String>("callId") ?: ""
                val lifecycleId = call.argument<String>("lifecycleId") ?: ""
                val requestId = call.argument<String>("requestId") ?: ""

                if (coordinator.currentSnapshot.callId != callId) {
                    result.error("stale_call", "Call ID does not match active call", null)
                    return
                }

                coordinator.answer(callId, lifecycleId, requestId) { error ->
                    if(error == null) result.success(mapOf("status" to "accepted", "requestId" to requestId))
                    else result.error(error, "Call action failed", null)
                }
            }
            "reject" -> {
                val callId = call.argument<String>("callId") ?: ""
                val lifecycleId = call.argument<String>("lifecycleId") ?: ""
                val requestId = call.argument<String>("requestId") ?: ""

                if (coordinator.currentSnapshot.callId != callId) {
                    result.error("stale_call", "Call ID does not match active call", null)
                    return
                }

                coordinator.reject(callId, lifecycleId, requestId) { error ->
                    if(error == null) result.success(mapOf("status" to "accepted", "requestId" to requestId))
                    else result.error(error, "Call action failed", null)
                }
            }
            "end" -> {
                val callId = call.argument<String>("callId") ?: ""
                val lifecycleId = call.argument<String>("lifecycleId") ?: ""
                val requestId = call.argument<String>("requestId") ?: ""

                coordinator.end(callId, lifecycleId, requestId) { error ->
                    if(error == null) result.success(mapOf("status" to "accepted", "requestId" to requestId))
                    else result.error(error, "Call action failed", null)
                }
            }
            "setMuted" -> {
                val callId = call.argument<String>("callId") ?: ""
                val lifecycleId = call.argument<String>("lifecycleId") ?: ""
                val requestId = call.argument<String>("requestId") ?: ""
                val muted = call.argument<Boolean>("muted") ?: false

                coordinator.setMuted(callId, lifecycleId, requestId, muted)
                result.success(mapOf("status" to "accepted", "muted" to muted))
            }
            "setAudioRoute" -> {
                val callId = call.argument<String>("callId") ?: ""
                val lifecycleId = call.argument<String>("lifecycleId") ?: ""
                val requestId = call.argument<String>("requestId") ?: ""
                val routeId = call.argument<String>("routeId") ?: "earpiece"

                coordinator.setAudioRoute(callId, lifecycleId, requestId, routeId)
                result.success(mapOf("status" to "accepted", "routeId" to routeId))
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        coordinator.stateMachine.addListener(stateListener)
    }

    override fun onCancel(arguments: Any?) {
        coordinator.stateMachine.removeListener(stateListener)
        eventSink = null
    }

    companion object {
        const val METHOD_CHANNEL = "kw.mealmate.user/voice_calls/methods"
        const val EVENT_CHANNEL = "kw.mealmate.user/voice_calls/events"

        @Volatile
        var isFlutterPresenting: Boolean = false
        var flutterReadyListener: ((Boolean) -> Unit)? = null
    }
}
