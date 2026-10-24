import UIKit
import SwiftUI

public struct NativeCallContainerView: View {
    @State private var snapshot: NativeCallSnapshot
    private let coordinator = NativeCallCoordinator.shared

    public init() {
        self._snapshot = State(initialValue: NativeCallCoordinator.shared.currentSnapshot)
    }

    public var body: some View {
        Group {
            if [.connected, .connecting, .reconnecting].contains(snapshot.phase) {
                ActiveCallView(
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
                    onEndCall: {
                        if let callId = snapshot.callId, let life = snapshot.lifecycleId {
                            coordinator.end(callId: callId, lifecycleId: life, requestId: UUID().uuidString)
                        }
                        ActiveCallPresenter.shared.dismiss()
                    }
                )
            } else {
                IncomingCallView(
                    callerDisplay: snapshot.callerDisplay,
                    onAnswer: {
                        if let callId = snapshot.callId, let life = snapshot.lifecycleId {
                            coordinator.answer(callId: callId, lifecycleId: life, requestId: UUID().uuidString)
                        }
                    },
                    onDecline: {
                        if let callId = snapshot.callId, let life = snapshot.lifecycleId {
                            coordinator.reject(callId: callId, lifecycleId: life, requestId: UUID().uuidString)
                        }
                        ActiveCallPresenter.shared.dismiss()
                    }
                )
            }
        }
        .onAppear {
            coordinator.stateMachine.addListener { newSnap in
                DispatchQueue.main.async {
                    self.snapshot = newSnap
                    if [.ended, .idle].contains(newSnap.phase) {
                        ActiveCallPresenter.shared.dismiss()
                    }
                }
            }
        }
    }
}

public final class ActiveCallPresenter {
    public static let shared = ActiveCallPresenter()

    private var activeController: UIViewController?

    public func presentIfActive(from rootViewController: UIViewController? = nil) {
        let coordinator = NativeCallCoordinator.shared
        let snapshot = coordinator.currentSnapshot

        guard [.ringing, .connected, .connecting, .reconnecting].contains(snapshot.phase) else {
            dismiss()
            return
        }

        if activeController != nil { return }

        let container = NativeCallContainerView()
        let hosting = UIHostingController(rootView: container)
        hosting.modalPresentationStyle = .fullScreen
        hosting.modalTransitionStyle = .crossDissolve

        let top = rootViewController ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController ?? UIApplication.shared.windows.first?.rootViewController
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
