# Voice Calls v2 Backend Contract Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `subagent-driven-development` or `executing-plans` to implement this plan task-by-task. Keep every checkbox updated and run the listed verification after each task.

**Goal:** Make the customer app correctly receive the backend's one-item SignalR RTC envelope, preserve Offer/ICE during Accept, report WebRTC connectivity reliably, and reconcile 409 call termination responses without false local cleanup.

**Architecture:** Preserve the existing `VoiceCallManager`, `VoiceCallSignalRService`, `VoiceWebRtcService`, repository, use cases, and ViewModel. Add only the state needed for envelope decoding, per-call/generation buffering, serialized Accept/report operations, and authoritative reconciliation. Keep REST sending as four arguments while changing only incoming RTC parsing to the backend envelope contract.

**Tech Stack:** Flutter/Dart, `signalr_netcore`, `flutter_webrtc`, existing `ApiResult`, Dio/Retrofit, injectable/GetIt, flutter_bloc, UUID v4, package:test/flutter_test.

**Spec:** `C:/Users/orignal store/.codex/attachments/1182fc98-cd47-4308-a5b1-876152b74dd6/Pasted text.txt`; backend rules: `rules/rules_backend.md` (the prompt names `rules/backend_rules.md`, but that exact path is absent).

## Global Constraints

- Change the customer app only; do not modify backend, driver app, hosting, or deployment settings.
- Do not redesign the calling architecture or add a second SignalR/WebRTC/network stack.
- Keep UUID v4 message IDs, server-time synchronization, heartbeat, deadlines, device ownership checks, and existing resource cleanup.
- Do not log JWT, `controlProof`, TURN credentials, or full SDP.
- Do not add hard-coded UI text; reuse existing localized resources if a message must change.
- Do not manually edit generated `*.g.dart` files.
- Do not commit, push, publish, or claim real-device audio success without real-device testing.
- Do not use a `FakeVoiceCallSignalRService` as proof of the real envelope contract; inject a real `HubConnection` seam for service tests.

## File Map

- Modify `lib/features/calling/service/voice_call_signalr_service.dart`: decode one-item RTC envelopes through one shared helper; reject malformed payloads safely.
- Modify `lib/features/calling/service/voice_call_manager.dart`: serialize Accept, queue Offer/ICE by call and generation, process only after WebRTC readiness, separate in-flight/successful IDs, serialize reports/retries, and make reconciliation authoritative before cleanup.
- Modify `lib/features/calling/service/voice_webrtc_service.dart` only if a small readiness/remote-description API is required; preserve existing ICE buffering and cleanup.
- Modify `lib/features/calling/presentation/manager/calling_view_model.dart` only if manager reconciliation exposes a result that the UI must render.
- Modify `lib/features/calling/data/data_source/voice_call_remote_data_source.dart`, `voice_call_remote_data_source_impl.dart`, `lib/features/calling/data/repo/voice_call_repository_impl.dart`, and `lib/features/calling/domain/usecase/answer_voice_call_usecase.dart` together only if `/answer` must return an authoritative snapshot; otherwise leave them unchanged.
- Create `test/features/calling/voice_call_signalr_service_test.dart` with an injectable/testable HubConnection seam.
- Extend `test/features/calling/voice_calls_v2_unit_test.dart` for manager sequencing, queueing, retries, stale generations, terminal cleanup, and 409 behavior.
- Extend `test/features/calling/calling_view_model_test.dart` only if the ViewModel contract changes.

## Task 1: Establish the baseline and test seam

**Files:** Test files listed above; no production changes in this task.

- [x] Confirm the working tree is clean enough to review and record the current commit.
- [x] Inspect the existing `HubConnection` construction and identify the smallest injectable seam (constructor parameter or factory) that preserves production behavior.
- [x] Add a test-only way to emit named SignalR events with `arguments` exactly as the package delivers them: `[{...envelope...}]`.
- [x] Run the focused existing calling tests before changes.

Run:

```powershell
flutter test test/features/calling
flutter test test/voice_calls_v2_unit_test.dart
```

Expected: baseline result is recorded; failures unrelated to this work are listed before implementation.

## Task 2: Decode the backend RTC envelope

**Files:** `lib/features/calling/service/voice_call_signalr_service.dart`, `test/features/calling/voice_call_signalr_service_test.dart`.

**Required helper contract:** Add one private/shared parser used by Offer, Answer, and ICE handlers. It must accept `List<Object?>? arguments` and return a validated envelope object containing `callId`, `payload`, `messageId`, and non-negative `negotiationGeneration`, or `null` for malformed input.

- [x] Write failing tests for Offer, Answer, and ICE with exactly one argument containing outer identity fields and nested `payload`.
- [x] Add tests with generation greater than zero and verify callbacks receive `callId`, the nested payload only, `messageId`, and generation.
- [x] Add tests for null/empty arguments, non-map envelope, missing call ID, missing payload, empty message ID where required, invalid generation, and wrong payload shape; assert no callback and no crash.
- [x] Keep an explicitly documented legacy four-argument fallback only if existing production compatibility requires it; the one-item envelope remains the primary path.
- [x] Implement the parser once and route all three handlers through it.
- [x] Preserve outgoing calls exactly as four arguments: `[callId, payload, messageId, generation]`.
- [x] Ensure logs contain only IDs, generation, candidate metadata, and SDP length; never full SDP or secrets.

Run:

```powershell
flutter test test/features/calling/voice_call_signalr_service_test.dart
```

## Task 3: Add per-call/generation RTC buffering and serialized Accept

**Files:** `voice_call_manager.dart`, optionally `voice_webrtc_service.dart`; tests in `voice_calls_v2_unit_test.dart`.

**State to add:** a single in-flight `Future<bool>`/completer per `callId`, a bounded queue of typed pending Offer/ICE records keyed by `callId` and generation, a set of message IDs currently processing, and a set of successfully processed message IDs. Define explicit queue limits and drop the oldest invalid/stale item with a debug log.

- [x] Write a test where Accept starts, `/answer` completes, an Offer and ICE arrive before `initializePeerConnection` completes, then verify both are processed after readiness.
- [x] Write a test for two Accept triggers for the same call; assert exactly one `/answer`, one ICE-server request, and one WebRTC initialization.
- [x] Write a test where SignalR is disconnected or device binding fails before Accept; assert Accept fails visibly and does not proceed as if connected.
- [x] Write a test where the same Offer callback fires concurrently; assert one processing operation and one answer, with the ID marked successful only after remote description, answer creation, and send succeed.
- [x] Write tests rejecting a different `callId` and older generation; ensure they never reach WebRTC.
- [x] Write a test that terminal cleanup during initialization clears pending queues and prevents later delivery to the new call.
- [x] Implement Accept as one serialized operation per call. Keep deadline cancellation, device ownership checks, and heartbeat behavior.
- [x] Do not call `handleRemoteOfferAndCreateAnswer` until PeerConnection initialization has completed.
- [x] Drain the queued Offer in arrival order, then drain ICE through `addRemoteIceCandidate`, relying on remote-description readiness.
- [x] Clear queue, processing IDs, and successful IDs on terminal cleanup, logout, and call change.
- [x] Preserve WebRTC service cleanup; never let its initialization cleanup erase manager-level pending messages.

## Task 4: Reconcile the local snapshot after successful Accept

**Files:** manager plus repository/data source/use case only if the existing `/answer` API returns a snapshot.

- [x] Inspect the actual API service declaration and response type before changing any layer.
- [x] If `/answer` returns a snapshot, map it through the existing DTO → mapper → entity flow and apply it immediately after success.
- [x] If `/answer` returns no snapshot, call the existing details/active-call reconciliation endpoint after success and apply only the authoritative returned snapshot.
- [x] Never synthesize `sequence`, `connectedAtUtc`, or `Active` locally.
- [x] Add a test proving a successful answer does not leave the local snapshot stuck at Ringing when the server reports Accepted/Connecting/Active.

## Task 5: Make connecting/connected reports reliable

**Files:** `voice_call_manager.dart`, `voice_calls_v2_unit_test.dart`.

- [x] Write tests where the first connecting report fails and the next attempt succeeds; assert the successful key is recorded only after `ApiSuccessResult`.
- [x] Write tests for repeated WebRTC state callbacks; assert no overlapping requests.
- [x] Write a test where Connected arrives before Connecting finishes; assert Connected waits for Connecting success or authoritative progress.
- [x] Write a test where terminal cleanup or generation change cancels pending retries.
- [x] Replace the current reported-only sets with separate `inFlight` and `successfullyReported` sets; remove in-flight keys in `finally`.
- [x] Add bounded, delayed, non-overlapping retry for transient failures only.
- [x] On 403/409, reconcile official call state and device ownership; never rotate device session automatically during an active call and never treat the error as success.
- [x] Start the duration timer only from an authoritative Active snapshot with `connectedAtUtc`; keep heartbeat independent.

## Task 6: Make 409 reject/end reconciliation authoritative

**Files:** `voice_call_manager.dart`, `calling_view_model.dart` if required, calling tests.

- [x] Change `_reconcileCall` to return an explicit result containing success/failure and the authoritative snapshot when available.
- [x] On 409, perform cleanup and CallKit close only when the authoritative snapshot is terminal.
- [x] If reject conflicts because the call advanced to Accepted/Connecting/Active, issue `/end` according to the official status and device ownership, with a bounded no-loop attempt.
- [x] If reconciliation fails or the call remains non-terminal, preserve the current call and return an actionable error; do not emit Rejected/Ended locally.
- [x] Keep programmatic CallKit suppression so the resulting event cannot cause a duplicate `/end`.
- [x] Add tests for 409→Active (no cleanup), 409→Ended (one cleanup), reconciliation failure (state preserved), and reject racing with client Accept.
- [x] Ensure `handleReceiverHangup` uses the same authoritative path and remains idempotent for terminal calls.

## Task 7: Verification and delivery evidence

- [x] Run formatting on changed Dart files.
- [x] Run `dart run build_runner build --delete-conflicting-outputs` only if annotations/generated contracts changed.
- [x] Run `flutter analyze` and fix all new errors/warnings.
- [x] Run `flutter test test/features/calling`.
- [x] Run `flutter test test/voice_calls_v2_unit_test.dart`.
- [x] Run the full relevant test suite if the focused tests pass.
- [x] Perform manual checks for Arabic/English switching only if UI strings changed (prefer no UI string changes).
- [x] Record whether Flutter SDK is available, whether two real devices were available, and exactly what was tested on hardware.
- [x] For real devices, verify fast/late Accept, missed ring deadline, both-side hangup, microphone/speaker, Active-based duration, >90-second heartbeat continuity, and no resurrection of terminal calls.
- [x] Do not claim production audio success from mocks or static review.

## Acceptance Criteria

- A backend RTC event delivered as `arguments = [envelope]` invokes the correct callback with nested payload and outer metadata.
- Malformed or stale RTC messages are ignored safely without crashes.
- Offer/ICE arriving during Accept are queued and processed exactly once after PeerConnection readiness.
- Duplicate Accept triggers cannot create duplicate `/answer` or WebRTC sessions.
- Failed reports can retry; successful reports are not duplicated; Connected cannot race ahead of Connecting.
- A 409 never causes local cleanup until authoritative state is terminal.
- Terminal cleanup is idempotent and clears all pending RTC state.
- Analyzer and focused tests pass, and hardware test limitations are explicitly reported.

## Handoff Notes for Gemini

Implement tasks in order. Do not skip the real SignalR service test. Before changing repository/use-case signatures, inspect the actual API response and update every layer together. Keep the final response organized by modified file, reason, result, commands and outputs, and real-device coverage.
