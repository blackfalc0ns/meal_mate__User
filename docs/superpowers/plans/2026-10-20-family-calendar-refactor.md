# Family Calendar Refactor Implementation Plan

> **For agentic workers:** Execute the tasks in order. Use the project's test-driven-development and verification-before-completion workflows. Track steps with the checkboxes below.

**Goal:** Refactor the two family calendar screens into focused sections, limit rebuilds to affected sections, and make calendar state, retries, and ViewModel ownership consistent.

**Architecture:** Keep the existing `UI → doIntent(Event) → ViewModel → UseCase → Repository → RemoteDataSource → ApiServices` flow and the single immutable `FamilyCalendarState`. Extract only real state-dependent UI sections into one-widget-per-file components. Preserve the current rendering, navigation, localization, and theme.

**Tech Stack:** Flutter, flutter_bloc, Injectable/GetIt, existing Core API result and error widgets.

**Spec:** `rules/ui_rules.md`, `rules/rules_backend.md`, and the family calendar behavior in `lib/features/family_management/calendar/`.

## Global constraints

- Do not redesign the screens or add packages.
- Use `context.colorScheme`, `context.localization`, existing styles and spacing constants, inherited direction, and existing widgets.
- Keep one widget class per widget file. Extract only useful section/rebuild boundaries, not simple layout fragments.
- Keep `FamilyCalendarState` with `copyWith`, sealed events, and UI actions routed through `doIntent`.
- Do not create new API layers or generated code unless an actual gap is found. Do not edit generated files manually.
- Respect pre-existing working-tree changes; the unrelated untracked calling plan is outside this scope.

## File map

| File | Responsibility |
| --- | --- |
| `lib/features/family_management/calendar/presentation/manager/family_calendar_event.dart` | Add dedicated day-snapshot and day-details retry intents if needed. |
| `lib/features/family_management/calendar/presentation/manager/family_calendar_state.dart` | Keep one source of truth for selected date/day and separate member-load failure if required by the existing UI behavior. |
| `lib/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart` | Handle intents, request freshness, state resets, and exact-operation retries. |
| `lib/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart` | Send the day-snapshot intent instead of calling a public state mutation. |
| `lib/features/family_management/calendar/presentation/screens/family_member_calendar_screen.dart` | Own route lifecycle, compose sections and navigation callbacks. |
| `lib/features/family_management/calendar/presentation/screens/family_day_meals_screen.dart` | Own route lifecycle, date picker and navigation callbacks; compose sections. |
| `lib/features/family_management/calendar/presentation/widgets/` | Add focused calendar-picker, selected-day-content, day-header/member, and day-meals sections only where each gives a distinct rebuild boundary. Keep existing cards/selectors. |
| `test/family_calendar_view_model_test.dart`, `test/family_calendar_capabilities_test.dart`, `test/family_member_calendar_screen_test.dart`, `test/family_day_meals_screen_test.dart`, and relevant meal-selection tests | Verify changed behavior and screen composition. |

### Task 1: Establish behavior and ownership tests

- [ ] Read the full two screens, Event/State/ViewModel, navigation args, meal-selection caller, and relevant tests. Record which routes create a ViewModel and which receive one; confirm any other screen that passes it onward.
- [ ] Add failing tests for these observable cases: a supplied ViewModel stays open when its child route is disposed; a locally created ViewModel closes; day navigation updates the same selected date used by the header, picker, request, and route arguments; a late result from an older member/day request cannot replace current data; a retry repeats only the failed operation.
- [ ] Run the new targeted tests and confirm they fail for the expected reason, not a setup error.

### Task 2: Make calendar intents and state consistent

- [ ] Add `ApplyFamilyCalendarDaySnapshotEvent` carrying `CalendarDayEntity` to the sealed event set. Route the existing `applyDaySnapshot` logic through `doIntent`; update the meal-selection caller and affected tests. Make the handler accept snapshots only for the active subscription/member context when that context is available, and keep `selectedDate`, `selectedDay`, and `days.isSelected` consistent.
- [ ] Add a dedicated day-details retry event that uses the current selected date and active subscription, leaving member/calendar data untouched. Keep calendar, capabilities, and member retries scoped to their own failed operations; preserve the originally requested member on member-load retry.
- [ ] Add request generation tokens (or equivalent exact request identity) to member, calendar, capabilities, and day loads as needed. Check `isClosed` after every awaited load before emitting. A request may update state only if it is still the latest for its operation and context.
- [ ] On member/init changes clear stale day, days, failures, and loading flags deliberately. On successful calendar refresh with no matching selected day, clear stale `selectedDay` before day details arrive. Keep existing content visible for refresh errors.
- [ ] Run ViewModel and meal-selection tests; fix regressions without altering API/Repository layers unless a verified violation blocks the behavior.

### Task 3: Split calendar screen into real rebuild sections

- [ ] Keep `Scaffold`, provider, route initialization/disposal, and navigation coordination in `family_member_calendar_screen.dart`. If `widget.viewModel` is supplied, do not close it here; close only a ViewModel created by this route. Apply the same ownership rule in Task 4.
- [ ] Move calendar expansion state into the calendar-picker section so toggling it rebuilds only that section. Its inputs are selected date, visible month, service days, loading/error state, and month/day callbacks. Compute valid date bounds and `CalendarDaysBuilder` output only when those inputs change, outside the screen-wide builder.
- [ ] Move selected meals, summary, loading/empty state, and primary action into a selected-day section. Give it only the selected day/date, relevant capability booleans, member identity, and callbacks. Preserve the existing `PageTransitionSwitcher` and animation keys unless a focused test proves a key is incorrect.
- [ ] Keep selector and errors in their own small listening boundaries. Use `BlocSelector` or narrowly defined `buildWhen` for exact fields; do not select the entire state. Preserve `ApiErrorWidget`, `InlineApiErrorWidget`, and `EmptyStateWidget` behavior from the backend rules.
- [ ] Verify widget tests for member selection, loading, empty state, errors, calendar expansion, and action navigation.

### Task 4: Split day-meals screen and unify date state

- [ ] Remove the parallel `_selectedDate` state. Initialize the ViewModel with the argument date and read `state.selectedDate` for header, date picker, API intent, and route arguments. Ignore a picker result when the route is no longer mounted; dispatch a day-select intent only if the date changed.
- [ ] Make the member selector/header, current restaurant, meal list, and review/status area separate listening sections where their dependencies differ. Keep `FamilyDayMealCard`, `FamilyDayHeader`, restaurant card, and other existing widgets. Day-detail loading/error changes should not rebuild static app bar or unrelated selector content.
- [ ] Move slot-to-icon mapping out of the screen's large build path. Preserve recognized values and the snack fallback; verify actual backend slot values before changing the mapping contract. Do not use localized display text as a new API discriminator.
- [ ] Apply the route-owned versus supplied ViewModel lifecycle rule. Keep navigation argument values synchronized with the current selected member/day, including returning from meal selection.
- [ ] Run day-screen and navigation/widget tests for day arrows, picker, member switch, meal actions, and disposal.

### Task 5: UI-rule pass and validation

- [ ] Review every changed widget for one class per file, needed `color`/`locale` declarations, theme colors, existing styles/spacing, inherited RTL/LTR direction, `const`, and safe controller/animation lifecycle. Reuse existing components before adding files.
- [ ] Check every reactive section's selected fields. Verify that changing expansion rebuilds only the picker, a day detail response rebuilds day content, and a capability response rebuilds only permission-dependent controls/errors. Use Flutter DevTools rebuild tracking if available; otherwise report the limitation and do not claim measured performance gains.
- [ ] Run `dart format` on changed Dart files, targeted Flutter tests, and `flutter analyze` (or targeted analysis if project-wide pre-existing errors prevent a clean run). Run `build_runner` only if Injectable or other generated inputs changed.
- [ ] Review `git diff` to confirm only scoped files changed and existing visual behavior, localization, RTL/LTR, routes, and API flow are preserved.

## Completion criteria

- Both screens retain their current appearance and behavior while each state-dependent section listens only to its required fields.
- The selected date has one authoritative value. Old network responses do not overwrite a newer selection.
- Retry repeats the failed member/calendar/day/capability operation specifically.
- Child routes do not close a ViewModel supplied by another route.
- Targeted tests and analyzer pass, or any pre-existing failures are named separately with command output.
