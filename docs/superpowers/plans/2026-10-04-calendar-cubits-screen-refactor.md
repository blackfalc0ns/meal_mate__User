# Calendar Cubits and Screen Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split Calendar into three focused Cubits plus a small flow/effect Cubit, remove business/error/navigation orchestration from large screens, and constrain every reactive rebuild to the smallest useful UI section.

**Architecture:** `CalendarOverviewCubit` owns calendar/day state, `RestaurantPickerCubit` owns restaurant search/selection state, and `MealSelectionCubit` owns available meals, selection, pagination, save, and confirm state. `CalendarFlowCubit` coordinates explicit cross-flow commands and emits one-off typed UI effects; it never mirrors child states, subscribes to child streams, or owns their lifecycle. Calendar error-code literals are centralized in `SubscriptionErrorCodes`, while localization remains in a presentation mapper.

**Tech Stack:** Flutter, Dart 3.12, flutter_bloc 8.1.6, get_it/injectable, Dio/Retrofit, flutter_test.

**Spec:** User-approved architecture discussion from 2026-10-04, `AGENTS.md`, `rules/ui_rules.md`, and `lib/core/errors/subscription_error_codes.dart`.

## Global Constraints

- Read `AGENTS.md` and `rules/ui_rules.md` before implementation.
- `rules/backend_rules.md` is currently missing although `AGENTS.md` requires it. Restore it or obtain explicit repository-owner approval before changing Cubits/use-case integration; do not invent its rules.
- Preserve current UI, API routes, localized copy, navigation behavior, and business behavior.
- Preserve all uncommitted calendar race-guard work already present in the working tree; never reset, checkout, stash, or overwrite it.
- No new package and no new state-management approach.
- No `setState` in `CalendarScreen`, `CalendarScreenBody`, or `CalendarContent`.
- Local visual state may use `setState` only inside the smallest isolated widget that owns it and only when its rebuild cannot include the whole screen. Prefer moving current expanded/month state into `CalendarPickerSection`; do not put purely visual state into a business Cubit.
- Each state owner is the single source of truth for its data. `CalendarFlowCubit` must not copy overview, restaurant, or meal state.
- Child Cubits must not import, read, or subscribe to `CalendarFlowCubit` or each other.
- `CalendarFlowCubit` may invoke explicit public methods on child Cubits but must not call `stream.listen` on them.
- UI navigation, sheets, snackbars, and localized messages remain in presentation.
- Backend error-code strings must not remain in calendar screens/Cubits/tests; use constants from `SubscriptionErrorCodes`.
- Use `BlocSelector`/`listenWhen` with immutable projection values. Never watch a complete state when only one field is rendered.
- One custom widget class per file, per `rules/ui_rules.md`.
- Use TDD for behavior changes and commit each task independently without staging unrelated asset/calendar work.

## Target Ownership

```text
presentation/
├── calendar_home/
│   ├── calendar_screen.dart
│   ├── calendar_screen_body.dart
│   ├── calendar_screen_effects.dart
│   └── widgets/
│       ├── calendar_picker_section.dart
│       └── calendar_selected_day_section.dart
├── restaurant_picker/
│   ├── calendar_restaurant_picker_sheet.dart
│   └── widgets/
├── meal_selection/
│   ├── calendar_meal_selection_screen.dart
│   └── widgets/
├── shared/widgets/
├── manager/
│   ├── overview/
│   ├── restaurant_picker/
│   ├── meal_selection/
│   └── flow/
├── mapper/calendar_failure_message_mapper.dart
└── helpers/
```

This layout is produced by moving the single current canonical implementation. Never copy it and leave a second implementation behind.

## Required Public Interfaces

```dart
class CalendarOverviewCubit extends Cubit<CalendarOverviewState> {
  Future<void> loadCalendar({String? subscriptionId, required String localeName});
  Future<void> selectDay({required CalendarDayEntity day, required String localeName});
  void replaceDay(CalendarDayEntity day);
}

class RestaurantPickerCubit extends Cubit<RestaurantPickerState> {
  Future<void> load({required String subscriptionId, required DateTime date,
    required String localeName, String? query});
  Future<ApiResult<CalendarDayEntity>> selectRestaurant({...});
  void clear();
}

class MealSelectionCubit extends Cubit<MealSelectionState> {
  Future<void> load({...});
  void toggleMeal(String mealId);
  Future<void> loadMore({required String slot, required String localeName});
  Future<ApiResult<CalendarDayEntity>> save({required String localeName});
  Future<ApiResult<CalendarDayEntity>> autoSelect({required String localeName});
  Future<ApiResult<CalendarDayEntity>> confirm({required String localeName});
  void clear();
}

class CalendarFlowCubit extends Cubit<CalendarFlowState> {
  Future<void> startRestaurantPicker(String localeName);
  Future<void> acceptRestaurant(CalendarRestaurantOptionEntity restaurant,
    String localeName);
  Future<void> saveMeals(String localeName);
  Future<void> confirmMeals(String localeName);
}
```

Exact formatting may vary, but ownership and direction of dependency may not.

---

### Task 1: Capture and Test the Current Behavior

**Files:**
- Read: `lib/features/calendar/**`
- Read: `lib/core/errors/subscription_error_codes.dart`
- Test: existing `test/calendar_*_test.dart`
- Create: `test/calendar_flow_characterization_test.dart`

**Interfaces:**
- Consumes: current combined `CalendarViewModel` behavior.
- Produces: regression coverage for the behavior the new Cubits must preserve.

- [ ] Record `git status --short` and `git diff -- lib/features/calendar lib/core/errors/subscription_error_codes.dart`; keep a list of pre-existing edits.
- [ ] Run `flutter analyze lib/features/calendar` and every `test/calendar_*_test.dart`; stop and report pre-existing failures.
- [ ] Add characterization tests covering: initial load, day switch, restaurant selection followed by meal load, meal toggle/slot replacement, load-more merge, save success, confirm success, selection-locked failure, day-unavailable refresh, duplicate mutation rejection, and stale response rejection.
- [ ] Use controllable repository fakes with `Completer<ApiResult<T>>`; do not call real APIs.
- [ ] Run the new test and confirm it passes against current behavior before structural migration.
- [ ] Commit only the characterization test: `test(calendar): characterize flow before cubit split`.

---

### Task 2: Centralize Calendar Error Codes and Presentation Mapping

**Files:**
- Modify: `lib/core/errors/subscription_error_codes.dart`
- Create: `lib/features/calendar/presentation/mapper/calendar_failure_message_mapper.dart`
- Create: `test/calendar_failure_message_mapper_test.dart`
- Modify: `test/calendar_confirm_meals_test.dart`

**Interfaces:**
- Produces these exact constants:

```dart
static const String calendarBoxIncomplete = 'calendar.box_incomplete';
static const String calendarSelectionLocked = 'calendar.selection_locked';
static const String calendarDayUnavailable = 'calendar.day_unavailable';
static const String calendarFulfillmentNotReady =
    'calendar.fulfillment_not_ready';
static const String commonNotFound = 'errors.common.not_found';
```

- [ ] Write mapper tests for all four calendar codes, unknown failure with safe backend message, and unknown empty message falling back to `locale.error_unknown_desc`.
- [ ] Add a clearly labelled `Calendar flow` section to `SubscriptionErrorCodes`; retain its class name to avoid unrelated migration.
- [ ] Implement `CalendarFailureMessageMapper.map({required Failure failure, required AppLocalizations locale})` using the constants, never raw strings.
- [ ] Replace error-code literals in calendar tests with `SubscriptionErrorCodes` constants.
- [ ] Run `rg -n "calendar\.(box_incomplete|selection_locked|day_unavailable|fulfillment_not_ready)|errors\.common\.not_found" lib/features/calendar test/calendar_* --glob "*.dart"`; allowed literal definitions exist only in `subscription_error_codes.dart`.
- [ ] Run mapper and confirm tests plus analyzer.
- [ ] Commit: `refactor(calendar): centralize error codes and messages`.

---

### Task 3: Extract `CalendarOverviewCubit`

**Files:**
- Create: `presentation/manager/overview/calendar_overview_state.dart`
- Create: `presentation/manager/overview/calendar_overview_cubit.dart`
- Create: `test/calendar_overview_cubit_test.dart`
- Migrate logic from: `calendar_view_model_days.dart`

**Interfaces:**
- `CalendarOverviewState` owns subscription, calendar, days, selected date, calendar/day loading, no-subscription, and calendar failure.
- It exposes computed `selectedDay`, `hasCalendarData`, and `canConfirmSelectedDayMeals` only when based exclusively on overview-owned fields.

- [ ] Write tests for subscription resolution, not-found retry, initial date, rapid day switching, selected-day failure, and `replaceDay` preserving existing meals when the response omits them.
- [ ] Implement immutable state and `copyWith` with explicit clear flags for nullable fields.
- [ ] Move current calendar/day request-generation guards intact; stale requests must not finalize loading or failure state.
- [ ] Replace raw `errors.common.not_found` checks with `SubscriptionErrorCodes.commonNotFound` for both `failure.code` and backend code.
- [ ] Expose `replaceDay` as the only cross-flow mutation entry point; validate matching date internally.
- [ ] Run overview tests, existing no-subscription tests, and analyzer.
- [ ] Commit: `refactor(calendar): extract overview cubit`.

---

### Task 4: Extract `RestaurantPickerCubit`

**Files:**
- Create: `presentation/manager/restaurant_picker/restaurant_picker_state.dart`
- Create: `presentation/manager/restaurant_picker/restaurant_picker_cubit.dart`
- Create: `test/calendar_restaurant_picker_cubit_test.dart`
- Migrate logic from: `calendar_view_model_restaurants.dart`

**Interfaces:**
- State owns restaurants, query, loading, and failure only.
- Each request receives subscription/date/locale explicitly; it must not reach into overview state.

- [ ] Test initial load, search query forwarding, newer-query-wins, clear, retry context, selection success/failure, and a newer restaurant selection invalidating the older response.
- [ ] Preserve the existing UI debounce in the search widget; Cubit request generations remain necessary for out-of-order responses.
- [ ] Implement `selectRestaurant` returning `ApiResult<CalendarDayEntity>`; do not mutate overview or open meal pages.
- [ ] Prevent duplicate selection of the same restaurant while allowing a newer different choice.
- [ ] Run restaurant request/backend-state tests and analyzer.
- [ ] Commit: `refactor(calendar): extract restaurant picker cubit`.

---

### Task 5: Extract `MealSelectionCubit`

**Files:**
- Create: `presentation/manager/meal_selection/meal_selection_state.dart`
- Create: `presentation/manager/meal_selection/meal_selection_cubit.dart`
- Create: `test/calendar_meal_selection_cubit_test.dart`
- Migrate logic from: `calendar_view_model_meals.dart`, `calendar_view_model_actions.dart`

**Interfaces:**
- State owns available meals, selected IDs, loading-more, save/confirm loading, and its failures.
- State computed properties own required count, `canSave`, and slot validation.

- [ ] Test load, stale restaurant/day responses, toggle rules, blocked meal, per-slot replacement, pagination deduplication, save, auto-select, confirm, duplicate submissions, and all failure paths.
- [ ] Accept immutable flow context (`subscriptionId`, date, restaurant ID) at load time and retain only that context; clear it on `clear()`.
- [ ] Preserve request generations already added in the working tree.
- [ ] Use `SubscriptionErrorCodes.calendarSelectionLocked` and `.calendarDayUnavailable`; return results/effects to the flow layer rather than refreshing overview directly.
- [ ] Keep `CalendarMealsMerger` pure and reuse it.
- [ ] Run toggle, confirm, request-race, merger, and analyzer checks.
- [ ] Commit: `refactor(calendar): extract meal selection cubit`.

---

### Task 6: Add Typed Flow Effects and `CalendarFlowCubit`

**Files:**
- Create: `presentation/manager/flow/calendar_flow_effect.dart`
- Create: `presentation/manager/flow/calendar_flow_state.dart`
- Create: `presentation/manager/flow/calendar_flow_cubit.dart`
- Create: `test/calendar_flow_cubit_test.dart`

**Interfaces:**
- Effects: `OpenRestaurantPickerEffect`, `OpenMealPickerEffect`, `CloseMealPickerEffect`, `MealsSavedEffect`, `MealsConfirmedEffect`, and `CalendarFailureEffect`.
- Every effect has a monotonically increasing `int id` so a listener handles it exactly once.

- [ ] Write tests proving the flow invokes explicit child methods, updates overview through `replaceDay`, emits one effect per outcome, and never mirrors child state.
- [ ] Constructor receives the three child Cubits. It does not create or close them and must contain no `stream.listen`.
- [ ] On restaurant success: replace overview day, load meals with returned day/restaurant context, then emit open-meal effect.
- [ ] On save success: replace overview day, emit saved/close effect.
- [ ] On confirm success: replace overview day and force non-editable status if required by existing behavior, then emit confirmed effect.
- [ ] On selection-locked: update current day lock state using the centralized constant, then emit failure.
- [ ] On day-unavailable: request overview reload using the centralized constant, then emit failure.
- [ ] Run flow tests and characterization tests.
- [ ] Commit: `refactor(calendar): add calendar flow coordinator`.

---

### Task 7: Register and Provide the Four Cubits Safely

**Files:**
- Modify: DI annotations/constructors for the four Cubits.
- Modify generated DI files only via build runner.
- Modify: canonical `calendar_screen.dart`.

**Interfaces:**
- Screen owns all four instances and closes each once.
- `CalendarFlowCubit` never closes children.

- [ ] Add `@injectable` to each Cubit and verify use-case constructor dependencies.
- [ ] In `CalendarScreen.initState`, obtain the three child Cubits, then construct/resolve Flow Cubit with those exact instances.
- [ ] Provide them using `MultiBlocProvider.value`; do not use nested `create` callbacks that depend on provider ordering.
- [ ] Close Flow first, then child Cubits in `dispose`, using the project lifecycle pattern.
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`, inspect generated diffs, and ensure unrelated generated output is not staged.
- [ ] Add a widget test proving one instance per Cubit and one close per instance.
- [ ] Commit: `refactor(calendar): provide split calendar cubits`.

---

### Task 8: Extract Screen Body, Effects, and Navigation

**Files:**
- Move/modify: `presentation/calendar_home/calendar_screen.dart`
- Create: `presentation/calendar_home/calendar_screen_body.dart`
- Create: `presentation/calendar_home/calendar_screen_effects.dart`
- Create: `presentation/calendar_home/calendar_navigation_coordinator.dart`
- Create: `test/calendar_screen_effects_test.dart`
- Modify imports in router/app shell to the single canonical screen.

**Interfaces:**
- Body renders only header/content.
- Effects listens only to `CalendarFlowCubit` effect ID.
- Coordinator performs restaurant bottom sheet, meal page route, close, confirmation sheet, meal-details navigation, and snackbars.

- [ ] Test that every typed effect produces exactly one UI action even after unrelated state emissions.
- [ ] Move `_mapConfirmErrorMessage` out completely; use `CalendarFailureMessageMapper` inside effects.
- [ ] Rename every meal `Sheet` flag/member to `MealPicker`; restaurant remains `Sheet`.
- [ ] Keep `BuildContext` as a method argument, never a stored field; check `context.mounted` after every `await`.
- [ ] Remove silent `catch (_) {}` back handling. Retain existing behavior through an explicit optional callback or a tested app-shell integration.
- [x] `CalendarScreen` must contain no failure-code switch, snackbar, modal call, route removal, success counters, or loading-button controller.
- [x] Run navigation/effect/header tests and analyzer.
- [x] Commit: `refactor(calendar): extract screen effects and navigation`.

---

### Task 9: Make the Meal Save Button Declarative

**Files:**
- Modify: `calendar_meal_selection_screen.dart`
- Modify: `calendar_meal_save_button.dart`
- Remove dependency usage: `RoundedLoadingButtonController` from calendar screen flow.
- Create/modify: `test/calendar_meal_save_button_test.dart`

**Interfaces:**
- Button receives `isLoading`, `enabled`, and `onPressed`.

- [x] Write tests for idle/enabled, disabled, saving, confirming, success navigation, and failure returning to idle.
- [x] Replace controller `start/stop/reset` calls with `BlocSelector<MealSelectionCubit, MealSelectionState, ({bool loading, bool enabled})>`.
- [x] Do not replace the package globally; only remove imperative ownership from Calendar if the visual component can preserve its appearance.
- [x] Confirm selection-only state does not rebuild static header/restaurant sections.
- [x] Run tests and commit: `refactor(calendar): make meal save state declarative`.

---

### Task 10: Establish Fine-Grained Rebuild Boundaries Without Screen `setState`

**Files:**
- Create: `calendar_picker_section.dart`
- Create: `calendar_selected_day_section.dart`
- Modify: `calendar_content.dart`, `calendar_picker_panel.dart`
- Create: `test/calendar_rebuild_scope_test.dart`

**Interfaces:**
- Picker observes only days/selected date and owns expanded/focused-month visual state.
- Selected-day section observes only selected day/loading/confirm capability.

- [x] Add test build counters for header, picker, selected-day content, restaurant sheet, meal page, and save button.
- [x] Move `_isExpanded`, `_focusedMonth`, and empty-calendar month state out of `CalendarContent` into the smallest picker section.
- [x] Remove every `setState` from `CalendarContent`; a local `setState` inside picker section is permitted only if tests prove it rebuilds that section alone.
- [x] Use selectors with immutable records/view data; preserve list identity and avoid mapping/sorting in builders.
- [x] Assert restaurant loading does not rebuild calendar home; meal toggle does not rebuild overview; confirm loading rebuilds only selected-day action and meal save button.
- [x] Run rebuild tests and record before/after counts in commit body.
- [x] Commit: `perf(calendar): isolate calendar rebuild boundaries`.

---

### Task 11: Move Files by Flow and Remove the Old Combined Manager

**Files:**
- Move canonical widgets/screens into target ownership tree.
- Delete after zero imports: `calendar_view_model.dart`, four mixin files, `calendar_state.dart`, `calendar_state_extensions.dart`, `calendar_event.dart`.
- Update all tests and consumers.

**Interfaces:**
- Produces one implementation per class and no legacy combined manager.

- [x] Use `rg` to enumerate imports before every move; update external family-calendar imports for shared widgets only.
- [x] Move files, never copy-and-leave duplicates.
- [x] Keep shared widgets only when two flows/features consume them; otherwise place them with their owning flow.
- [x] Search for legacy symbols (`CalendarViewModel`, `CalendarState`, `CalendarEvent`) and require zero matches outside historical plan docs.
- [x] Run structure test, all calendar tests, and dependent family-calendar tests.
- [x] Commit: `refactor(calendar): organize presentation by flow`.

---

### Task 12: Final Verification

**Files:**
- Modify only to fix regressions caused by this plan.

- [x] Run `dart format` only on files changed by this plan.
- [x] Run `flutter analyze` and `flutter test`.
- [x] Run every calendar and dependent family-calendar test explicitly.
- [x] Search for raw calendar/common error literals; definitions must exist only in `SubscriptionErrorCodes`.
- [x] Search for `setState` in calendar screens/content. Accept it only in isolated local widgets with a documented rebuild boundary.
- [x] Search for `stream.listen` and cross-Cubit imports; require none among the four Cubits.
- [x] Use DevTools “Track widget rebuilds” while switching days, searching restaurants, toggling meals, loading more, saving, and confirming. Record counts; do not claim optimization without measurement.
- [x] Validate one RTL and one LTR configured locale.
- [x] Inspect `git diff --stat` and ensure pre-existing asset/calendar work was preserved and no unrelated file was staged.

## Acceptance Criteria

- Three focused data/state Cubits and one effect-only Flow Cubit replace the combined manager.
- No child Cubit depends on another child or Flow Cubit.
- Flow Cubit does not mirror states, listen to streams, or own child lifecycle.
- Calendar screen/body contain no business logic, error-code mapping, imperative loading controller, or screen-level `setState`.
- Restaurant picker is a bottom sheet; meal picker is a normal page and all names reflect that.
- All specified codes are stored in `SubscriptionErrorCodes`; localization is handled by `CalendarFailureMessageMapper`.
- Each UI section selects only the state it renders.
- Existing request-generation/race protections and behavior remain intact.
- There is one canonical implementation per screen/widget.
- Analyzer, full tests, RTL/LTR checks, and DevTools rebuild verification pass.

## Rollback Strategy

Each task is independently committed. Revert only the failing task commit; never use a hard reset or broad checkout because the working tree contains unrelated user changes. Keep characterization, race, and error-code tests even if a later structural optimization is rejected.
