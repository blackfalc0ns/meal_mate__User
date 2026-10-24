import Foundation
import PushKit

public final class VoipPushRegistry: NSObject, PKPushRegistryDelegate {
    public static let shared = VoipPushRegistry()

    private var voipRegistry: PKPushRegistry?

    public func configure() {
        let registry = PKPushRegistry(queue: DispatchQueue.main)
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
        self.voipRegistry = registry
    }

    // MARK: - PKPushRegistryDelegate

    public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        guard type == .voIP else { return }
        let token = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(token, forKey: "voice.apnsVoipToken")
        NativeVoiceSessionBridge.shared.notifyVoipTokenChanged()
    }

    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        guard type == .voIP else {
            completion()
            return
        }

        let dict = payload.dictionaryPayload.reduce(into: [String: Any]()) { result, entry in
            if let key = entry.key as? String { result[key] = entry.value }
        }
        NativeCallCoordinator.shared.handlePush(dict)
        completion()
    }
    public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        if type == .voIP {
            UserDefaults.standard.removeObject(forKey: "voice.apnsVoipToken")
            NativeVoiceSessionBridge.shared.notifyVoipTokenChanged()
        }
    }
}
