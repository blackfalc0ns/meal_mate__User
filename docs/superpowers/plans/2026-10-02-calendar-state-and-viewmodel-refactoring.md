# Calendar State and ViewModel Modularization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Modularize the monolithic `CalendarViewModel` (757 lines) and `CalendarState` (198 lines) into clean, focused part files and domain extensions without breaking any external contracts, DI injections, or test suites.

**Architecture:** Maintain a Single Source of Truth (`CalendarState`) managed by `CalendarViewModel` as the single injectable Cubit facade. Slices logic across 4 domain-focused part files (`days`, `restaurants`, `meals`, `actions`) and extracts state validation and getter computations into clean extension methods.

**Tech Stack:** Flutter, Flutter Bloc (Cubit), Injectable/GetIt, Dart `part/part of`.

---

## Global Constraints
- Preserve existing DI registration (`getIt<CalendarViewModel>()` and `@injectable`).
- Zero changes to public APIs of `CalendarViewModel` and `CalendarEvent`.
- Keep all 12 test suites (60+ tests) in `test/calendar*` passing with 0 failures and 0 warnings.
- Comply with `rules/ui_rules.md` and `rules/backend_rules.md`.

---

## Tasks

### Task 1: Refactor `CalendarState` and Extract Computed Getters & Logic
**Files:**
- Create: `lib/features/calendar/presentation/manager/calendar_state_extensions.dart`
- Modify: `lib/features/calendar/presentation/manager/calendar_state.dart`

**Steps:**
- [ ] Move computed getters and validation logic (`selectedDay`, `canEditSelectedDay`, `selectedDayMeals`, `requiredMealsCount`, `canSaveMeals`, `canConfirmSelectedDayMeals`, `hasCalendarData`, `hasRestaurantPool`, `restaurantsWithUsageLimits`) to `calendar_state_extensions.dart`.
- [ ] Leave `calendar_state.dart` as a clean, immutable data holder with only constructor and `copyWith`.
- [ ] Verify `flutter analyze lib/features/calendar/presentation/manager/calendar_state.dart`.

---

### Task 2: Slice `CalendarViewModel` into 4 Domain Part Files
**Files:**
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model.dart`
- Create: `lib/features/calendar/presentation/manager/calendar_view_model_days.dart`
- Create: `lib/features/calendar/presentation/manager/calendar_view_model_restaurants.dart`
- Create: `lib/features/calendar/presentation/manager/calendar_view_model_meals.dart`
- Create: `lib/features/calendar/presentation/manager/calendar_view_model_actions.dart`

**Steps:**
- [ ] **Part 1 (Days & Subscription):** Move `_loadCalendar`, `_resolveCurrentSubscriptionId`, `_selectDay`, `_loadSelectedDayDetails`, `_loadSelectedDayDetailsForDate`, `_initialSelectedDate`, `_replaceDay` to `calendar_view_model_days.dart`.
- [ ] **Part 2 (Restaurants):** Move `_loadRestaurants`, `_selectRestaurant`, `_withRestaurantFallback`, `_restaurantOptionById` to `calendar_view_model_restaurants.dart`.
- [ ] **Part 3 (Meals & Pagination):** Move `_loadAvailableMeals`, `_loadMoreMeals`, `_toggleMeal` to `calendar_view_model_meals.dart`.
- [ ] **Part 4 (Actions):** Move `_saveMeals`, `_autoSelect`, `_confirmMeals` to `calendar_view_model_actions.dart`.
- [ ] Main `calendar_view_model.dart` retains only constructor, DI dependencies, `doIntent` router, and part declarations (shrinks from 757 lines to ~85 lines).

---

### Task 3: Verification & Test Suite Execution
**Files:**
- Test: `test/calendar_view_model_toggle_test.dart`
- Test: `test/calendar_available_meals_mapper_test.dart`
- Test: `test/calendar_confirm_meals_test.dart`
- Test: `test/calendar_empty_meals_action_test.dart`
- Test: `test/calendar_presentation_refactor_test.dart`
- Test: `test/restaurant_menu_view_test.dart`

**Steps:**
- [ ] Run `flutter analyze lib/features/calendar`.
- [ ] Run full calendar test suite across all 12 test files.
- [ ] Ensure 100% pass rate with zero regression errors.
