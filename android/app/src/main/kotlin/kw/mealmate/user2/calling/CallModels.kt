package kw.mealmate.user2.calling

enum class CallPhase(val value: String) {
    IDLE("idle"),
    RINGING("ringing"),
    PERMISSION_REQUIRED("permissionRequired"),
    ANSWERING("answering"),
    CONNECTING("connecting"),
    CONNECTED("connected"),
    RECONNECTING("reconnecting"),
    ENDING("ending"),
    ENDED("ended");

    companion object {
        fun fromString(value: String?): CallPhase {
            return entries.firstOrNull { it.value.equals(value, ignoreCase = true) } ?: IDLE
        }
    }
}

enum class MicrophonePermissionStatus(val value: String) {
    NOT_DETERMINED("notDetermined"),
    GRANTED("granted"),
    DENIED("denied"),
    PERMANENTLY_DENIED("permanentlyDenied"),
    RESTRICTED("restricted")
}

data class CallerDisplay(
    val callerName: String,
    val callerRole: String? = null,
    val avatarUrl: String? = null,
    val orderNumber: String? = null,
    val deliveryAddress: String? = null,
    val addressTitle: String? = null
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "callerName" to callerName,
        "callerRole" to callerRole,
        "avatarUrl" to avatarUrl,
        "orderNumber" to orderNumber,
        "deliveryAddress" to deliveryAddress,
        "addressTitle" to addressTitle
    )
}

data class NativeCallSnapshot(
    val schemaVersion: Int = 1,
    val engineInstanceId: String,
    val revision: Int,
    val callId: String? = null,
    val lifecycleId: String? = null,
    val serverSequence: Int = 0,
    val negotiationGeneration: Int = 0,
    val phase: CallPhase = CallPhase.IDLE,
    val serverStatus: String? = null,
    val microphonePermission: MicrophonePermissionStatus = MicrophonePermissionStatus.NOT_DETERMINED,
    val isMuted: Boolean = false,
    val audioRouteId: String = "earpiece",
    val availableAudioRoutes: List<String> = listOf("earpiece", "speaker"),
    val mediaTransportConnected: Boolean = false,
    val audioSessionActive: Boolean = false,
    val connectedAtUtc: String? = null,
    val elapsedSeconds: Int = 0,
    val errorCode: String? = null,
    val callerDisplay: CallerDisplay? = null
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "schemaVersion" to schemaVersion,
        "engineInstanceId" to engineInstanceId,
        "revision" to revision,
        "callId" to callId,
        "lifecycleId" to lifecycleId,
        "serverSequence" to serverSequence,
        "negotiationGeneration" to negotiationGeneration,
        "phase" to phase.value,
        "serverStatus" to serverStatus,
        "microphonePermission" to microphonePermission.value,
        "isMuted" to isMuted,
        "audioRouteId" to audioRouteId,
        "availableAudioRoutes" to availableAudioRoutes,
        "mediaTransportConnected" to mediaTransportConnected,
        "audioSessionActive" to audioSessionActive,
        "connectedAtUtc" to connectedAtUtc,
        "elapsedSeconds" to elapsedSeconds,
        "errorCode" to errorCode,
        "callerDisplay" to callerDisplay?.toMap()
    )
}
