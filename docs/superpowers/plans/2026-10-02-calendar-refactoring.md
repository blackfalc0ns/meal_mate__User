# Calendar Feature Refactoring Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor and modularize `lib/features/calendar` to eliminate bloated files, dead code, monolithic mappers, and disorganized widget structure while maintaining 100% feature parity and zero analysis errors.

**Architecture:** 
- Clean up `CalendarContent` by removing dead static rendering modes.
- Deconstruct `calendar_mapper.dart` (796 lines) into focused, domain-specific mappers (`day`, `restaurant`, `meal`, `request`).
- Reorganize `presentation/widgets/` (37 flat files) into cohesive subdirectories (`panel/`, `restaurant/`, `meal/`, `sheets/`, `states/`).
- Extract heavy pagination meal merging logic (`_mergeMoreMeals`) from `CalendarViewModel` into a dedicated helper (`CalendarMealsMerger`).

**Tech Stack:** Flutter, BLoC / Cubit, DTO Mappers, Clean Architecture.

---

### Task 1: Clean up `CalendarContent` dead code & duplicate rendering paths
**Files:**
- Modify: `lib/features/calendar/presentation/widgets/calendar_content.dart`
- Verify: `flutter analyze lib/features/calendar/presentation/widgets/calendar_content.dart`

- [ ] Remove `widget.state` parameter, `_buildStaticDataView`, and unused static callbacks.
- [ ] Simplify `_CalendarContentState` to strictly drive the reactive view via `BlocSelector` / `BlocListener`.
- [ ] Verify analysis passes.

### Task 2: Modularize `calendar_mapper.dart`
**Files:**
- Create: `lib/features/calendar/data/mapper/calendar_day_mapper.dart`
- Create: `lib/features/calendar/data/mapper/calendar_restaurant_mapper.dart`
- Create: `lib/features/calendar/data/mapper/calendar_meal_mapper.dart`
- Create: `lib/features/calendar/data/mapper/calendar_request_mapper.dart`
- Modify: `lib/features/calendar/data/mapper/calendar_mapper.dart` (barrel export or unified facade)
- Verify: `flutter analyze lib/features/calendar/data/`

- [ ] Extract Day mapping logic to `calendar_day_mapper.dart`.
- [ ] Extract Restaurant & Option mapping logic to `calendar_restaurant_mapper.dart`.
- [ ] Extract Meal & Slot & Nutrition mapping logic to `calendar_meal_mapper.dart`.
- [ ] Extract Request DTO construction to `calendar_request_mapper.dart`.
- [ ] Ensure `calendar_mapper.dart` exports all or delegates cleanly with zero breaking changes.
- [ ] Verify analysis passes.

### Task 3: Structure `presentation/widgets/` into subdirectories
**Files:**
- Create directories:
  - `lib/features/calendar/presentation/widgets/panel/`
  - `lib/features/calendar/presentation/widgets/restaurant/`
  - `lib/features/calendar/presentation/widgets/meal/`
  - `lib/features/calendar/presentation/widgets/sheets/`
  - `lib/features/calendar/presentation/widgets/states/`
- Move files and update `part / part of` or direct imports.
- Verify: `flutter analyze lib/features/calendar/presentation/`

- [ ] Move panel files to `panel/`.
- [ ] Move restaurant card & picker files to `restaurant/`.
- [ ] Move meal card & chip files to `meal/`.
- [ ] Move confirmation & selection sheets to `sheets/`.
- [ ] Move empty & frozen day states to `states/`.
- [ ] Fix all imports in screens and widgets.
- [ ] Verify analysis passes.

### Task 4: Extract Pagination & Slot Helper from `CalendarViewModel`
**Files:**
- Create: `lib/features/calendar/presentation/helpers/calendar_meals_merger.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model.dart`
- Verify: `flutter analyze lib/features/calendar/presentation/manager/`

- [ ] Move `_mergeMoreMeals` algorithm into `CalendarMealsMerger.merge(...)`.
- [ ] Delegate from `CalendarViewModel` to `CalendarMealsMerger`.
- [ ] Verify analysis passes.

### Task 5: Full Feature Verification
- [ ] Run `flutter analyze lib/features/calendar` to ensure zero warnings or errors.
- [ ] Run existing tests if available (`flutter test`).
