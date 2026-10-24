import Flutter
import UIKit

public final class NativeVoiceBridge: NSObject, FlutterStreamHandler {
    public static let shared = NativeVoiceBridge()

    public static let methodChannelName = "kw.mealmate.user/voice_calls/methods"
    public static let eventChannelName = "kw.mealmate.user/voice_calls/events"

    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?

    private var coordinator: NativeCallCoordinator {
        return NativeCallCoordinator.shared
    }

    public func register(with messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: Self.methodChannelName, binaryMessenger: messenger)
        methodChannel?.setMethodCallHandler({ [weak self] (call, result) in
            self?.handle(call, result: result)
        })

        eventChannel = FlutterEventChannel(name: Self.eventChannelName, binaryMessenger: messenger)
        eventChannel?.setStreamHandler(self)

        coordinator.stateMachine.addListener { [weak self] snapshot in
            DispatchQueue.main.async {
                self?.eventSink?(snapshot.toDictionary())
                if [.ended, .idle].contains(snapshot.phase) {
                    ActiveCallPresenter.shared.dismiss()
                } else if [.ringing, .connecting, .connected, .reconnecting].contains(snapshot.phase),
                          UIApplication.shared.applicationState == .active {
                    ActiveCallPresenter.shared.presentIfActive()
                }
            }
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "handlePush":
            guard let args = call.arguments as? [String: Any], let data = args["data"] as? [String: Any] else { result(FlutterError(code: "invalid_arguments", message: "Missing push data", details: nil)); return }
            coordinator.handlePush(data)
            result(nil)
        case "resume":
            coordinator.resume()
            result(nil)
        case "getSnapshot":
            result(coordinator.currentSnapshot.toDictionary())
        case "setPresentationContext":
            result(nil)
        case "getMicrophonePermission":
            let perm = AVAudioSession.sharedInstance().recordPermission
            switch perm {
            case .granted: result("granted")
            case .denied: result("denied")
            default: result("notDetermined")
            }
        case "getCapabilities":
            result([
                "supported": true,
                "callKitAvailable": true,
                "platform": "ios"
            ])
        case "answer":
            guard let args = call.arguments as? [String: Any],
                  let callId = args["callId"] as? String,
                  let lifecycleId = args["lifecycleId"] as? String,
                  let requestId = args["requestId"] as? String else {
                result(FlutterError(code: "invalid_arguments", message: "Missing required call arguments", details: nil))
                return
            }

            if !coordinator.matches(callId, lifecycleId) {
                result(FlutterError(code: "stale_call", message: "Call is stale or mismatched", details: nil))
                return
            }

            CallKitController.shared.requestAnswer(callId: callId) { success in
                if success { result(["status": "accepted", "requestId": requestId]) }
                else { result(FlutterError(code: "command_rejected", message: "Call action could not be accepted", details: nil)) }
            }

        case "reject":
            guard let args = call.arguments as? [String: Any],
                  let callId = args["callId"] as? String,
                  let lifecycleId = args["lifecycleId"] as? String,
                  let requestId = args["requestId"] as? String else {
                result(FlutterError(code: "invalid_arguments", message: "Missing required call arguments", details: nil))
                return
            }

            if !coordinator.matches(callId, lifecycleId) {
                result(FlutterError(code: "stale_call", message: "Call is stale or mismatched", details: nil))
                return
            }

            coordinator.reject(callId: callId, lifecycleId: lifecycleId, requestId: requestId) { success in
                if success { result(["status": "accepted", "requestId": requestId]) }
                else { result(FlutterError(code: "command_rejected", message: "Call action could not be accepted", details: nil)) }
            }

        case "end":
            guard let args = call.arguments as? [String: Any],
                  let callId = args["callId"] as? String,
                  let lifecycleId = args["lifecycleId"] as? String,
                  let requestId = args["requestId"] as? String else {
                result(FlutterError(code: "invalid_arguments", message: "Missing required call arguments", details: nil))
                return
            }

            coordinator.end(callId: callId, lifecycleId: lifecycleId, requestId: requestId) { success in
                if success { result(["status": "accepted", "requestId": requestId]) }
                else { result(FlutterError(code: "command_rejected", message: "Call action could not be accepted", details: nil)) }
            }

        case "setMuted":
            guard let args = call.arguments as? [String: Any],
                  let callId = args["callId"] as? String,
                  let lifecycleId = args["lifecycleId"] as? String,
                  let requestId = args["requestId"] as? String,
                  let muted = args["muted"] as? Bool else {
                result(FlutterError(code: "invalid_arguments", message: "Missing mute parameters", details: nil))
                return
            }

            guard coordinator.matches(callId, lifecycleId) else { result(FlutterError(code: "stale_call", message: "Call is stale", details: nil)); return }
            coordinator.setMuted(callId: callId, lifecycleId: lifecycleId, requestId: requestId, muted: muted)
            result(["status": "accepted", "muted": muted])

        case "setAudioRoute":
            guard let args = call.arguments as? [String: Any],
                  let callId = args["callId"] as? String,
                  let lifecycleId = args["lifecycleId"] as? String,
                  let requestId = args["requestId"] as? String,
                  let routeId = args["routeId"] as? String else {
                result(FlutterError(code: "invalid_arguments", message: "Missing route parameters", details: nil))
                return
            }

            guard coordinator.matches(callId, lifecycleId) else { result(FlutterError(code: "stale_call", message: "Call is stale", details: nil)); return }
            coordinator.setAudioRoute(callId: callId, lifecycleId: lifecycleId, requestId: requestId, routeId: routeId)
            result(["status": "accepted", "routeId": routeId])

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        events(coordinator.currentSnapshot.toDictionary())
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
