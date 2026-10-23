import Foundation
import AVFoundation
import CallKit

/// Keeps candidates outside the media engine until its peer-reset/setup has finished.
/// This includes candidates received while the ICE-server REST request is outstanding.
struct NativeMediaPreparation {
    static func acceptsOffer(generation: Int, snapshotGeneration: Int, pendingGeneration: Int?) -> Bool {
        generation >= max(snapshotGeneration, pendingGeneration ?? 0)
    }
    private(set) var isPreparing = false
    private(set) var isStarted = false
    private var candidates: [(Int, [String: Any])] = []
    mutating func begin() -> Bool {
        guard !isPreparing && !isStarted else { return false }
        isPreparing = true
        return true
    }
    mutating func receive(_ candidate: [String: Any], generation: Int, activeGeneration: Int?) -> Bool {
        if isStarted && activeGeneration == generation { return true }
        if candidates.count < 256 { candidates.append((generation, candidate)) }
        return false
    }
    mutating func peerStarted(generation: Int) -> [[String: Any]] {
        isPreparing = false
        isStarted = true
        let queued = candidates.filter { $0.0 == generation }.map { $0.1 }
        candidates.removeAll { $0.0 <= generation }
        return queued
    }
    mutating func newOffer() { isPreparing = false; isStarted = false }
    mutating func reset() { self = NativeMediaPreparation() }
}

/// Native owner for call lifecycle, SignalR, WebRTC and CallKit. All callbacks use main.
public final class NativeCallCoordinator {
    public static let shared = NativeCallCoordinator()
    public let stateMachine: CallStateMachine
    public var sessionStore: VoiceSessionStore?
    public var apiClient: VoiceApiClient?
    public var signalingClient: VoiceSignalingClient?
    public var mediaEngine: VoiceMediaEngine?
    public var callKitController: CallKitController?
    private var sessionProof: String?
    private var sessionId: String?
    private var sessionEpoch = 0
    private var answerMessageId = UUID().uuidString
    private var answerSdp: String?
    private var localIce: [([String: Any], String)] = []
    private var receivedIceIds = Set<String>()
    private var mediaPreparation = NativeMediaPreparation()
    private var offer: (String, Int)?
    private var localAnswerAccepted = false
    private var transportConnected = false
    private var reportedConnected = false
    private var heartbeat: Timer?
    private var terminalIds = Set<String>()
    private var lastSequence = 0
    public var currentSnapshot: NativeCallSnapshot { stateMachine.currentSnapshot }
    public init(stateMachine: CallStateMachine = CallStateMachine()) {
        self.stateMachine = stateMachine
        sessionStore = .shared
        apiClient = VoiceApiClient(tokenProvider: { VoiceSessionStore.shared.readAccessToken() })
        signalingClient = VoiceSignalingClient(tokenProvider: { VoiceSessionStore.shared.readAccessToken() })
        mediaEngine = .shared
        callKitController = .shared
        signalingClient?.onBound = { [weak self] in
            guard let self = self else { return }
            self.resume()
        }
        signalingClient?.onCallEvent = { [weak self] in self?.handlePush($0) }
        signalingClient?.onRtcOffer = { [weak self] id, payload, _, generation in
            guard let self = self, self.isActive(id), NativeMediaPreparation.acceptsOffer(generation: generation, snapshotGeneration: self.currentSnapshot.negotiationGeneration, pendingGeneration: self.offer?.1),
                  let sdp = payload["sdp"] as? String, sdp.utf8.count <= 65536 else { return }
            if self.offer?.1 == generation { if self.offer?.0 == sdp { self.replaySignals() }; return }
            self.answerMessageId = UUID().uuidString
            self.offer = (sdp, generation); self.mediaPreparation.newOffer(); self.answerSdp = nil; self.localIce.removeAll()
            self.startMediaIfReady()
        }
        signalingClient?.onRtcIce = { [weak self] id, candidate, message, generation in
            guard let self = self, self.isActive(id), generation >= self.currentSnapshot.negotiationGeneration else { return }
            let key = "\(generation):\(message)"
            if !message.isEmpty {
                guard !self.receivedIceIds.contains(key) else { return }
                if self.receivedIceIds.count < 512 { self.receivedIceIds.insert(key) }
            }
            if self.mediaPreparation.receive(candidate, generation: generation, activeGeneration: self.offer?.1) { self.mediaEngine?.addCandidate(candidate) }
        }
        callKitController?.onAudioSessionActivated = { [weak self] in self?.mediaEngine?.activated(true); self?.reportReady() }
        callKitController?.onAudioSessionDeactivated = { [weak self] in self?.mediaEngine?.activated(false); self?.updateAudio(false) }
    }
    private func main(_ work: @escaping () -> Void) { if Thread.isMainThread { work() } else { DispatchQueue.main.async(execute: work) } }
    public func matches(_ id: String, _ lifecycle: String) -> Bool { isActive(id) && currentSnapshot.lifecycleId == lifecycle }
    private func isActive(_ id: String) -> Bool { currentSnapshot.callId == id && ![CallPhase.idle, .ended, .ending].contains(currentSnapshot.phase) }
    public func sessionChanged() {
        main { [weak self] in
            guard let self = self else { return }
            self.sessionEpoch += 1
            let session = self.sessionStore?.readSession()
            if session?.voiceDeviceSessionId != self.sessionId || session?.controlProof != self.sessionProof {
                if let id = self.currentSnapshot.callId, let life = self.currentSnapshot.lifecycleId { self.finish(id, life, "session_changed") }
                self.terminalIds.removeAll()
            }
            self.sessionId = session?.voiceDeviceSessionId
            self.sessionProof = session?.controlProof
            guard let session = session, !(session.accessToken ?? "").isEmpty else { self.signalingClient?.disconnect(); return }
            self.signalingClient?.connectAndBind(deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof)
        }
    }
    private static func parseDate(_ value: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: value) ?? ISO8601DateFormatter().date(from: value)
    }
    public static func unwrap(_ input: [String: Any]) -> [String: Any] {
        var value = input
        for key in ["data", "envelope", "payload"] {
            if let nested = value[key] as? [String: Any] { value.merge(nested) { _, new in new } }
            else if let text = value[key] as? String, let raw = text.data(using: .utf8), let nested = try? JSONSerialization.jsonObject(with: raw) as? [String: Any] { value.merge(nested) { _, new in new } }
        }
        return value
    }
    public func handlePush(_ input: [String: Any]) {
        main { [weak self] in
            guard let self = self else { return }
            let data = Self.unwrap(input)
            guard let id = data["callId"] as? String, !id.isEmpty else { return }
            let status = (data["status"] as? String ?? data["serverStatus"] as? String ?? data["eventType"] as? String ?? data["type"] as? String ?? "ringing").lowercased()
            let sequence = (data["sequence"] as? Int) ?? (data["serverSequence"] as? Int) ?? 0
            if self.currentSnapshot.callId == id && sequence > 0 && sequence < self.lastSequence { return }
            if ["ended", "rejected", "cancelled", "canceled", "missed", "expired", "failed", "busy", "timeout", "timedout"].contains(where: { status == $0 || status.hasSuffix("." + $0) || status.hasSuffix("_" + $0) }) {
                self.terminalIds.insert(id)
                if let life = self.currentSnapshot.lifecycleId, self.currentSnapshot.callId == id { self.finish(id, life, status) }
                return
            }
            guard !self.terminalIds.contains(id), self.sessionStore?.readSession() != nil else { return }
            if let winner = data["winningDeviceSessionId"] as? String, !winner.isEmpty, winner != self.sessionStore?.readSession()?.voiceDeviceSessionId {
                self.terminalIds.insert(id)
                if self.currentSnapshot.callId == id, let life = self.currentSnapshot.lifecycleId { self.finish(id, life, "answered_elsewhere") }
                return
            }
            if let expiration = data["deadlineAtUtc"] as? String ?? data["expiresAtUtc"] as? String,
               let date = Self.parseDate(expiration), date <= Date(), status.contains("ring") || status.contains("invite") || status.contains("incoming") {
                self.terminalIds.insert(id)
                if self.currentSnapshot.callId == id, let life = self.currentSnapshot.lifecycleId { self.finish(id, life, "ringing_expired") }
                return
            }
            if self.currentSnapshot.callId == id && self.isActive(id) {
                self.lastSequence = max(sequence, self.lastSequence)
                if let life = self.currentSnapshot.lifecycleId { self.stateMachine.onServerSequence(callId: id, lifecycleId: life, sequence: sequence) }
                if ["accepted", "connecting", "connected", "reconnecting", "active"].contains(status),
                   self.localAnswerAccepted || self.currentSnapshot.phase == .answering, let life = self.currentSnapshot.lifecycleId {
                    self.stateMachine.onServerAccepted(callId: id, lifecycleId: life, connectedAtUtc: data["connectedAtUtc"] as? String)
                    self.startMediaIfReady()
                }
                return
            }
            guard status.contains("ring") || status.contains("invite") || status.contains("incoming") else { return }
            self.lastSequence = sequence
            let callerName = data["driverName"] as? String ?? data["callerName"] as? String ?? "Delivery Driver"
            let callerRole = data["driverRole"] as? String ?? data["callerRole"] as? String ?? "مندوب التوصيل"
            let avatarUrl = data["avatarUrl"] as? String ?? data["driverImageUrl"] as? String
            let orderNumber = data["orderNumber"] as? String ?? data["orderCode"] as? String
            let deliveryAddress = data["deliveryAddress"] as? String ?? data["addressDetails"] as? String ?? data["address"] as? String
            let addressTitle = data["addressTitle"] as? String
            let display = CallerDisplay(callerName: callerName, callerRole: callerRole, avatarUrl: avatarUrl, orderNumber: orderNumber, deliveryAddress: deliveryAddress, addressTitle: addressTitle)
            self.handleIncomingPush(callId: id, callerDisplay: display, sequence: sequence)
        }
    }
    public func handleIncomingPush(callId: String, tripStopId: String? = nil, callerDisplay: CallerDisplay? = nil, sequence: Int = 1) {
        if sessionId == nil { sessionChanged() }
        let life = UUID().uuidString
        guard !terminalIds.contains(callId), stateMachine.onIncomingRinging(callId: callId, lifecycleId: life, sequence: sequence, callerDisplay: callerDisplay, micStatus: permission) else { return }
        callKitController?.reportIncomingCall(callId: callId, callerName: callerDisplay?.callerName ?? "Delivery Driver") { [weak self] error in
            self?.main {
                guard let self = self, self.matches(callId, life) else { return }
                guard error == nil, let session = self.sessionStore?.readSession() else { self.finish(callId, life, "callkit_failed"); return }
                self.apiClient?.ringingAck(callId: callId, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof) { _ in }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 45) { [weak self] in
            guard let self = self, self.matches(callId, life), [.ringing, .permissionRequired].contains(self.currentSnapshot.phase) else { return }
            self.resume()
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
                guard let self = self, self.matches(callId, life), [.ringing, .permissionRequired].contains(self.currentSnapshot.phase) else { return }
                self.finish(callId, life, "ringing_timeout")
            }
        }
    }
    private var permission: MicrophonePermissionStatus {
        switch AVAudioSession.sharedInstance().recordPermission { case .granted: return .granted; case .denied: return .denied; default: return .notDetermined }
    }
    public func answer(callId: String, lifecycleId: String, requestId: String, completion: ((Bool) -> Void)? = nil) {
        guard matches(callId, lifecycleId), [.ringing, .permissionRequired].contains(currentSnapshot.phase) else { completion?(false); return }
        guard permission == .granted else {
            stateMachine.onPermissionRequired(callId: callId, lifecycleId: lifecycleId)
            if permission == .notDetermined {
                AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                    DispatchQueue.main.async {
                        guard let self = self, self.matches(callId, lifecycleId), granted else { completion?(false); return }
                        self.answer(callId: callId, lifecycleId: lifecycleId, requestId: requestId, completion: completion)
                    }
                }
            } else { completion?(false) }
            return
        }
        guard let session = sessionStore?.readSession(), let signal = signalingClient, let api = apiClient,
              stateMachine.onUserAnswer(callId: callId, lifecycleId: lifecycleId, requestId: requestId) else { completion?(false); return }
        signal.connectWhenBound { [weak self] ready in
            guard let self = self, self.matches(callId, lifecycleId) else { completion?(false); return }
            guard ready else { self.finish(callId, lifecycleId, "signaling_unavailable"); completion?(false); return }
            api.answer(callId: callId, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof) { [weak self] success in
                DispatchQueue.main.async {
                    guard let self = self, self.matches(callId, lifecycleId) else { completion?(false); return }
                    if success {
                        self.localAnswerAccepted = true
                        self.stateMachine.onServerAccepted(callId: callId, lifecycleId: lifecycleId)
                        self.startHeartbeat(callId, lifecycleId); self.resume(); self.startMediaIfReady()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 40) { [weak self] in
                            guard let self = self, self.matches(callId, lifecycleId), !self.transportConnected else { return }
                            self.finish(callId, lifecycleId, "media_setup_timeout")
                        }
                    }
                    else { self.finish(callId, lifecycleId, "server_answer_rejected") }
                    completion?(success)
                }
            }
        }
    }
    private func startMediaIfReady() {
        guard localAnswerAccepted, !mediaPreparation.isPreparing, !mediaPreparation.isStarted, let (sdp, generation) = offer, let id = currentSnapshot.callId, let life = currentSnapshot.lifecycleId,
              isActive(id), currentSnapshot.serverStatus == "accepted", let session = sessionStore?.readSession() else { return }
        guard mediaPreparation.begin() else { return }
        apiClient?.getIceServers(callId: id, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof) { [weak self] raw in
            DispatchQueue.main.async {
                guard let self = self, self.matches(id, life), self.offer?.1 == generation else { return }
                guard let raw = raw, let object = try? JSONSerialization.jsonObject(with: raw), let media = self.mediaEngine else { self.finish(id, life, "ice_unavailable"); return }
                let json = object as? [String: Any] ?? [:]
                let data = json["data"] as? [String: Any] ?? json
                let servers = data["iceServers"] as? [[String: Any]] ?? object as? [[String: Any]] ?? []
                self.transportConnected = false; self.reportedConnected = false
                self.stateMachine.onNegotiating(callId: id, lifecycleId: life, generation: generation)
                media.onAnswer = { [weak self] answer in
                    guard let self = self, self.matches(id, life), self.offer?.1 == generation else { return }
                    self.answerSdp = answer; self.replaySignals()
                }
                media.onCandidate = { [weak self] candidate in
                    guard let self = self, self.matches(id, life), self.offer?.1 == generation else { return }
                    let message = UUID().uuidString
                    if self.localIce.count < 256 { self.localIce.append((candidate, message)) }
                    self.signalingClient?.sendIceCandidate(callId: id, candidate: candidate, messageId: message, generation: generation)
                }
                media.onConnected = { [weak self] in
                    guard let self = self, self.matches(id, life), self.offer?.1 == generation else { return }
                    self.transportConnected = true; self.reportReady()
                }
                media.onDisconnected = { [weak self] in
                    guard let self = self, self.matches(id, life), self.offer?.1 == generation else { return }
                    self.transportConnected = false; self.reportedConnected = false
                    self.stateMachine.onTransportDisconnected(callId: id, lifecycleId: life, generation: generation)
                    self.resume()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
                        guard let self = self, self.matches(id, life), self.offer?.1 == generation, !self.transportConnected else { return }
                        self.finish(id, life, "media_connection_lost")
                    }
                }
                media.onFailed = { [weak self] in guard let self = self, self.matches(id, life), self.offer?.1 == generation else { return }; self.finish(id, life, "media_failed") }
                self.apiClient?.reportConnecting(callId: id, generation: generation, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof) { _ in }
                media.answer(sdp: sdp, iceServers: servers)
                guard self.matches(id, life), self.offer?.1 == generation else { return }
                // answer() first resets/replaces the peer. Only then may candidates enter it.
                let queued = self.mediaPreparation.peerStarted(generation: generation)
                media.setMuted(self.currentSnapshot.isMuted)
                queued.forEach { media.addCandidate($0) }
            }
        }
    }
    private func replaySignals() {
        guard let id = currentSnapshot.callId, isActive(id), let generation = offer?.1, signalingClient?.isBound == true else { return }
        if let sdp = answerSdp { signalingClient?.sendAnswer(callId: id, sdp: sdp, messageId: answerMessageId, generation: generation) }
        for (candidate, message) in localIce { signalingClient?.sendIceCandidate(callId: id, candidate: candidate, messageId: message, generation: generation) }
    }
    private func updateAudio(_ active: Bool) {
        guard let id = currentSnapshot.callId, let life = currentSnapshot.lifecycleId, isActive(id) else { return }
        stateMachine.onAudioActivation(callId: id, lifecycleId: life, active: active)
    }
    private func reportReady() {
        updateAudio(mediaEngine?.audioActive == true)
        guard transportConnected, mediaEngine?.audioActive == true, !reportedConnected,
              let id = currentSnapshot.callId, let life = currentSnapshot.lifecycleId, let session = sessionStore?.readSession(), let generation = offer?.1 else { return }
        reportedConnected = true
        apiClient?.reportConnected(callId: id, generation: generation, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof) { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self, self.matches(id, life), self.offer?.1 == generation else { return }
                guard success else { self.reportedConnected = false; self.resume(); return }
                self.stateMachine.onMediaConnected(callId: id, lifecycleId: life, generation: generation)
                self.resume()
                self.startHeartbeat(id, life)
            }
        }
    }
    private func startHeartbeat(_ id: String, _ life: String) {
        heartbeat?.invalidate()
        heartbeat = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self, self.matches(id, life), let session = self.sessionStore?.readSession() else { return }
            self.apiClient?.heartbeat(callId: id, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof) { _ in }
            self.reportReady(); self.resume()
        }
    }
    public func resume() {
        main { [weak self] in
            guard let self = self, let session = self.sessionStore?.readSession() else { return }
            let id = self.isActive(self.currentSnapshot.callId ?? "") ? self.currentSnapshot.callId : nil
            let life = self.currentSnapshot.lifecycleId
            let epoch = self.sessionEpoch
            self.apiClient?.getSnapshot(callId: id, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof) { [weak self] data in
                DispatchQueue.main.async {
                    guard let self = self, self.sessionEpoch == epoch, id == nil || self.currentSnapshot.lifecycleId == life, let data = data else { return }
                    if data["absent"] as? Bool == true {
                        if let id = id, let life = life { self.finish(id, life, "no_active_call") }
                    } else { self.handlePush(data); self.replaySignals() }
                }
            }
        }
    }
    public func reject(callId: String, lifecycleId: String, requestId: String, completion: ((Bool) -> Void)? = nil) { terminate(callId, lifecycleId, reject: true, completion: completion) }
    public func end(callId: String, lifecycleId: String, requestId: String, completion: ((Bool) -> Void)? = nil) { terminate(callId, lifecycleId, reject: [.ringing, .permissionRequired].contains(currentSnapshot.phase), completion: completion) }
    private func terminate(_ id: String, _ life: String, reject: Bool, completion: ((Bool) -> Void)?) {
        guard matches(id, life), let session = sessionStore?.readSession(), let api = apiClient else { completion?(false); return }
        stateMachine.onCallEnding(callId: id, lifecycleId: life)
        let done: (Bool) -> Void = { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self, self.currentSnapshot.callId == id, self.currentSnapshot.lifecycleId == life else { completion?(false); return }
                self.finish(id, life, success ? "user_ended" : "server_end_failed"); completion?(success)
            }
        }
        if reject { api.reject(callId: id, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof, completion: done) }
        else { api.end(callId: id, deviceSessionId: session.voiceDeviceSessionId, controlProof: session.controlProof, completion: done) }
    }
    public func setMuted(callId: String, lifecycleId: String, requestId: String, muted: Bool) {
        if stateMachine.onMuteToggled(callId: callId, lifecycleId: lifecycleId, requestId: requestId, muted: muted) { mediaEngine?.setMuted(muted) }
    }
    public func setAudioRoute(callId: String, lifecycleId: String, requestId: String, routeId: String) {
        guard matches(callId, lifecycleId), mediaEngine?.setRoute(routeId) == true else { return }
        stateMachine.onAudioRouteChanged(callId: callId, lifecycleId: lifecycleId, requestId: requestId, routeId: routeId)
    }
    private func finish(_ id: String, _ life: String, _ reason: String) {
        guard currentSnapshot.callId == id, currentSnapshot.lifecycleId == life else { return }
        terminalIds.insert(id)
        if terminalIds.count > 256 { terminalIds = [id] }
        heartbeat?.invalidate(); heartbeat = nil
        offer = nil; answerSdp = nil; localIce.removeAll(); mediaPreparation.reset(); receivedIceIds.removeAll()
        localAnswerAccepted = false; transportConnected = false; reportedConnected = false
        mediaEngine?.stopAudio()
        callKitController?.endCall(callId: id)
        stateMachine.onCallEnded(callId: id, lifecycleId: life, reason: reason)
    }
}
