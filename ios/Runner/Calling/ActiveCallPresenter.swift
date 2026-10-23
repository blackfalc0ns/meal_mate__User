import UIKit
import SwiftUI

public final class ActiveCallPresenter {
    public static let shared = ActiveCallPresenter()

    private var activeController: UIViewController?

    public func presentIfActive(from rootViewController: UIViewController? = nil) {
        let coordinator = NativeCallCoordinator.shared
        let snapshot = coordinator.currentSnapshot

        guard [.connected, .connecting].contains(snapshot.phase) else {
            dismiss()
            return
        }

        if activeController != nil { return }

        let callView = ActiveCallView(
            callerDisplay: snapshot.callerDisplay,
            elapsedSeconds: snapshot.elapsedSeconds,
            isMuted: snapshot.isMuted,
            isSpeaker: snapshot.audioRouteId == "speaker",
            onToggleMute: {
                if let callId = snapshot.callId, let life = snapshot.lifecycleId {
                    coordinator.setMuted(callId: callId, lifecycleId: life, requestId: UUID().uuidString, muted: !snapshot.isMuted)
                }
            },
            onToggleSpeaker: {
                if let callId = snapshot.callId, let life = snapshot.lifecycleId {
                    let nextRoute = snapshot.audioRouteId == "speaker" ? "earpiece" : "speaker"
                    coordinator.setAudioRoute(callId: callId, lifecycleId: life, requestId: UUID().uuidString, routeId: nextRoute)
                }
            },
            onEndCall: { [weak self] in
                if let callId = snapshot.callId, let life = snapshot.lifecycleId {
                    coordinator.end(callId: callId, lifecycleId: life, requestId: UUID().uuidString)
                }
                self?.dismiss()
            }
        )

        let hosting = UIHostingController(rootView: callView)
        hosting.modalPresentationStyle = .fullScreen
        hosting.modalTransitionStyle = .crossDissolve

        let top = rootViewController ?? UIApplication.shared.windows.first?.rootViewController
        top?.present(hosting, animated: true) { [weak self] in
            self?.activeController = hosting
        }
    }

    public func dismiss() {
        activeController?.dismiss(animated: true) { [weak self] in
            self?.activeController = nil
        }
    }
}
