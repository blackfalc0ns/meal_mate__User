# Unified Call Screen Implementation Plan

> **For agentic workers:** Execute each task with tests and review before proceeding.

**Goal:** Render the same Flutter incoming and active call screens when the app is foregrounded or launched from a call on Android and iOS.

**Architecture:** Keep native call engines, notifications, CallKit, and media ownership. Use the existing native snapshot bridge as the single state source. Route the user into the existing Flutter call screen when the app UI is available, including cold launch after answering. Native UI remains a short-lived fallback until Flutter is ready.

**Tech Stack:** Flutter, Android Kotlin, iOS Swift, native Method/Event channels.

**Reference:** `lib/features/calling/presentation/screens/incoming_call_screen.dart` and `active_call_screen.dart`.

## Constraints

- Preserve native answer, reject, audio, and lock-screen behavior.
- Never let both native and Flutter screens issue the same call action.
- Preserve existing Arabic/English localization and theme rules in `rules/ui_rules.md`.
- Native system call surfaces and OS status/navigation bars cannot be made pixel-identical to Flutter across platforms.
- Compare screenshots at the same device size, font scale, locale, system UI mode, and call state.

## Task 1: Freeze the visual and state contract

**Files:** Existing Flutter call screens, `CallingState`, native snapshot models on Android/iOS, relevant UI tests.

- [ ] Capture approved Flutter incoming and active screen screenshots at agreed Android and iPhone viewport sizes, Arabic and English, and specified elapsed time.
- [ ] Inventory every displayed field, action, placeholder, icon, spacing, color, image, and timer behavior.
- [ ] Map each Flutter field to the native snapshot. Add any missing display fields to the snapshot bridge only if present in the push payload; keep fallback values explicit.
- [ ] Test snapshot mapping for missing/null fields and duplicate incoming events.

## Task 2: Make Flutter the only in-app call renderer

**Files:** `lib/features/calling/service/voice_navigation_coordinator.dart`, `lib/features/calling/presentation/screens/{incoming_call_screen,active_call_screen}.dart`, `android/app/src/main/kotlin/kw/mealmate/user2/calling/ui/IncomingCallActivity.kt`, `ios/Runner/Calling/ActiveCallPresenter.swift`.

- [ ] Define one owner for showing and closing call routes. Test incoming, answering, active, cancellation, timeout, and app-resume transitions for exactly one route change each.
- [ ] When Android opens from notification or full-screen intent, retain the native coordinator and launch/foreground Flutter; pass the call ID, then reconcile the current native snapshot before routing.
- [ ] Keep the Android Compose screen only as a temporary fallback during Flutter engine startup or when Flutter cannot be shown. Once Flutter is ready, finish the native Activity to avoid two visible screens.
- [ ] When iOS CallKit answer launches the app, route to Flutter's active call screen from the existing native snapshot instead of presenting `ActiveCallView` in SwiftUI. Keep CallKit as the audio/session owner.
- [ ] Test cold launch, warm background, foreground, locked device, and app-process recreation. Verify actions are idempotent and audio remains active across the UI handoff.

## Task 3: Match system chrome around the Flutter screen

**Files:** Android Activity theme/manifest, Flutter call screen system UI style, iOS window/status-bar configuration as needed.

- [ ] Remove the separate Android Activity action bar (`Meal Mate`) while it is visible as fallback.
- [ ] Align status bar, navigation bar, safe area, and display cutout treatment with the Flutter reference.
- [ ] Verify no black or white flash during the native-to-Flutter handoff.

## Task 4: Visual and functional acceptance

- [ ] Run Flutter call-screen widget/golden tests at fixed viewport, text scale, locale, and call state.
- [ ] Run Android native unit tests and a debug build; run iOS tests/build on macOS.
- [ ] Compare real-device screenshots for foreground and cold-launch flows. Iterate until the in-app Flutter frames are rendered by the same widget tree and visual differences within each platform are eliminated.
- [ ] Test answer, reject, cancel by driver, missed call, lock/unlock, microphone permission, mute, speaker, and call end on both platforms.
- [ ] Confirm no duplicate notification/ringtone, no duplicate route pop, and no media disconnection during handoff.

## Acceptance boundary

The Flutter call UI can be the exact same implementation for all in-app paths. Android system notifications/full-screen system affordances and iOS CallKit's system screen retain OS-controlled appearance. Cold launch may briefly show a native/loading frame before Flutter is ready; measure and minimize that transition rather than claiming a platform-wide pixel-perfect 100% match.
