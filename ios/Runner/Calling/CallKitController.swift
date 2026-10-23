import Foundation
import CallKit
import AVFoundation

public final class CallKitController: NSObject, CXProviderDelegate {
    public static let shared = CallKitController()

    private let provider: CXProvider
    private let callController = CXCallController()
    private var callUUIDMap: [String: UUID] = [:]
    private var uuidCallMap: [UUID: String] = [:]
    private let lock = NSLock()
    private var answerCompletions: [String: (Bool) -> Void] = [:]

    public var onAnswerAction: ((String) -> Void)?
    public var onEndAction: ((String) -> Void)?
    public var onMuteAction: ((String, Bool) -> Void)?
    public var onAudioSessionActivated: (() -> Void)?
    public var onAudioSessionDeactivated: (() -> Void)?

    override public init() {
        let config = CXProviderConfiguration()
        config.localizedName = "MealMate"
        config.supportsVideo = false
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]

        self.provider = CXProvider(configuration: config)
        super.init()
        self.provider.setDelegate(self, queue: DispatchQueue.main)
    }

    public func reportIncomingCall(callId: String, callerName: String, completion: ((Error?) -> Void)? = nil) {
        lock.lock()
        guard callUUIDMap[callId] == nil else { lock.unlock(); completion?(nil); return }
        let uuid = UUID()
        callUUIDMap[callId] = uuid
        uuidCallMap[uuid] = callId
        lock.unlock()

        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: callerName)
        update.localizedCallerName = callerName
        update.hasVideo = false
        update.supportsDTMF = false
        update.supportsHolding = false
        update.supportsGrouping = false
        update.supportsUngrouping = false

        provider.reportNewIncomingCall(with: uuid, update: update) { [weak self] error in
            if error != nil {
                self?.lock.lock(); self?.callUUIDMap.removeValue(forKey: callId); self?.uuidCallMap.removeValue(forKey: uuid); self?.lock.unlock()
            }
            completion?(error)
        }
    }

    /// Flutter acceptance must also execute a CallKit action so iOS activates its audio session.
    public func requestAnswer(callId: String, completion: @escaping (Bool) -> Void) {
        lock.lock()
        guard let uuid = callUUIDMap[callId], answerCompletions[callId] == nil else { lock.unlock(); completion(false); return }
        answerCompletions[callId] = completion
        lock.unlock()
        callController.request(CXTransaction(action: CXAnswerCallAction(call: uuid))) { [weak self] error in
            if error != nil { DispatchQueue.main.async { self?.completeAnswer(callId, false) } }
        }
    }
    private func completeAnswer(_ id: String, _ success: Bool) {
        lock.lock(); let completion = answerCompletions.removeValue(forKey: id); lock.unlock()
        completion?(success)
    }

    public func endCall(callId: String) {
        lock.lock()
        guard let uuid = callUUIDMap[callId] else {
            lock.unlock()
            return
        }
        callUUIDMap.removeValue(forKey: callId)
        uuidCallMap.removeValue(forKey: uuid)
        lock.unlock()

        completeAnswer(callId, false)
        provider.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
    }

    // MARK: - CXProviderDelegate

    public func providerDidReset(_ provider: CXProvider) {
        lock.lock()
        let ids = Array(callUUIDMap.keys)
        callUUIDMap.removeAll()
        uuidCallMap.removeAll()
        lock.unlock()
        for id in ids {
            completeAnswer(id, false)
            if let life = NativeCallCoordinator.shared.currentSnapshot.lifecycleId {
                NativeCallCoordinator.shared.end(callId: id, lifecycleId: life, requestId: UUID().uuidString)
            }
        }
    }

    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        lock.lock()
        let callId = uuidCallMap[action.callUUID]
        lock.unlock()

        guard let id = callId, let life = NativeCallCoordinator.shared.currentSnapshot.lifecycleId,
              NativeCallCoordinator.shared.matches(id, life) else { action.fail(); return }
        NativeCallCoordinator.shared.answer(callId: id, lifecycleId: life, requestId: UUID().uuidString) { [weak self] success in
            if success { action.fulfill() } else { action.fail() }
            self?.completeAnswer(id, success)
        }
        onAnswerAction?(id)
    }

    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        lock.lock(); let id = uuidCallMap[action.callUUID]; lock.unlock()
        guard let id = id, let life = NativeCallCoordinator.shared.currentSnapshot.lifecycleId,
              NativeCallCoordinator.shared.matches(id, life) else { action.fail(); return }
        NativeCallCoordinator.shared.end(callId: id, lifecycleId: life, requestId: UUID().uuidString) { success in
            if success { action.fulfill() } else { action.fail() }
        }
        onEndAction?(id)
    }

    public func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        lock.lock(); let id = uuidCallMap[action.callUUID]; lock.unlock()
        guard let id = id, let life = NativeCallCoordinator.shared.currentSnapshot.lifecycleId,
              NativeCallCoordinator.shared.matches(id, life) else { action.fail(); return }
        NativeCallCoordinator.shared.setMuted(callId: id, lifecycleId: life, requestId: UUID().uuidString, muted: action.isMuted)
        onMuteAction?(id, action.isMuted)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        onAudioSessionActivated?()
    }

    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        onAudioSessionDeactivated?()
    }
}
