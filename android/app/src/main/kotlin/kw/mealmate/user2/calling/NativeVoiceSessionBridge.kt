package kw.mealmate.user2.calling

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NativeVoiceSessionBridge(
    private val context: Context,
    private val sessionStore: VoiceSessionStore = VoiceSessionStore(context)
) : MethodChannel.MethodCallHandler {

    private var methodChannel: MethodChannel? = null

    fun register(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler(this)
    }

    fun unregister() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSessionMetadata" -> {
                result.success(sessionStore.getMetadata())
            }
            "installSession" -> {
                val expectedRev = call.argument<Int>("expectedRevision") ?: 0
                val accountId = call.argument<String>("accountId") ?: ""
                val voiceSessionId = call.argument<String>("voiceDeviceSessionId") ?: ""
                val controlProof = call.argument<String>("controlProof") ?: ""
                val accessToken = call.argument<String>("accessToken")
                val refreshToken = call.argument<String>("refreshToken")
                val expiresAt = call.argument<String>("expiresAtUtc")

                if(accountId.isBlank() || voiceSessionId.isBlank() || controlProof.isBlank() || accessToken.isNullOrBlank()) {
                    result.error("invalid_session", "Native voice session requires credentials", null); return
                }
                val data = VoiceSessionData(
                    sessionRevision = expectedRev,
                    accountId = accountId,
                    voiceDeviceSessionId = voiceSessionId,
                    controlProof = controlProof,
                    accessToken = accessToken,
                    refreshToken = refreshToken,
                    expiresAtUtc = expiresAt
                )

                val (success, newRev) = sessionStore.installSession(expectedRev, data)
                if (success) {
                    NativeCallCoordinator.getInstance(context).sessionChanged()
                    result.success(mapOf("status" to "installed", "sessionRevision" to newRev))
                } else {
                    result.error("conflict_revision", "Expected revision does not match current", null)
                }
            }
            "readSessionTokens" -> {
                val session = sessionStore.readSession()
                val expected = call.argument<Int>("expectedRevision")
                if(session == null || session.sessionRevision != expected) result.error("conflict_revision", "Session changed", null)
                else result.success(mapOf("accountId" to session.accountId, "accessToken" to session.accessToken, "refreshToken" to session.refreshToken))
            }
            "readAccessToken" -> {
                result.success(sessionStore.readAccessToken())
            }
            "refreshSession" -> {
                val expectedRev = call.argument<Int>("expectedRevision") ?: 0
                val newAccessToken = call.argument<String>("accessToken") ?: ""
                val (success, newRev) = sessionStore.refreshSession(expectedRev, newAccessToken)
                if (success) {
                    NativeCallCoordinator.getInstance(context).sessionChanged()
                    result.success(mapOf("status" to "refreshed", "sessionRevision" to newRev, "accessToken" to newAccessToken))
                } else {
                    result.error("conflict_revision", "Expected revision does not match current", null)
                }
            }
            "clearSession" -> {
                val expectedRev = call.argument<Int>("expectedRevision") ?: 0
                val (success, newRev) = sessionStore.clearSession(expectedRev)
                if(success) NativeCallCoordinator.getInstance(context).sessionChanged()
                if(success) result.success(mapOf("status" to "cleared", "sessionRevision" to newRev))
                else result.error("conflict_revision", "Expected revision does not match current", null)
            }
            else -> result.notImplemented()
        }
    }

    companion object {
        const val CHANNEL_NAME = "kw.mealmate.user/voice_session/methods"
    }
}
