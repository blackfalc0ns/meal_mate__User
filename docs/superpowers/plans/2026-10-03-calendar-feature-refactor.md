# Calendar Feature Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the complete calendar feature to remove duplicate presentation code, make asynchronous state updates race-safe, reduce avoidable rebuild and transformation work, and preserve all current UI and behavior.

**Architecture:** Keep the existing clean-layered feature (`data` / `domain` / `presentation`) and the existing `Cubit<CalendarState>` approach. Consolidate the runtime presentation implementation under the project-standard `presentation/screens` and `presentation/widgets` paths, add small private request guards and indexed lookup helpers, and narrow reactive rebuild boundaries without introducing a new state-management system.

**Tech Stack:** Flutter, Dart 3.12, flutter_bloc 8.1.6, Dio/Retrofit, get_it/injectable, flutter_test.

**Spec:** User-approved calendar audit from 2026-10-03, `AGENTS.md`, and `rules/ui_rules.md`. `rules/backend_rules.md` is referenced by `AGENTS.md` but is currently missing; Tasks 5 and 6 must not change backend/data contracts until that file is restored or the repository owner explicitly confirms execution without it.

## Global Constraints

- Preserve the current visual design, localized copy, navigation behavior, API routes, and public feature behavior.
- Do not add packages or introduce a new architecture/state-management approach.
- Do not modify unrelated files.
- Before editing, inspect and preserve all uncommitted user changes. At audit time these included `calendar_daily_macros_card.dart`, `calendar_day_content.dart`, and `calendar_header.dart`.
- Never overwrite or revert user changes. Reconcile them manually if a task touches the same file.
- Follow `rules/ui_rules.md`: theme colors only, localization for user-facing text, existing text styles, existing spacing tokens, directional layout APIs, one custom widget class per file, and selective rebuilds.
- Do not change Figma-derived dimensions, typography, copy, or colors during this refactor.
- Keep externally consumed shared widgets source-compatible, especially `CalendarPickerPanel`, which is imported by `family_member_calendar_screen.dart`.
- Treat performance claims as unverified until measured with Flutter DevTools rebuild tracking/profile mode.
- Use TDD for behavior changes: failing regression test, minimal implementation, passing focused test, then broader verification.
- Run `dart format` only on files changed by the current task.
- Each task must be reviewed and committed independently. Do not stage unrelated existing changes.

## Current Runtime Map

- Application route and app shell import `lib/features/calendar/presentation/screens/calendar_screen.dart`.
- That screen imports `presentation/widgets/*` and `presentation/screens/calendar_meal_selection_screen.dart`.
- A second presentation tree exists under `calendar_home/`, `meal_selection/`, `restaurant_picker/`, and `shared_calendar_widgets/`; some files are identical and others have drifted.
- Calendar state is owned by `CalendarViewModel`, split into four mixins using Dart `part` files.
- Restaurant search has a 300 ms UI debounce, but the Cubit does not reject stale out-of-order responses.
- Day-detail loading already rejects a response when the selected date has changed; restaurant and available-meal requests need equivalent protection.
- `CalendarMenuMapper.toMenuData` remaps all meals and ingredients whenever selected meal IDs change.
- `CalendarDaysBuilder.monthDays` linearly scans service days for every generated calendar cell.
- The existing feature analyzer is clean before refactoring.

## Target File Ownership

Keep these canonical locations:

- `presentation/screens/calendar_screen.dart`: route lifecycle and UI side effects only.
- `presentation/screens/calendar_meal_selection_screen.dart`: meal-selection screen composition only.
- `presentation/widgets/`: calendar-owned reusable widgets, one widget per file unless an existing `part` conversion is handled in Task 3.
- `presentation/helpers/calendar_days_builder.dart`: pure day-grid transformations.
- `presentation/helpers/calendar_meals_merger.dart`: pure paginated-meal merge logic.
- `presentation/mapper/calendar_menu_mapper.dart`: pure calendar entity to restaurant-menu UI model mapping.
- `presentation/manager/calendar_view_model*.dart`: intent handling and asynchronous state transitions.
- `data`, `domain`: retain current boundaries and APIs unless Task 6 confirms a backend contract change.

Remove these duplicate locations only after all runtime imports and tests have moved to canonical files:

- `presentation/calendar_home/`
- `presentation/meal_selection/`
- `presentation/restaurant_picker/`
- Duplicate files under `presentation/shared_calendar_widgets/`; retain a canonical widget in `presentation/widgets/` where external consumers already import it.

---

### Task 1: Establish a Clean Baseline and Protect Existing Work

**Files:**
- Read: `AGENTS.md`
- Read: `rules/ui_rules.md`
- Read if restored: `rules/backend_rules.md`
- Read: `lib/features/calendar/**`
- Read: `test/calendar_*_test.dart`
- Create: none
- Modify: none

**Interfaces:**
- Consumes: current working tree and existing tests.
- Produces: recorded baseline status and an exact list of user-modified calendar files that later tasks must preserve.

- [ ] **Step 1: Record repository state**

Run:

```powershell
git status --short
git diff -- lib/features/calendar
```

Expected: record every existing modification. Do not clean, reset, stash, or checkout any file.

- [ ] **Step 2: Verify required rules**

Run:

```powershell
Get-Content -Raw AGENTS.md
Get-Content -Raw rules/ui_rules.md
Test-Path rules/backend_rules.md
```

Expected: UI rules are readable. If backend rules are missing, record that Tasks 5 and 6 are gated; do not invent their contents.

- [ ] **Step 3: Run the feature analyzer baseline**

Run:

```powershell
flutter analyze lib/features/calendar
```

Expected: `No issues found!`.

- [ ] **Step 4: Run the calendar-focused test baseline**

Run each existing calendar test explicitly so a failure names its owner:

```powershell
Get-ChildItem test/calendar_*_test.dart | ForEach-Object { flutter test $_.FullName }
```

Expected: all existing calendar tests pass. If a pre-existing failure occurs, stop and report it before refactoring.

- [ ] **Step 5: Do not commit**

This task is read-only. Confirm `git status --short` has no new entries.

---

### Task 2: Lock the Canonical Presentation Tree With Import-Graph Tests

**Files:**
- Create: `test/calendar_presentation_structure_test.dart`
- Read: `lib/config/routing/routing_generator.dart`
- Read: `lib/features/app_shell/presentation/screens/app_shell_screen.dart`
- Read: `lib/features/subscription_settings/presentation/screens/family_member_calendar_screen.dart`

**Interfaces:**
- Consumes: canonical path decision in this plan.
- Produces: regression tests that reject imports from duplicate calendar presentation directories.

- [ ] **Step 1: Write the structure test**

Create a filesystem-based test that scans Dart sources under `lib/` and asserts:

```dart
const forbiddenFragments = <String>[
  'features/calendar/presentation/calendar_home/',
  'features/calendar/presentation/meal_selection/',
  'features/calendar/presentation/restaurant_picker/',
  'features/calendar/presentation/shared_calendar_widgets/',
];
```

For every `.dart` file, read its contents and fail with the source path and forbidden fragment when an import contains one of these fragments. Also assert that `routing_generator.dart` imports:

```dart
features/calendar/presentation/screens/calendar_screen.dart
```

Do not assert that the duplicate directories are absent yet; that belongs to the final step of Task 3.

- [ ] **Step 2: Run the test and verify it fails**

Run:

```powershell
flutter test test/calendar_presentation_structure_test.dart
```

Expected: FAIL while the duplicate tree imports itself.

- [ ] **Step 3: Narrow the first test to external runtime imports**

During migration, exclude files located inside the four duplicate directories from the import scan. Keep checking all sources outside those directories. This should prove no live external consumer selects the duplicate implementation.

- [ ] **Step 4: Run the narrowed test**

Run:

```powershell
flutter test test/calendar_presentation_structure_test.dart
```

Expected: PASS. If it fails, list every external consumer and migrate it explicitly in Task 3.

- [ ] **Step 5: Commit the safety net**

```powershell
git add test/calendar_presentation_structure_test.dart
git commit -m "test(calendar): lock canonical presentation imports"
```

---

### Task 3: Consolidate Duplicate Presentation Files

**Files:**
- Modify as needed: `lib/features/calendar/presentation/screens/calendar_screen.dart`
- Modify as needed: `lib/features/calendar/presentation/screens/calendar_meal_selection_screen.dart`
- Modify as needed: `lib/features/calendar/presentation/widgets/*.dart`
- Modify if import path changes are required: `lib/features/subscription_settings/presentation/screens/family_member_calendar_screen.dart`
- Delete after reconciliation: `lib/features/calendar/presentation/calendar_home/**`
- Delete after reconciliation: `lib/features/calendar/presentation/meal_selection/**`
- Delete after reconciliation: `lib/features/calendar/presentation/restaurant_picker/**`
- Delete duplicate copies only: `lib/features/calendar/presentation/shared_calendar_widgets/**`
- Modify: `test/calendar_presentation_structure_test.dart`
- Test: all existing `test/calendar_*_test.dart`

**Interfaces:**
- Consumes: canonical imports guaranteed by Task 2.
- Produces: one runtime implementation of every calendar screen/widget and unchanged public widget class names.

- [ ] **Step 1: Produce a file-by-file reconciliation table before deleting**

For every duplicate filename, compare canonical and duplicate versions:

```powershell
git diff --no-index -- lib/features/calendar/presentation/widgets/calendar_content.dart lib/features/calendar/presentation/calendar_home/widgets/calendar_content.dart
```

Repeat for screens, shared widgets, restaurant picker, and meal selection. Record for each pair: identical, canonical newer, duplicate newer, or divergent. Preserve intentional improvements and all current uncommitted user edits in the canonical file.

- [ ] **Step 2: Update imports to canonical paths**

Replace imports under the four duplicate directories with `presentation/screens/` or `presentation/widgets/` imports. Keep these public types unchanged:

```dart
CalendarScreen
CalendarMealSelectionScreen
CalendarPickerPanel
CalendarRestaurantSelectionSheet
```

Do not rename classes merely for aesthetics.

- [ ] **Step 3: Run analyzer before deletion**

```powershell
flutter analyze lib/features/calendar lib/features/subscription_settings/presentation/screens/family_member_calendar_screen.dart
```

Expected: no unresolved imports or duplicate declarations.

- [ ] **Step 4: Delete only proven duplicate directories**

Delete the four duplicate directory trees after confirming `rg` finds no imports:

```powershell
rg -n "presentation/(calendar_home|meal_selection|restaurant_picker|shared_calendar_widgets)/" lib test --glob "*.dart"
```

Expected before deletion: zero matches. Delete explicit directories only; never delete the feature root or canonical `screens`/`widgets` directories.

- [ ] **Step 5: Strengthen the structure test**

Remove the temporary exclusion added in Task 2. Assert both:

```dart
expect(Directory(duplicatePath).existsSync(), isFalse);
```

and no forbidden import fragments in any Dart source.

- [ ] **Step 6: Format and verify**

```powershell
dart format lib/features/calendar/presentation test/calendar_presentation_structure_test.dart
flutter analyze lib/features/calendar
flutter test test/calendar_presentation_structure_test.dart
Get-ChildItem test/calendar_*_test.dart | ForEach-Object { flutter test $_.FullName }
```

Expected: all pass and the UI behavior remains unchanged.

- [ ] **Step 7: Commit the consolidation**

Stage only reconciled calendar presentation files, the structure test, and any required family-calendar import update:

```powershell
git commit -m "refactor(calendar): consolidate presentation structure"
```

---

### Task 4: Make Calendar Requests Reject Stale Responses

**Files:**
- Create: `test/calendar_request_race_test.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model_days.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model_restaurants.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model_meals.dart`
- Modify if guards require explicit state: `lib/features/calendar/presentation/manager/calendar_state.dart`

**Interfaces:**
- Consumes: existing use cases and `doIntent(CalendarEvent)` API.
- Produces: latest-request-wins semantics for calendar load, selected-day details, restaurant search, available meals, and per-slot pagination.

- [ ] **Step 1: Write controllable async fakes**

In `calendar_request_race_test.dart`, create repository methods backed by `Completer<ApiResult<T>>`. Expose the completers in call order so tests can finish the second request before the first.

- [ ] **Step 2: Write failing restaurant-search race test**

Dispatch searches for `a` and then `av`. Complete `av` first with restaurant `new`, then complete `a` with restaurant `old`. Assert:

```dart
expect(viewModel.state.restaurants.map((item) => item.id), ['new']);
expect(viewModel.state.isRestaurantsLoading, isFalse);
```

- [ ] **Step 3: Write failing available-meals race test**

Select restaurant A, then restaurant B. Complete B first, then A. Assert that `availableMeals.restaurant?.id` remains B and selected IDs belong to B's response.

- [ ] **Step 4: Write failing day-switch race test**

Select day 1, then day 2; complete day 2 then day 1. Assert selected date and selected-day details remain day 2. This preserves and verifies the existing date guard.

- [ ] **Step 5: Write failing pagination-context test**

Start load-more for a slot, switch day or restaurant, then complete the old page request. Assert it does not merge into the new `availableMeals` and does not clear the new context's loading/error state.

- [ ] **Step 6: Verify failures**

```powershell
flutter test test/calendar_request_race_test.dart
```

Expected: restaurant, available-meal, and pagination race cases fail before implementation.

- [ ] **Step 7: Add private generation counters**

Add private integer generations owned by `CalendarViewModel`, for example:

```dart
int _calendarRequestGeneration = 0;
int _dayRequestGeneration = 0;
int _restaurantRequestGeneration = 0;
int _availableMealsRequestGeneration = 0;
int _loadMoreRequestGeneration = 0;
```

At request start, increment and capture the relevant generation. After `await`, return without emitting unless the captured generation is still current and the request context still matches subscription/date/restaurant/query/slot as applicable.

- [ ] **Step 8: Invalidate dependent requests on context change**

When subscription, selected day, or selected restaurant changes, increment the generations of requests that depend on that context. Do not rely only on `isClosed`.

- [ ] **Step 9: Keep loading flags owned by the current request**

An ignored stale response must not set a loading flag to false or write a failure into the current request's state. Only the current generation can finalize its operation.

- [ ] **Step 10: Run focused and existing tests**

```powershell
dart format lib/features/calendar/presentation/manager test/calendar_request_race_test.dart
flutter test test/calendar_request_race_test.dart
flutter test test/calendar_restaurants_backend_state_test.dart
flutter test test/calendar_view_model_toggle_test.dart
flutter test test/calendar_confirm_meals_test.dart
flutter analyze lib/features/calendar
```

Expected: all pass.

- [ ] **Step 11: Commit**

```powershell
git add lib/features/calendar/presentation/manager test/calendar_request_race_test.dart
git commit -m "fix(calendar): ignore stale asynchronous responses"
```

---

### Task 5: Guard Mutations Against Duplicate Submission

**Gate:** Read `rules/backend_rules.md` first. If it is still missing, stop this task and ask the repository owner whether to restore it or explicitly proceed using the existing architecture.

**Files:**
- Create: `test/calendar_mutation_guard_test.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model_actions.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model_restaurants.dart`
- Modify if a dedicated flag is necessary: `lib/features/calendar/presentation/manager/calendar_state.dart`

**Interfaces:**
- Consumes: existing save, auto-select, confirm, and set-restaurant events.
- Produces: at-most-one in-flight mutation for each conflicting action group.

- [ ] **Step 1: Write duplicate-save regression test**

Use a `Completer` in the fake repository. Dispatch `SaveCalendarDayMealsEvent` twice before completing it. Assert `saveCalls == 1`.

- [ ] **Step 2: Write duplicate-auto-select regression test**

Dispatch auto-select twice while the first call is pending. Assert `autoSelectCalls == 1`.

- [ ] **Step 3: Write conflicting-action regression test**

Start save, then dispatch confirm before save completes. Assert confirm is not sent until the save workflow is complete. Keep the existing combined save-then-confirm behavior inside `_confirmMeals` unchanged.

- [ ] **Step 4: Run and verify failures**

```powershell
flutter test test/calendar_mutation_guard_test.dart
```

- [ ] **Step 5: Add minimal guards**

At the start of `_saveMeals` and `_autoSelect`, reject execution when `state.isSaving || state.isConfirming`. `_confirmMeals` already performs this guard; retain it. For restaurant mutation, reject a duplicate selection while the same restaurant request is current, without blocking a newer explicit restaurant choice.

- [ ] **Step 6: Ensure every active path clears its flag**

Success and failure paths must clear the flag. A stale completion must not clear a newer operation's flag. Do not add `try/finally` around `ApiResult` handling unless thrown exceptions can escape `safeApiCall` in the current architecture.

- [ ] **Step 7: Verify**

```powershell
dart format lib/features/calendar/presentation/manager test/calendar_mutation_guard_test.dart
flutter test test/calendar_mutation_guard_test.dart
flutter test test/calendar_confirm_meals_test.dart
flutter test test/calendar_view_model_toggle_test.dart
flutter analyze lib/features/calendar
```

- [ ] **Step 8: Commit**

```powershell
git commit -m "fix(calendar): prevent duplicate mutations"
```

---

### Task 6: Verify the Save-Meals Backend Contract Before Optimizing Network Work

**Gate:** This task is investigation-first and requires `rules/backend_rules.md` plus the actual Retrofit declaration in `core/network/api_services.dart`. Do not infer that a batch endpoint exists.

**Files:**
- Read: `lib/core/network/api_services.dart`
- Read: `lib/features/calendar/data/models/request/calendar_save_meals_request_dto.dart`
- Read: `lib/features/calendar/data/data_source/calendar_remote_data_source*.dart`
- Read: `lib/features/calendar/data/repo/calendar_repository_impl.dart`
- Modify only if contract is verified: the same calendar data/repository files
- Test: create or extend `test/calendar_save_meals_request_test.dart`

**Interfaces:**
- Consumes: verified backend API contract.
- Produces: documented and tested request count and response semantics for saving N meals.

- [ ] **Step 1: Inspect the exact endpoint signature**

Determine whether `saveSubscriptionCalendarDayMeals` accepts one meal selection per request or a list. Record the request DTO JSON shape and endpoint method/path in the test name and assertions.

- [ ] **Step 2: Choose exactly one verified branch**

Branch A — batch endpoint exists: update the DTO/data source/repository to send all selected meals in one request.

Branch B — endpoint is single-meal only: retain multiple requests. Do not serialize them merely for style; preserve current concurrency unless backend rules impose a limit.

- [ ] **Step 3: Add request-contract test**

Use a recording Dio adapter like `calendar_restaurants_request_test.dart`. For N selected meals assert the exact supported behavior:

```dart
expect(adapter.requestedUris, hasLength(expectedRequestCount));
expect(decodedRequestBodies, expectedBodies);
```

Also assert the returned `CalendarDayEntity` represents the final server state. Do not assume `responses.last` is authoritative unless the API contract guarantees every response contains the complete day.

- [ ] **Step 4: Implement only the verified contract**

If the single-meal endpoint returns only partial state, perform one final `getDay` after all successful saves instead of trusting an arbitrary response. If it returns the full updated day and the contract guarantees it, keep the least expensive correct flow.

- [ ] **Step 5: Test partial failure semantics**

For the multi-request branch, make one request fail and assert the repository returns an error and does not claim a fully saved state. Do not add rollback unless the backend exposes a supported rollback operation.

- [ ] **Step 6: Verify generated-code requirements**

If and only if Retrofit or JSON annotations changed:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Inspect generated diffs and stage only files caused by the verified contract change.

- [ ] **Step 7: Verify and commit**

```powershell
dart format lib/features/calendar test/calendar_save_meals_request_test.dart
flutter test test/calendar_save_meals_request_test.dart
flutter test test/calendar_confirm_meals_test.dart
flutter analyze lib/features/calendar
git commit -m "refactor(calendar): enforce save meals request contract"
```

If no code change is justified, commit only the contract test with message `test(calendar): document save meals request contract`.

---

### Task 7: Replace Repeated Linear Calendar-Day Lookups With an Index

**Files:**
- Modify: `lib/features/calendar/presentation/helpers/calendar_days_builder.dart`
- Modify: `test/calendar_presentation_refactor_test.dart`
- Create if focused separation is clearer: `test/calendar_days_builder_test.dart`

**Interfaces:**
- Consumes: `List<CalendarDayEntity>`, focused month, selected date.
- Produces: identical ordered day grids using O(serviceDays + gridCells) work instead of scanning service days for every cell.

- [ ] **Step 1: Add preservation tests**

Cover a leap month, a six-row month, dates outside the focused month, duplicate-free dates, selected day, muted non-service dates, and a service-day object whose meals/status must be preserved.

- [ ] **Step 2: Run tests before implementation**

```powershell
flutter test test/calendar_presentation_refactor_test.dart
```

Expected: current behavior passes; these are characterization tests.

- [ ] **Step 3: Add a normalized date key**

Inside `CalendarDaysBuilder`, add a private key function without formatting strings:

```dart
static int _dateKey(DateTime date) =>
    date.year * 10000 + date.month * 100 + date.day;
```

- [ ] **Step 4: Index service days once**

At the start of `monthDays`, construct:

```dart
final serviceDayByDate = <int, CalendarDayEntity>{
  for (final day in serviceDays)
    if (day.date case final date?) _dateKey(date): day,
};
```

Replace `.where(...).firstOrNull` inside `List.generate` with a map lookup.

- [ ] **Step 5: Verify exact behavior**

```powershell
dart format lib/features/calendar/presentation/helpers/calendar_days_builder.dart test/calendar_presentation_refactor_test.dart
flutter test test/calendar_presentation_refactor_test.dart
flutter analyze lib/features/calendar
```

- [ ] **Step 6: Commit**

```powershell
git commit -m "perf(calendar): index service days for month grids"
```

---

### Task 8: Index Meal Selection Lookups and Preserve Slot Rules

**Files:**
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model_meals.dart`
- Modify: `lib/features/calendar/presentation/helpers/calendar_meals_merger.dart`
- Modify: `test/calendar_view_model_toggle_test.dart`
- Create: `test/calendar_meals_merger_test.dart`

**Interfaces:**
- Consumes: available meals, slot requirements, selected meal IDs, paginated incoming meals.
- Produces: identical selection/replacement and deduplication behavior using sets/maps for membership and lookup.

- [ ] **Step 1: Expand toggle behavior tests**

Add cases for deselection, blocked meal, unknown meal, zero/missing slot limit, selecting below limit, replacing the earliest selected meal in the same slot at limit, and not replacing a meal from another slot.

- [ ] **Step 2: Add merger tests**

Test duplicate meal IDs, incoming slot-only payload, incoming flat-meals payload, new slot, page metadata update, and stable existing-meal order.

- [ ] **Step 3: Run tests**

```powershell
flutter test test/calendar_view_model_toggle_test.dart
flutter test test/calendar_meals_merger_test.dart
```

- [ ] **Step 4: Normalize slot values once per operation**

Use a private helper:

```dart
String _normalizedSlot(String value) => value.trim().toLowerCase();
```

Within `_toggleMeal`, create `Set<String>.from(state.localSelectedMealIds)`, a meal-by-ID map, and a requirement-by-slot map once. Preserve selected-list order when emitting; use the set only for membership checks.

- [ ] **Step 5: Optimize merging without changing order**

Build incoming slots keyed by normalized slot and existing IDs as sets once per slot. Keep current slots first, append genuinely new incoming slots afterward, and preserve meal order within each slot.

- [ ] **Step 6: Verify**

```powershell
dart format lib/features/calendar/presentation/manager/calendar_view_model_meals.dart lib/features/calendar/presentation/helpers/calendar_meals_merger.dart test/calendar_view_model_toggle_test.dart test/calendar_meals_merger_test.dart
flutter test test/calendar_view_model_toggle_test.dart
flutter test test/calendar_meals_merger_test.dart
flutter analyze lib/features/calendar
```

- [ ] **Step 7: Commit**

```powershell
git commit -m "perf(calendar): index meal and slot lookups"
```

---

### Task 9: Narrow Calendar Home Rebuild Boundaries

**Files:**
- Modify: `lib/features/calendar/presentation/widgets/calendar_content.dart`
- Modify as required: `lib/features/calendar/presentation/widgets/calendar_picker_panel.dart`
- Modify as required: `lib/features/calendar/presentation/widgets/calendar_day_content.dart`
- Create: `test/calendar_rebuild_scope_test.dart`

**Interfaces:**
- Consumes: current `CalendarState` and existing callbacks.
- Produces: separate reactive boundaries for picker data and selected-day content without changing public behavior.

- [ ] **Step 1: Write rebuild counters in a widget test**

Use small test-only widgets or callback counters around the picker subtree and day-content subtree. Pump a `CalendarViewModel`, emit changes, and assert:

- restaurant-search loading does not rebuild calendar content;
- save/confirm state rebuilds only the action/day-content region;
- selected date/days rebuild the picker;
- selected-day loading/data rebuilds day content.

- [ ] **Step 2: Run and capture current counts**

```powershell
flutter test test/calendar_rebuild_scope_test.dart
```

Expected: at least one over-broad rebuild assertion fails or the test documents that existing selectors are already sufficient. Do not refactor without a failing or measured case.

- [ ] **Step 3: Extract only meaningful rebuild boundaries**

Create separate custom widgets only when each owns a distinct selector:

```dart
CalendarPickerSection
CalendarSelectedDaySection
```

Each must live in its own file under `presentation/widgets/` per UI rules. The parent `CalendarContent` keeps local expanded/focused-month state only if both sections genuinely require it; otherwise move state to the smallest owner.

- [ ] **Step 4: Select exact values**

The picker selector may observe only `selectedDate` and `days`. The day-content selector may observe only `selectedDay`, `isSelectedDayLoading`, `isConfirming`, and `canConfirmSelectedDayMeals`. Do not select the complete `CalendarState`.

- [ ] **Step 5: Keep static states outside unrelated listeners**

Loading, no-subscription, error, and empty states must not subscribe to restaurant or meal-picker state.

- [ ] **Step 6: Verify tests and analyzer**

```powershell
dart format lib/features/calendar/presentation/widgets test/calendar_rebuild_scope_test.dart
flutter test test/calendar_rebuild_scope_test.dart
flutter test test/calendar_no_subscription_state_test.dart
flutter test test/calendar_empty_meals_action_test.dart
flutter test test/calendar_frozen_day_state_test.dart
flutter analyze lib/features/calendar
```

- [ ] **Step 7: Commit only if measurement improved**

Record before/after build counts in the commit body. If counts do not improve, revert only this task's changes while preserving user work and keep the test as documentation if useful.

```powershell
git commit -m "perf(calendar): narrow home rebuild boundaries"
```

---

### Task 10: Reduce Meal-Menu Mapping Work Without Crossing Feature Scope

**Files:**
- Modify: `lib/features/calendar/presentation/mapper/calendar_menu_mapper.dart`
- Modify: `lib/features/calendar/presentation/screens/calendar_meal_selection_screen.dart`
- Create: `test/calendar_menu_mapper_test.dart`
- Create or extend: `test/calendar_rebuild_scope_test.dart`

**Interfaces:**
- Consumes: `CalendarAvailableMealsEntity`, selection IDs, localization, restaurant metadata.
- Produces: identical `RestaurantMenuData`; static meal/ingredient mapping is reused when only selection changes.

- [ ] **Step 1: Add mapper equivalence tests**

Assert tabs, slot order, origins, ingredient truncation, restaurant metadata, blocked meals, image values, and selected flags for a representative entity.

- [ ] **Step 2: Measure mapper invocation**

Add a test-visible mapping callback or injectable pure mapper function to `CalendarMealSelectionScreen`; default it to `CalendarMenuMapper.toMenuData`. In the widget test, count invocations while toggling selections and while replacing available meals.

- [ ] **Step 3: Split static mapping from selection projection**

Introduce pure methods with explicit signatures:

```dart
static RestaurantMenuData toBaseMenuData({
  required CalendarAvailableMealsEntity? availableMeals,
  required AppLocalizations locale,
  String? restaurantName,
  String? restaurantLogoUrl,
  String? restaurantLogoAsset,
  String? restaurantInitials,
  String? restaurantRating,
});

static RestaurantMenuData applySelection({
  required RestaurantMenuData base,
  required Set<String> selectedMealIds,
});
```

`toBaseMenuData` performs ingredient/origin/slot mapping and produces options with `selected: false`. `applySelection` copies tabs/options while changing only each option's selected flag.

- [ ] **Step 4: Cache only in the screen lifecycle**

Convert `CalendarMealSelectionScreen` to `StatefulWidget` only if required. Cache base menu data keyed by the identities/values that determine it: available meals object, locale name, and resolved restaurant metadata. Recompute the base when any key changes; apply current selection on each relevant state update.

- [ ] **Step 5: Keep scope inside calendar**

Do not modify `features/restaurant_menu` in this plan. The shared restaurant menu may still rebuild because its selected option models change; this task removes repeated expensive entity-to-UI transformation only. A deeper per-card rebuild redesign requires a separate cross-feature plan and measurements.

- [ ] **Step 6: Verify**

```powershell
dart format lib/features/calendar/presentation/mapper/calendar_menu_mapper.dart lib/features/calendar/presentation/screens/calendar_meal_selection_screen.dart test/calendar_menu_mapper_test.dart test/calendar_rebuild_scope_test.dart
flutter test test/calendar_menu_mapper_test.dart
flutter test test/calendar_rebuild_scope_test.dart
flutter test test/calendar_view_model_toggle_test.dart
flutter analyze lib/features/calendar
```

Expected: base mapping runs once for repeated selection-only changes and reruns when available meals/locale/restaurant metadata changes.

- [ ] **Step 7: Commit**

```powershell
git commit -m "perf(calendar): reuse static meal menu projections"
```

---

### Task 11: Clean UI Code Within the Existing Design Contract

**Files:**
- Modify only verified violations under: `lib/features/calendar/presentation/screens/`
- Modify only verified violations under: `lib/features/calendar/presentation/widgets/`
- Modify if required and already in approved scope: `lib/config/theme/styles_manager.dart`
- Modify if required and already in approved scope: `lib/config/theme/spacing.dart`
- Test: existing calendar widget tests

**Interfaces:**
- Consumes: existing theme, localization, styles, spacing, and assets.
- Produces: behaviorally and visually identical UI code compliant with `rules/ui_rules.md`.

- [ ] **Step 1: Audit exact violations**

Search for:

```powershell
rg -n "Colors\.|Color\(|TextStyle\(|EdgeInsets\.(all|only|symmetric|fromLTRB)\([^\n]*[0-9]|SizedBox\([^\n]*(height|width): [0-9]|fontSize: [0-9]|letterSpacing:" lib/features/calendar/presentation
```

Classify each hit as Figma-fixed component geometry, an existing token match, or an unresolved design value. Do not mechanically replace verified fixed icon/control dimensions.

- [ ] **Step 2: Reuse existing tokens only**

Replace a literal only when an exact existing `Spacing` or style token has the same intended value. If no exact token exists, leave it unchanged and report it; do not invent a token without Figma confirmation.

- [ ] **Step 3: Enforce build context conventions**

At each `build`, declare `color` and `locale` only when used. Remove direct theme/localization lookups repeated within that build.

- [ ] **Step 4: Convert eligible part widgets to normal imports**

Where a widget file currently uses `part of`, give it explicit imports and import it normally from its owner. Keep one widget class per file. Do not combine files or create barrel exports.

- [ ] **Step 5: Apply const and remove dead wrappers**

Add `const` only where all arguments are compile-time constants. Remove a wrapper only if it affects neither layout, paint, semantics, lifecycle, nor rebuild boundaries.

- [ ] **Step 6: Verify layout-sensitive tests**

```powershell
dart format lib/features/calendar/presentation
flutter test test/calendar_header_layout_test.dart
flutter test test/calendar_source_card_overflow_test.dart
flutter test test/calendar_no_subscription_state_test.dart
flutter test test/calendar_empty_meals_action_test.dart
flutter analyze lib/features/calendar
```

- [ ] **Step 7: Commit**

```powershell
git commit -m "refactor(calendar): align UI code with project rules"
```

---

### Task 12: Final Functional, Structural, and Performance Verification

**Files:**
- Modify only to fix regressions introduced by Tasks 2–11.
- Create: none unless a discovered regression requires a focused test.

**Interfaces:**
- Consumes: all previous task deliverables.
- Produces: evidence that the refactor is behavior-preserving, analyzable, tested, and measurably avoids targeted work.

- [ ] **Step 1: Confirm no duplicate paths/imports remain**

```powershell
rg -n "presentation/(calendar_home|meal_selection|restaurant_picker|shared_calendar_widgets)/" lib test --glob "*.dart"
```

Expected: zero matches.

- [ ] **Step 2: Confirm no unintended file changes**

```powershell
git status --short
git diff --stat
git diff -- lib/features/calendar
```

Expected: only planned files plus preserved pre-existing user changes. Inspect, do not overwrite, any unrelated modification.

- [ ] **Step 3: Run all calendar tests**

```powershell
Get-ChildItem test/calendar_*_test.dart | ForEach-Object { flutter test $_.FullName }
```

Expected: all pass.

- [ ] **Step 4: Run dependent family-calendar tests**

```powershell
flutter test test/family_calendar_view_model_test.dart
flutter test test/family_calendar_loading_and_action_test.dart
flutter test test/family_member_calendar_screen_test.dart
flutter test test/profile_billing_freeze_policy_and_calendar_test.dart
```

Expected: all pass.

- [ ] **Step 5: Run full analyzer**

```powershell
flutter analyze
```

Expected: no new issues. If unrelated pre-existing issues exist, separately run `flutter analyze lib/features/calendar` and document the distinction.

- [ ] **Step 6: Run the complete test suite**

```powershell
flutter test
```

Expected: all pass. Do not claim completion if a refactor-related failure remains.

- [ ] **Step 7: Profile rebuilds manually**

Run the app in profile mode and use Flutter DevTools “Track widget rebuilds”. Exercise:

1. Open calendar.
2. Expand/collapse the month.
3. Switch days rapidly.
4. Open restaurant search and type rapidly.
5. Select a restaurant.
6. Toggle at least five meals.
7. Load another meal page.
8. Save and confirm.

Record before/after observations for `CalendarContent`, picker section, day section, `CalendarMealSelectionScreen`, and menu mapping. Confirm stale search/day responses never replace the current selection.

- [ ] **Step 8: Validate RTL and LTR**

Render the calendar in at least one configured RTL locale and one configured LTR locale. Confirm directional padding, arrows, sheets, day ordering, and text alignment remain correct without language-code checks or manually reversed collections.

- [ ] **Step 9: Final commit if regression fixes were needed**

```powershell
git commit -m "test(calendar): complete refactor verification"
```

Do not create an empty commit.

## Acceptance Criteria

- Exactly one canonical implementation exists for every calendar screen and widget.
- No source imports any removed duplicate presentation path.
- Existing external consumers such as family calendar continue compiling and passing tests.
- Older restaurant, day, restaurant-meal, and pagination responses cannot overwrite newer context.
- Duplicate save, auto-select, and confirm actions do not produce duplicate API mutations.
- Save-meals request behavior is backed by an explicit API contract test.
- Month-grid and meal-selection transformations preserve behavior and use indexed membership/lookups.
- Calendar home reactive sections listen only to fields they render.
- Static meal-menu mapping is not repeated for selection-only changes.
- UI design, localization, navigation, API routes, and existing behavior remain unchanged.
- `flutter analyze lib/features/calendar`, calendar tests, dependent family-calendar tests, and the complete test suite pass.
- DevTools evidence is recorded; no unsupported claim of “performance optimized” is made.

## Explicit Non-Goals

- No redesign or Figma reinterpretation.
- No new state-management library.
- No repository-wide architecture migration.
- No change to `features/restaurant_menu` in this plan.
- No speculative caching of network responses.
- No new spacing/style token without exact design evidence.
- No backend batching endpoint invented from the client implementation.

## Rollback Strategy

Each task is independently committed. If a task regresses behavior or does not improve its measured target, revert that task's commit only; never reset the working tree or discard pre-existing user changes. Request-race safety tests and structure tests should remain even if a later micro-optimization is rejected.
