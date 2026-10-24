# Native user voice completion

Goal: Native code owns incoming calling, signaling, media, lifecycle and system call UI on Android and iOS. Flutter owns application UI and authenticated device provisioning only.

Approved design: complete the existing native calling implementation, retain its MethodChannel/EventChannel contract and existing Flutter repository/usecase/viewmodel layers, and disable the legacy Dart media/signaling owner in production. Reuse the driver's working WebRTC SDK and v2 wire contract. No changes to the delivery project. Work in place because existing uncommitted native changes are part of the feature being completed.

## Wire contract

- Base URL https://api.trymealmate.com, hub /hubs/voice-call-v2.
- SignalR JSON protocol with record separator 0x1e, negotiate, handshake and confirmed bound before answer.
- BindDeviceSession arguments [deviceSessionId, controlProof].
- RTC SendAnswer / SendIceCandidate arguments [callId, payload, messageId, generation]. Receive rtc:offer / rtc:ice-candidate, supporting envelope and positional arguments.
- REST headers JWT, X-Voice-Device-Session and X-Voice-Device-Proof.
- Get ICE per call; process remote SDP, create real answer, set local SDP before sending answer; queue early ICE, replay answer/local ICE after rebind. Never mark connected solely after REST answer.
- REST answer/reject/end, ringing-ack, reports/connecting, reports/connected, heartbeat, GET current call and GET active. Ignore foreign/stale/terminal-revival events and late callbacks; close media and system UI together. Generation and lifecycle guard every asynchronous result.

## Task 1 Android native (independent)

- Complete VoiceSignalingClient, VoiceMediaEngine, NativeCallCoordinator and initialization. Reuse real libwebrtc 150.7871.01 APIs from driver implementation.
- sessionChanged() initializes/connects from VoiceSessionStore; clear shuts down active call and signaling.
- handlePush(Map<String,String>) handles flat and JSON envelope invites and terminal events; acknowledge displayed ringing; reconciliation recovers lost state and expires ringing using backend state.
- Keep existing Flutter methods; completion/errors reflect real server acceptance, permission state is enforced, reject/end validate lifecycle.
- Add meaningful JVM tests and run Gradle tests/build; do not edit Dart/iOS.

## Task 2 iOS native (independent)

- Complete analogous native classes, real WebRTC answerer and CallKit-owned RTCAudioSession activation.
- sessionChanged() installs/binds restored session, clears ownership on logout; VoIP token saved and exposed through session metadata.
- handlePush([String:Any]) handles envelope and flat payload; call system answer uses actual current lifecycle ID. CallKit and Flutter actions use same owner.
- Use installed flutter_webrtc WebRTC binary through existing project dependency; preserve public bridge registration.
- Add XCTest coverage and validate Swift syntax when possible; explicitly report no Xcode available on Windows. Do not edit Dart/Android.

## Task 3 Flutter provisioning and exclusive native ownership

- Register/refresh voice session with existing repository/usecase, sync access/refresh tokens and user ID into native session, connect native session once installed, forward incoming pushes and foreground resume through native bridge.
- Stop production initialization/subscription of legacy VoiceCallManager; remove its production fallback from CallingViewModel/DI. Retain legacy implementation for existing explicit legacy tests only.
- Session bootstrap handles existing cached registration, FCM rotation, APNs token metadata, logout, and resume. Native repository is sole call command/state source.
- Test credential synchronization, native ownership and stale-state handling; run relevant Flutter tests and analyzer.

## Verification and review

- Review each platform changes and end-to-end wire agreement read-only, fix confirmed defects.
- Run focused Flutter tests, Android native tests and debug build, Swift syntax parser; Xcode build and physical two-device media remain external verification on Mac/iPhone.
- Never assert physical audio verification from unit tests.
