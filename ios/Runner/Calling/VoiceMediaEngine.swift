import Foundation
import AVFoundation
import WebRTC

/// All peer mutations are serialized on the main queue; CallKit alone activates audio.
public final class VoiceMediaEngine: NSObject, RTCPeerConnectionDelegate {
    public static let shared = VoiceMediaEngine()
    private static let ssl: Void = { _ = RTCInitializeSSL() }()
    private let factory: RTCPeerConnectionFactory
    private var peer: RTCPeerConnection?
    private var track: RTCAudioTrack?
    private var epoch = 0
    private var remoteReady = false
    private var earlyIce: [[String: Any]] = []
    public var onAnswer: ((String) -> Void)?
    public var onCandidate: (([String: Any]) -> Void)?
    public var onConnected: (() -> Void)?
    public var onDisconnected: (() -> Void)?
    public var onFailed: (() -> Void)?
    public private(set) var audioActive = false
    public override init() {
        _ = Self.ssl
        factory = RTCPeerConnectionFactory(encoderFactory: nil, decoderFactory: nil)
        super.init()
        let audio = RTCAudioSession.sharedInstance()
        audio.useManualAudio = true
        audio.isAudioEnabled = false
    }
    public func answer(sdp: String, iceServers: [[String: Any]]) {
        stopAudio()
        let attempt = epoch
        let config = RTCConfiguration()
        config.sdpSemantics = .unifiedPlan
        config.bundlePolicy = .maxBundle
        config.rtcpMuxPolicy = .require
        config.iceServers = iceServers.compactMap { server in
            let urls = server["urls"] as? [String] ?? (server["urls"] as? String).map { [$0] } ?? []
            guard !urls.isEmpty else { return nil }
            return RTCIceServer(urlStrings: urls, username: server["username"] as? String, credential: server["credential"] as? String)
        }
        guard !config.iceServers.isEmpty,
              let connection = factory.peerConnection(with: config, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil), delegate: self) else { onFailed?(); return }
        peer = connection
        let source = factory.audioSource(with: RTCMediaConstraints(mandatoryConstraints: ["googEchoCancellation": "true", "googNoiseSuppression": "true", "googAutoGainControl": "true"], optionalConstraints: nil))
        let audio = factory.audioTrack(with: source, trackId: "user-audio")
        track = audio
        guard connection.add(audio, streamIds: ["user-stream"]) != nil else { onFailed?(); return }
        let rtc = RTCAudioSession.sharedInstance()
        rtc.lockForConfiguration()
        let audioConfig = RTCAudioSessionConfiguration.webRTC()
        audioConfig.category = AVAudioSession.Category.playAndRecord.rawValue
        audioConfig.mode = AVAudioSession.Mode.voiceChat.rawValue
        audioConfig.categoryOptions = [.allowBluetooth]
        do {
            try rtc.setConfiguration(audioConfig)
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.005)
        } catch { rtc.unlockForConfiguration(); onFailed?(); return }
        rtc.unlockForConfiguration()
        rtc.isAudioEnabled = audioActive
        connection.setRemoteDescription(RTCSessionDescription(type: .offer, sdp: sdp)) { [weak self, weak connection] error in
            DispatchQueue.main.async {
                guard let self = self, let connection = connection, self.epoch == attempt else { return }
                guard error == nil else { self.onFailed?(); return }
                self.remoteReady = true
                let queued = self.earlyIce; self.earlyIce.removeAll()
                queued.forEach { self.addCandidate($0) }
                connection.answer(for: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)) { [weak self, weak connection] answer, error in
                    DispatchQueue.main.async {
                        guard let self = self, let connection = connection, self.epoch == attempt else { return }
                        guard error == nil, let answer = answer else { self.onFailed?(); return }
                        let optimizedSdp = answer.sdp.replacingOccurrences(
                            of: #"(a=fmtp:\d+ [^\r\n]+)"#,
                            with: "$1;minptime=10;useinbandfec=1;stereo=0;sprop-stereo=0;cbr=1",
                            options: .regularExpression
                        )
                        let optimizedAnswer = RTCSessionDescription(type: answer.type, sdp: optimizedSdp)
                        connection.setLocalDescription(optimizedAnswer) { [weak self] error in
                            DispatchQueue.main.async {
                                guard let self = self, self.epoch == attempt else { return }
                                if error == nil { self.onAnswer?(optimizedAnswer.sdp) } else { self.onFailed?() }
                            }
                        }
                    }
                }
            }
        }
    }
    public func addCandidate(_ data: [String: Any]) {
        guard remoteReady else { if earlyIce.count < 256 { earlyIce.append(data) }; return }
        guard let sdp = data["candidate"] as? String, let index = data["sdpMLineIndex"] as? Int, let line = Int32(exactly: index), line >= 0 else { return }
        peer?.add(RTCIceCandidate(sdp: sdp, sdpMLineIndex: line, sdpMid: data["sdpMid"] as? String), completionHandler: { _ in })
    }
    public func setMuted(_ muted: Bool) { track?.isEnabled = !muted }
    public func setRoute(_ route: String) -> Bool {
        guard ["speaker", "earpiece"].contains(route) else { return false }
        let audio = RTCAudioSession.sharedInstance()
        audio.lockForConfiguration(); defer { audio.unlockForConfiguration() }
        do { try audio.overrideOutputAudioPort(route == "speaker" ? .speaker : .none); return true } catch { return false }
    }
    public func activated(_ active: Bool) {
        audioActive = active
        let audio = RTCAudioSession.sharedInstance()
        if active { audio.audioSessionDidActivate(AVAudioSession.sharedInstance()); audio.isAudioEnabled = true }
        else { audio.isAudioEnabled = false; audio.audioSessionDidDeactivate(AVAudioSession.sharedInstance()) }
    }
    public func stopAudio() {
        epoch += 1
        remoteReady = false
        earlyIce.removeAll()
        track?.isEnabled = false
        peer?.delegate = nil
        peer?.close()
        peer = nil; track = nil
        RTCAudioSession.sharedInstance().isAudioEnabled = false
    }
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        DispatchQueue.main.async { [weak self, weak peerConnection] in
            guard let self = self, let connection = peerConnection, self.peer === connection else { return }
            var data: [String: Any] = ["candidate": candidate.sdp, "sdpMLineIndex": Int(candidate.sdpMLineIndex)]
            if let mid = candidate.sdpMid { data["sdpMid"] = mid }
            self.onCandidate?(data)
        }
    }
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCPeerConnectionState) {
        DispatchQueue.main.async { [weak self, weak peerConnection] in
            guard let self = self, let connection = peerConnection, self.peer === connection else { return }
            if newState == .connected { self.onConnected?() }
            if newState == .disconnected { self.onDisconnected?() }
            if newState == .failed { self.onFailed?() }
        }
    }
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd rtpReceiver: RTCRtpReceiver, streams: [RTCMediaStream]) { rtpReceiver.track?.isEnabled = true }
}
