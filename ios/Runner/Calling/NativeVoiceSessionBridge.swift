import Flutter
import UIKit

public final class NativeVoiceSessionBridge: NSObject {
    public static let shared = NativeVoiceSessionBridge()
    public static let channelName = "kw.mealmate.user/voice_session/methods"

    private var methodChannel: FlutterMethodChannel?
    private let sessionStore = VoiceSessionStore.shared

    public func register(with messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
        methodChannel?.setMethodCallHandler({ [weak self] (call, result) in
            self?.handle(call, result: result)
        })
    }

    public func notifyVoipTokenChanged() {
        let notify: () -> Void = { [weak self] in
            self?.methodChannel?.invokeMethod("voipTokenChanged", arguments: nil)
        }
        if Thread.isMainThread { notify() } else { DispatchQueue.main.async { notify() } }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getSessionMetadata":
            result(sessionStore.getMetadata())

        case "installSession":
            guard let args = call.arguments as? [String: Any],
                  let accountId = args["accountId"] as? String,
                  let voiceDeviceSessionId = args["voiceDeviceSessionId"] as? String,
                  let controlProof = args["controlProof"] as? String else {
                result(FlutterError(code: "invalid_arguments", message: "Missing required session parameters", details: nil))
                return
            }

            let expectedRev = (args["expectedRevision"] as? Int) ?? 0
            let data = VoiceSessionData(
                sessionRevision: expectedRev,
                accountId: accountId,
                voiceDeviceSessionId: voiceDeviceSessionId,
                controlProof: controlProof,
                accessToken: args["accessToken"] as? String,
                refreshToken: args["refreshToken"] as? String,
                expiresAtUtc: args["expiresAtUtc"] as? String
            )

            let outcome = sessionStore.installSession(expectedRevision: expectedRev, data: data)
            if outcome.success {
                NativeCallCoordinator.shared.sessionChanged()
                result(["status": "installed", "sessionRevision": outcome.newRevision])
            } else {
                result(FlutterError(code: "conflict_revision", message: "Expected revision mismatch", details: nil))
            }

        case "readSessionTokens":
            let expected = (call.arguments as? [String: Any])?["expectedRevision"] as? Int
            guard let session = sessionStore.readSession(), expected == session.sessionRevision else {
                result(FlutterError(code: "conflict_revision", message: "Session changed", details: nil)); return
            }
            result(["accountId": session.accountId, "accessToken": session.accessToken ?? "", "refreshToken": session.refreshToken ?? ""])

        case "readAccessToken":
            result(sessionStore.readAccessToken())

        case "refreshSession":
            guard let args = call.arguments as? [String: Any],
                  let expectedRev = args["expectedRevision"] as? Int,
                  let newAccessToken = args["accessToken"] as? String else {
                result(FlutterError(code: "invalid_arguments", message: "Missing refresh parameters", details: nil))
                return
            }

            let outcome = sessionStore.refreshSession(expectedRevision: expectedRev, newAccessToken: newAccessToken)
            if outcome.success {
                NativeCallCoordinator.shared.sessionChanged()
                result(["status": "refreshed", "sessionRevision": outcome.newRevision, "accessToken": newAccessToken])
            } else {
                result(FlutterError(code: "conflict_revision", message: "Expected revision mismatch", details: nil))
            }

        case "clearSession":
            let expectedRev = (call.arguments as? [String: Any])?["expectedRevision"] as? Int ?? 0
            let outcome = sessionStore.clearSession(expectedRevision: expectedRev)
            if outcome.success {
                NativeCallCoordinator.shared.sessionChanged()
                result(["status": "cleared", "sessionRevision": outcome.newRevision])
            } else { result(FlutterError(code: "conflict_revision", message: "Expected revision mismatch", details: nil)) }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
