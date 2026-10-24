package kw.mealmate.user2.calling

import android.content.Context
import android.content.SharedPreferences

data class VoiceSessionData(
    val sessionRevision: Int,
    val accountId: String,
    val voiceDeviceSessionId: String,
    val controlProof: String,
    val accessToken: String? = null,
    val refreshToken: String? = null,
    val expiresAtUtc: String? = null
)

class VoiceSessionStore(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    @Synchronized
    fun readSession(): VoiceSessionData? {
        val accountId = prefs.getString(KEY_ACCOUNT_ID, null) ?: return null
        val voiceSessionId = prefs.getString(KEY_VOICE_SESSION_ID, null) ?: return null
        val controlProof = prefs.getString(KEY_CONTROL_PROOF, null) ?: return null
        val revision = prefs.getInt(KEY_REVISION, 0)

        return VoiceSessionData(
            sessionRevision = revision,
            accountId = accountId,
            voiceDeviceSessionId = voiceSessionId,
            controlProof = controlProof,
            accessToken = prefs.getString(KEY_ACCESS_TOKEN, null),
            refreshToken = prefs.getString(KEY_REFRESH_TOKEN, null),
            expiresAtUtc = prefs.getString(KEY_EXPIRES_AT, null)
        )
    }

    @Synchronized
    fun readAccessToken(): String? {
        return prefs.getString(KEY_ACCESS_TOKEN, null)
    }

    @Synchronized
    fun installSession(expectedRevision: Int, data: VoiceSessionData): Pair<Boolean, Int> {
        val currentRev = prefs.getInt(KEY_REVISION, 0)
        if (expectedRevision != 0 && expectedRevision != currentRev) {
            return Pair(false, currentRev)
        }

        val newRev = currentRev + 1
        prefs.edit()
            .putInt(KEY_REVISION, newRev)
            .putString(KEY_ACCOUNT_ID, data.accountId)
            .putString(KEY_VOICE_SESSION_ID, data.voiceDeviceSessionId)
            .putString(KEY_CONTROL_PROOF, data.controlProof)
            .putString(KEY_ACCESS_TOKEN, data.accessToken)
            .putString(KEY_REFRESH_TOKEN, data.refreshToken)
            .putString(KEY_EXPIRES_AT, data.expiresAtUtc)
            .apply()

        return Pair(true, newRev)
    }

    @Synchronized
    fun refreshSession(expectedRevision: Int, newAccessToken: String): Pair<Boolean, Int> {
        val currentRev = prefs.getInt(KEY_REVISION, 0)
        if (expectedRevision != currentRev) {
            return Pair(false, currentRev)
        }

        val newRev = currentRev + 1
        prefs.edit()
            .putInt(KEY_REVISION, newRev)
            .putString(KEY_ACCESS_TOKEN, newAccessToken)
            .apply()

        return Pair(true, newRev)
    }

    @Synchronized
    fun clearSession(expectedRevision: Int): Pair<Boolean, Int> {
        val currentRev = prefs.getInt(KEY_REVISION, 0)
        if(expectedRevision != 0 && expectedRevision != currentRev) return Pair(false, currentRev)
        val newRev = currentRev + 1

        prefs.edit()
            .clear()
            .putInt(KEY_REVISION, newRev)
            .apply()

        return Pair(true, newRev)
    }

    @Synchronized fun updateTokens(expectedRevision: Int, access: String, refresh: String?): Boolean {
        val current = prefs.getInt(KEY_REVISION, 0)
        if(current != expectedRevision || readSession() == null) return false
        prefs.edit().putInt(KEY_REVISION, current + 1).putString(KEY_ACCESS_TOKEN, access)
            .apply { if(!refresh.isNullOrBlank()) putString(KEY_REFRESH_TOKEN, refresh) }.apply()
        return true
    }
    @Synchronized
    fun getMetadata(): Map<String, Any?> {
        val accountId = prefs.getString(KEY_ACCOUNT_ID, null)
        return mapOf(
            "sessionRevision" to prefs.getInt(KEY_REVISION, 0),
            "hasSession" to (accountId != null),
            "accountId" to accountId
        )
    }

    companion object {
        private const val PREFS_NAME = "mealmate_voice_session_secure"
        private const val KEY_REVISION = "revision"
        private const val KEY_ACCOUNT_ID = "account_id"
        private const val KEY_VOICE_SESSION_ID = "voice_session_id"
        private const val KEY_CONTROL_PROOF = "control_proof"
        private const val KEY_ACCESS_TOKEN = "access_token"
        private const val KEY_REFRESH_TOKEN = "refresh_token"
        private const val KEY_EXPIRES_AT = "expires_at"
    }
}
