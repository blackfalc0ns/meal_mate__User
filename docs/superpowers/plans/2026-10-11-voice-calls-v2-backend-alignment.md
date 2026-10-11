# Voice Calls v2 Backend Alignment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align the client voice-call feature with the backend voice-call contract and the supplied mobile voice-calls audit, while preserving the current architecture, REST/Hub/JSON names, `protocolVersion=2`, proof, ownership, and winning-device rules.

**Architecture:** Keep the existing feature-based Flutter architecture. Changes stay inside the calling manager, CallKit/native bridge, WebRTC service, push notification/session services, platform configuration, and focused tests. Every async operation captures call identity before its first `await` and validates ownership, lifecycle, generation, and terminal state after each awaited boundary.

**Tech Stack:** Flutter/Dart, existing REST use cases, SignalR voice hub, WebRTC, Firebase Messaging, Flutter CallKit integration, Android permissions/notifications, iOS PushKit/CallKit.

**Spec:** User-supplied voice-call audit in the attached pasted text; backend rules at `rules/rules_backend.md`; UI rules at `rules/ui_rules.md` where incoming/active screens are touched.

## Global Constraints

- Work only on branch `feature/voice-calls-v2`.
- Do not modify the backend, the other application, or hosting.
- Preserve architecture, `protocolVersion=2`, REST/Hub/JSON identifiers, proof, ownership, and winning-device behavior.
- Do not remove deadlines, timeouts, or device validation.
- Start every implementation task with a reproduction test, then make the smallest required change, then run success and regression tests.
- Product-owned new text must come from existing `ar`/`en` resources, including native call labels; never translate API identifiers.
- Never log Authorization, tokens, controlProof, SDP, ICE, address data, or raw envelopes. Safe logs may contain callId, eventId, sequence, epoch, generation, and decision reason.
- Do not apply the old patch blindly; compare it with the current branch first.
- Do not claim real-audio success without RTP evidence and an actual listening test.

---

## File Map

**Modify only when required:**

- `lib/features/calling/service/voice_call_manager.dart` — lifecycle identity, sequence/terminal ordering, ownership, answer/end/reject races, cleanup, signaling queue, connected state.
- `lib/features/calling/service/voice_callkit_service.dart` — native event ownership, programmatic-end suppression, connected/mute integration.
- `lib/features/calling/service/voice_webrtc_service.dart` — offer/answer/ICE dedupe, early ICE queue, generation and cleanup guards.
- `lib/core/services/push_notification_service.dart` — deadline clock, dedupe/terminal persistence, safe ACK and logging, recoverable registration failures.
- Existing voice device/session storage and SignalR service files — registration/session ownership and recovery only where the existing architecture requires it.
- `lib/features/calling/presentation/screens/incoming_call_screen.dart` — accepting state and single navigation owner only if required by the existing flow.
- Android manifest/native entry points — Android 14 full-screen, notification, microphone, and fallback behavior.
- `ios/Runner/AppDelegate.swift`, `ios/Runner/Info.plist`, and existing entitlements — PushKit token/callback/completion and backend registration.
- Existing calling and push tests — deterministic regression coverage.

**Do not create a new architecture or package.**

---

## Task 1: Baseline and Reproduction Harness

- [ ] Record the current commit on `feature/voice-calls-v2` and run the existing analyzer/tests.
- [ ] Add focused reproductions for stale `/active`, stale `/details`, cleanup(A) followed by incoming B, delayed end(A), duplicate answer, duplicate native ended, duplicate offer, early ICE, failed bind/reconnect, failed push display, and duplicate incoming.
- [ ] Run each reproduction before implementation and record the actual result.
- [ ] Confirm test names and helper interfaces before changing production code.

## Task 2: Call Identity and Async Ownership

- [ ] Capture `callId` and `lifecycleEpoch` before every relevant `await` in resume/reconnect, `/active`, `/details`, answer, end, reject, display, device/session, and reconciliation flows.
- [ ] Capture `generation` for WebRTC negotiation and ICE operations.
- [ ] After every `await`, reject the result if callId, lifecycleEpoch, device ownership, generation, or terminal state no longer matches.
- [ ] Ensure a stale null `/active` result cannot execute `endAllCalls` against a newer call.
- [ ] Ensure stale `/details` cannot roll Accepted/Connecting/Active back to Ringing.
- [ ] Add tests for suspended A requests completing after B starts.

## Task 3: Sequence, Terminal State, and Dedupe

- [ ] Track the latest sequence per `callId`.
- [ ] Drop older events and duplicate event/message IDs.
- [ ] Make terminal states non-revivable.
- [ ] Include `failed` in terminal cleanup.
- [ ] Preserve dedupe, latest sequence, and terminal records across background/foreground transitions and application restart using existing storage patterns.
- [ ] Test old incoming after terminal, duplicate incoming, and restart recovery.

## Task 4: Per-Call Resource Ownership and Cleanup

- [ ] Make WebRTC resources, pending RTC records, heartbeat, display state, and CallKit state belong to an explicit call/lifecycle context.
- [ ] Separate resource cleanup from global snapshot clearing.
- [ ] Make cleanup(A) close only A resources.
- [ ] Prevent delayed end/reject/details results from performing global cleanup.
- [ ] Restrict `endAllCalls` to a confirmed reconciliation case for the current owner and lifecycle.
- [ ] Test cleanup(A) while B is active and delayed HTTP end(A) after B starts.

## Task 5: CallKit and Native Event Correctness

- [ ] Ignore native actions whose event callId does not equal the current callId.
- [ ] Distinguish user-ended, programmatic-ended, timeout, system-ended, and answered-elsewhere events.
- [ ] Replace fixed 500ms-only suppression with callId/lifecycle-aware expected-event suppression.
- [ ] Clear suppression when the matching event arrives or the lifecycle ends.
- [ ] Ensure manual end sends one request and closes both sides.
- [ ] Ensure delayed native ended(A) cannot end B or send a second `/end`.
- [ ] Test native accept, decline, timeout, programmatic end, delayed event, and new lifecycle reuse.

## Task 6: Answer Flow and Navigation

- [ ] Make answer idempotent per callId and reuse an in-flight answer operation.
- [ ] Add accepting/loading state and disable repeated Accept actions.
- [ ] After answer succeeds, reconcile the authoritative state before media setup/navigation.
- [ ] Use one owner for navigation to the active-call screen.
- [ ] Navigate only after the required answer/media state succeeds; prevent early or double navigation.
- [ ] Guard all post-await emissions against disposed view models/screens.
- [ ] Test slow answer, failed answer, double tap, terminal during answer, expired Ringing with Active details, and disposed UI.

## Task 7: WebRTC Signaling, Offers, ICE, and Generation

- [ ] Dedupe pending and live records by `messageId + callId + generation`.
- [ ] Prevent duplicate `setRemoteDescription` and `createAnswer`.
- [ ] Keep a bounded early-ICE queue scoped to the call lifecycle.
- [ ] Do not drop ICE solely because the Hub is unbound; drain it after successful bind.
- [ ] Validate callId, lifecycleEpoch, generation, and terminal state before and after every WebRTC await.
- [ ] Advance and validate generation during ICE restart.
- [ ] Do not renegotiate an ended call.
- [ ] Test duplicate offers before/after initialization, early ICE, failed bind/reconnect, cleanup during getUserMedia, Wi-Fi-to-mobile transition, ICE restart, and ended-call signaling.

## Task 8: Authoritative Connected State and Timer

- [ ] Start Active duration from authoritative `connectedAtUtc`, never from Accept time.
- [ ] Require valid RTC connection/media state before `setCallConnected`.
- [ ] Treat REST connected status as insufficient proof of audible media.
- [ ] Prevent connected reports and heartbeat work after terminal state or ownership loss.
- [ ] Test connected timestamp, delayed connection, failed media setup, and terminal during connection.

## Task 9: Push Deadline, ACK, and Safe Logging

- [ ] Replace `DateTime.now()`-only deadline decisions with a trusted persisted server offset readable by background isolate.
- [ ] Recheck deadline when the app opens in foreground.
- [ ] Do not permanently ignore deadlines when time is temporarily untrusted.
- [ ] Add failed to terminal cleanup.
- [ ] Send ringing receipt only after real native presentation using the correct session; FCM delivery is not ACK.
- [ ] Move safe logging before voice-branch returns and replace empty catches with reason logs.
- [ ] Never print raw notification envelopes.
- [ ] Test ±60-minute clock skew, expired payload, duplicate incoming, failed then old incoming, restart, native display failure, and background ACK.

## Task 10: Device Registration, Session Recovery, and Winning Device

- [ ] Handle both `ApiErrorResult` and thrown exceptions.
- [ ] Retry only recoverable initialization failures and record a not-ready registration state.
- [ ] Register the current token before creating/using the voice session.
- [ ] Ensure SignalR uses the stored sessionId.
- [ ] Refresh FCM routing for the same installation without rotating an active voice session when backend behavior allows it.
- [ ] Never force registration that silently replaces the winning session.
- [ ] Clear old-account session ownership on logout; never transfer it to the next account.
- [ ] Test offline startup/recovery, token refresh during Active, logout/login, reinstall, stale proof 403 recovery, and no retry loop.

## Task 11: Android Native Behavior

- [ ] Verify Android 14 full-screen capability and a translated fallback/instruction path.
- [ ] Verify notification and microphone permission handling.
- [ ] Connect native mute to the actual WebRTC microphone track.
- [ ] Verify `setCallConnected` timing after RTC Active state.
- [ ] Test open, background, closed, locked-screen, no-Force-Stop, microphone denied, mute, speaker, and Bluetooth cases.

## Task 12: iOS PushKit and Archive Entitlements

- [ ] Complete PushKit token updates and VoIP callbacks.
- [ ] Always call callback completion.
- [ ] Register the VoIP token with the backend.
- [ ] Do not rely on `getDevicePushTokenVoIP` alone.
- [ ] Verify Archive entitlements, not only development plist values.
- [ ] Test native/app Accept, open/background/closed states, locked screen, microphone denied, mute, speaker, Bluetooth, and real iPhone delivery where iOS is supported.

## Task 13: Automated Verification

- [ ] Run `flutter analyze`.
- [ ] Run calling-specific tests.
- [ ] Run push notification tests.
- [ ] Run the full `flutter test` suite.
- [ ] Run the available debug build.
- [ ] Record every command, result, and unavailable environment dependency.

## Task 14: Real Acceptance Test and Safe Trace

- [ ] Execute: one incoming call → Accept → two-way WebRTC audio → timer after connected → end from either side closes both → new call succeeds.
- [ ] Repeat on two networks.
- [ ] Capture safe trace fields only: callId, eventId, sequence, epoch, generation, and decision reason.
- [ ] Prove audio with consecutive RTP samples from both sides and an actual listening test.
- [ ] Report anything that cannot be tested because real devices, two networks, backend behavior, Apple signing, or RTP access is unavailable.

---

## Completion Criteria

- No stale operation can change a newer call.
- No terminal call can be revived by old events.
- Cleanup is isolated per call/lifecycle.
- CallKit events are ownership-checked and idempotent.
- Offer/answer/ICE processing is deduplicated and generation-safe.
- Active/timer/connected reporting reflects authoritative RTC state and `connectedAtUtc`.
- Push deadline, ACK, dedupe, terminal handling, and logging meet the backend contract.
- Device/session recovery preserves winning-device semantics.
- Android and iOS native requirements are verified where the environment permits.
- Automated tests pass, and real audio is proven or explicitly reported as unavailable.

## Non-Goals / Backend or Environment Dependencies

- No REST, Hub, JSON, protocol, proof, ownership, or winning-device contract changes.
- No backend implementation changes.
- No changes to the other application or hosting.
- Server time offset availability, authoritative `connectedAtUtc`, RTP proof, real two-device audio, iOS Archive entitlements, and production PushKit delivery require backend/device/build access and cannot be guaranteed by client code alone.
