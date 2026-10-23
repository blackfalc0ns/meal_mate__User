import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCNlv5ZBpj7IDBUdmZOvbQzkPgAV6BXR2k")
    NativeCallCoordinator.shared.sessionChanged()
    VoipPushRegistry.shared.configure()

    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if let controller = window?.rootViewController as? FlutterViewController {
      NativeVoiceBridge.shared.register(with: controller.binaryMessenger)
      NativeVoiceSessionBridge.shared.register(with: controller.binaryMessenger)
    }

    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    NativeVoiceBridge.shared.register(with: engineBridge.pluginRegistry.registrar(forPlugin: "NativeVoiceBridge").messenger())
    NativeVoiceSessionBridge.shared.register(with: engineBridge.pluginRegistry.registrar(forPlugin: "NativeVoiceSessionBridge").messenger())
  }
}
