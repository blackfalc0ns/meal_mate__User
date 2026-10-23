import Foundation

public final class CallStateMachine {
    public let engineInstanceId: String
    private var revisionCounter: Int = 0
    private let lock = NSRecursiveLock()

    public private(set) var currentSnapshot: NativeCallSnapshot

    private var listeners: [(NativeCallSnapshot) -> Void] = []
    private var processedRequestIds: [String: String] = [:]

    public init(engineInstanceId: String = UUID().uuidString) {
        self.engineInstanceId = engineInstanceId
        self.revisionCounter = 1
        self.currentSnapshot = NativeCallSnapshot(
            engineInstanceId: engineInstanceId,
            revision: 1,
            phase: .idle
        )
    }

    public func addListener(_ listener: @escaping (NativeCallSnapshot) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        listeners.append(listener)
        listener(currentSnapshot)
    }

    public func removeAllListeners() {
        lock.lock()
        defer { lock.unlock() }
        listeners.removeAll()
    }

    @discardableResult
    public func onIncomingRinging(
        callId: String,
        lifecycleId: String = UUID().uuidString,
        sequence: Int = 1,
        callerDisplay: CallerDisplay? = nil,
        micStatus: MicrophonePermissionStatus = .notDetermined
    ) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        if currentSnapshot.callId == callId && currentSnapshot.phase != .ended && currentSnapshot.phase != .idle {
            return false
        }
        if currentSnapshot.phase != .idle && currentSnapshot.phase != .ended {
            return false
        }

        revisionCounter += 1
        currentSnapshot = NativeCallSnapshot(
            schemaVersion: 1,
            engineInstanceId: engineInstanceId,
            revision: revisionCounter,
            callId: callId,
            lifecycleId: lifecycleId,
            serverSequence: sequence,
            negotiationGeneration: 0,
            phase: .ringing,
            serverStatus: "ringing",
            microphonePermission: micStatus,
            isMuted: false,
            audioRouteId: "earpiece",
            availableAudioRoutes: ["earpiece", "speaker"],
            mediaTransportConnected: false,
            audioSessionActive: false,
            connectedAtUtc: nil,
            elapsedSeconds: 0,
            errorCode: nil,
            callerDisplay: callerDisplay
        )
        notifyListeners()
        return true
    }

    @discardableResult
    public func onUserAnswer(callId: String, lifecycleId: String, requestId: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return false }
        if processedRequestIds[requestId] != nil { return true }

        guard currentSnapshot.phase == .ringing || currentSnapshot.phase == .permissionRequired else {
            return false
        }

        processedRequestIds[requestId] = "answer"
        revisionCounter += 1
        currentSnapshot = copySnapshot(phase: .answering, microphonePermission: .granted)
        notifyListeners()
        return true
    }

    @discardableResult
    public func onServerAccepted(callId: String, lifecycleId: String, connectedAtUtc: String? = nil) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return false }

        revisionCounter += 1
        let nextPhase: CallPhase = (currentSnapshot.mediaTransportConnected && currentSnapshot.audioSessionActive) ? .connected : .connecting
        currentSnapshot = copySnapshot(
            phase: nextPhase,
            serverStatus: "accepted",
            connectedAtUtc: connectedAtUtc
        )
        notifyListeners()
        return true
    }

    @discardableResult
    public func onMediaConnected(callId: String, lifecycleId: String, generation: Int) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return false }
        guard generation == currentSnapshot.negotiationGeneration else { return false }

        revisionCounter += 1
        let isReady = currentSnapshot.serverStatus == "accepted" && currentSnapshot.audioSessionActive
        currentSnapshot = copySnapshot(
            negotiationGeneration: generation,
            phase: isReady ? .connected : .connecting,
            mediaTransportConnected: true
        )
        notifyListeners()
        return true
    }

    @discardableResult
    public func onPermissionRequired(callId: String, lifecycleId: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return false }

        revisionCounter += 1
        currentSnapshot = copySnapshot(
            phase: .permissionRequired,
            microphonePermission: .denied
        )
        notifyListeners()
        return true
    }

    @discardableResult
    public func onMuteToggled(callId: String, lifecycleId: String, requestId: String, muted: Bool) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return false }
        processedRequestIds[requestId] = "mute"

        revisionCounter += 1
        currentSnapshot = copySnapshot(isMuted: muted)
        notifyListeners()
        return true
    }

    @discardableResult
    public func onAudioRouteChanged(callId: String, lifecycleId: String, requestId: String, routeId: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return false }
        processedRequestIds[requestId] = "route"

        revisionCounter += 1
        currentSnapshot = copySnapshot(audioRouteId: routeId)
        notifyListeners()
        return true
    }

    public func onCallEnding(callId: String, lifecycleId: String, reason: String? = nil) {
        lock.lock()
        defer { lock.unlock() }

        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return }

        revisionCounter += 1
        currentSnapshot = copySnapshot(phase: .ending, errorCode: reason)
        notifyListeners()
    }

    public func onCallEnded(callId: String, lifecycleId: String, reason: String? = nil) {
        lock.lock()
        defer { lock.unlock() }

        guard currentSnapshot.callId == callId, currentSnapshot.lifecycleId == lifecycleId, currentSnapshot.phase != .ended else { return }

        revisionCounter += 1
        currentSnapshot = copySnapshot(
            phase: .ended,
            serverStatus: "ended",
            mediaTransportConnected: false,
            audioSessionActive: false,
            errorCode: reason
        )
        notifyListeners()
    }

    public func onServerSequence(callId: String, lifecycleId: String, sequence: Int) {
        lock.lock(); defer { lock.unlock() }
        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId), sequence > currentSnapshot.serverSequence else { return }
        revisionCounter += 1
        currentSnapshot = copySnapshot(serverSequence: sequence)
        notifyListeners()
    }
    public func onNegotiating(callId: String, lifecycleId: String, generation: Int) {
        lock.lock(); defer { lock.unlock() }
        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId), generation >= currentSnapshot.negotiationGeneration else { return }
        revisionCounter += 1
        currentSnapshot = copySnapshot(negotiationGeneration: generation, phase: .connecting, mediaTransportConnected: false)
        notifyListeners()
    }
    public func onTransportDisconnected(callId: String, lifecycleId: String, generation: Int) {
        lock.lock(); defer { lock.unlock() }
        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId), generation == currentSnapshot.negotiationGeneration else { return }
        revisionCounter += 1
        currentSnapshot = copySnapshot(phase: .reconnecting, mediaTransportConnected: false)
        notifyListeners()
    }
    public func onAudioActivation(callId: String, lifecycleId: String, active: Bool) {
        lock.lock(); defer { lock.unlock() }
        guard validateActiveCall(callId: callId, lifecycleId: lifecycleId) else { return }
        revisionCounter += 1
        let ready = active && currentSnapshot.mediaTransportConnected && currentSnapshot.serverStatus == "accepted"
        currentSnapshot = copySnapshot(phase: ready ? .connected : (currentSnapshot.phase == .connected ? .reconnecting : currentSnapshot.phase), audioSessionActive: active)
        notifyListeners()
    }

    public func resetToIdle() {
        lock.lock()
        defer { lock.unlock() }

        processedRequestIds.removeAll()
        revisionCounter += 1
        currentSnapshot = NativeCallSnapshot(
            engineInstanceId: engineInstanceId,
            revision: revisionCounter,
            phase: .idle
        )
        notifyListeners()
    }

    private func validateActiveCall(callId: String, lifecycleId: String) -> Bool {
        guard currentSnapshot.callId == callId, currentSnapshot.lifecycleId == lifecycleId else {
            return false
        }
        guard currentSnapshot.phase != .ended && currentSnapshot.phase != .idle && currentSnapshot.phase != .ending else {
            return false
        }
        return true
    }

    private func copySnapshot(
        serverSequence: Int? = nil,
        negotiationGeneration: Int? = nil,
        phase: CallPhase? = nil,
        serverStatus: String? = nil,
        microphonePermission: MicrophonePermissionStatus? = nil,
        isMuted: Bool? = nil,
        audioRouteId: String? = nil,
        availableAudioRoutes: [String]? = nil,
        mediaTransportConnected: Bool? = nil,
        audioSessionActive: Bool? = nil,
        connectedAtUtc: String? = nil,
        elapsedSeconds: Int? = nil,
        errorCode: String? = nil
    ) -> NativeCallSnapshot {
        return NativeCallSnapshot(
            schemaVersion: currentSnapshot.schemaVersion,
            engineInstanceId: currentSnapshot.engineInstanceId,
            revision: revisionCounter,
            callId: currentSnapshot.callId,
            lifecycleId: currentSnapshot.lifecycleId,
            serverSequence: serverSequence ?? currentSnapshot.serverSequence,
            negotiationGeneration: negotiationGeneration ?? currentSnapshot.negotiationGeneration,
            phase: phase ?? currentSnapshot.phase,
            serverStatus: serverStatus ?? currentSnapshot.serverStatus,
            microphonePermission: microphonePermission ?? currentSnapshot.microphonePermission,
            isMuted: isMuted ?? currentSnapshot.isMuted,
            audioRouteId: audioRouteId ?? currentSnapshot.audioRouteId,
            availableAudioRoutes: availableAudioRoutes ?? currentSnapshot.availableAudioRoutes,
            mediaTransportConnected: mediaTransportConnected ?? currentSnapshot.mediaTransportConnected,
            audioSessionActive: audioSessionActive ?? currentSnapshot.audioSessionActive,
            connectedAtUtc: connectedAtUtc ?? currentSnapshot.connectedAtUtc,
            elapsedSeconds: elapsedSeconds ?? currentSnapshot.elapsedSeconds,
            errorCode: errorCode ?? currentSnapshot.errorCode,
            callerDisplay: currentSnapshot.callerDisplay
        )
    }

    private func notifyListeners() {
        let snapshot = currentSnapshot
        for listener in listeners {
            listener(snapshot)
        }
    }
}
