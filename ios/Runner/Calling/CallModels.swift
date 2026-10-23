import Foundation

public enum CallPhase: String {
    case idle = "idle"
    case ringing = "ringing"
    case permissionRequired = "permissionRequired"
    case answering = "answering"
    case connecting = "connecting"
    case connected = "connected"
    case reconnecting = "reconnecting"
    case ending = "ending"
    case ended = "ended"
}

public enum MicrophonePermissionStatus: String {
    case notDetermined = "notDetermined"
    case granted = "granted"
    case denied = "denied"
    case permanentlyDenied = "permanentlyDenied"
    case restricted = "restricted"
}

public struct CallerDisplay {
    public let callerName: String
    public let callerRole: String?
    public let avatarUrl: String?
    public let orderNumber: String?

    public init(callerName: String, callerRole: String? = nil, avatarUrl: String? = nil, orderNumber: String? = nil) {
        self.callerName = callerName
        self.callerRole = callerRole
        self.avatarUrl = avatarUrl
        self.orderNumber = orderNumber
    }

    public func toDictionary() -> [String: Any?] {
        return [
            "callerName": callerName,
            "callerRole": callerRole,
            "avatarUrl": avatarUrl,
            "orderNumber": orderNumber
        ]
    }
}

public struct NativeCallSnapshot {
    public let schemaVersion: Int
    public let engineInstanceId: String
    public let revision: Int
    public let callId: String?
    public let lifecycleId: String?
    public let serverSequence: Int
    public let negotiationGeneration: Int
    public let phase: CallPhase
    public let serverStatus: String?
    public let microphonePermission: MicrophonePermissionStatus
    public let isMuted: BooleanLiteralType
    public let audioRouteId: String
    public let availableAudioRoutes: [String]
    public let mediaTransportConnected: BooleanLiteralType
    public let audioSessionActive: BooleanLiteralType
    public let connectedAtUtc: String?
    public let elapsedSeconds: Int
    public let errorCode: String?
    public let callerDisplay: CallerDisplay?

    public init(
        schemaVersion: Int = 1,
        engineInstanceId: String,
        revision: Int,
        callId: String? = nil,
        lifecycleId: String? = nil,
        serverSequence: Int = 0,
        negotiationGeneration: Int = 0,
        phase: CallPhase = .idle,
        serverStatus: String? = nil,
        microphonePermission: MicrophonePermissionStatus = .notDetermined,
        isMuted: Bool = false,
        audioRouteId: String = "earpiece",
        availableAudioRoutes: [String] = ["earpiece", "speaker"],
        mediaTransportConnected: Bool = false,
        audioSessionActive: Bool = false,
        connectedAtUtc: String? = nil,
        elapsedSeconds: Int = 0,
        errorCode: String? = nil,
        callerDisplay: CallerDisplay? = nil
    ) {
        self.schemaVersion = schemaVersion
        self.engineInstanceId = engineInstanceId
        self.revision = revision
        self.callId = callId
        self.lifecycleId = lifecycleId
        self.serverSequence = serverSequence
        self.negotiationGeneration = negotiationGeneration
        self.phase = phase
        self.serverStatus = serverStatus
        self.microphonePermission = microphonePermission
        self.isMuted = isMuted
        self.audioRouteId = audioRouteId
        self.availableAudioRoutes = availableAudioRoutes
        self.mediaTransportConnected = mediaTransportConnected
        self.audioSessionActive = audioSessionActive
        self.connectedAtUtc = connectedAtUtc
        self.elapsedSeconds = elapsedSeconds
        self.errorCode = errorCode
        self.callerDisplay = callerDisplay
    }

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "schemaVersion": schemaVersion,
            "engineInstanceId": engineInstanceId,
            "revision": revision,
            "serverSequence": serverSequence,
            "negotiationGeneration": negotiationGeneration,
            "phase": phase.rawValue,
            "microphonePermission": microphonePermission.rawValue,
            "isMuted": isMuted,
            "audioRouteId": audioRouteId,
            "availableAudioRoutes": availableAudioRoutes,
            "mediaTransportConnected": mediaTransportConnected,
            "audioSessionActive": audioSessionActive,
            "elapsedSeconds": elapsedSeconds
        ]

        if let callId = callId { dict["callId"] = callId }
        if let lifecycleId = lifecycleId { dict["lifecycleId"] = lifecycleId }
        if let serverStatus = serverStatus { dict["serverStatus"] = serverStatus }
        if let connectedAtUtc = connectedAtUtc { dict["connectedAtUtc"] = connectedAtUtc }
        if let errorCode = errorCode { dict["errorCode"] = errorCode }
        if let callerDisplay = callerDisplay { dict["callerDisplay"] = callerDisplay.toDictionary() }

        return dict
    }
}
