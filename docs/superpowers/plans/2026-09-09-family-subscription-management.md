# Family Subscription Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace fake family-management data with backend-backed state while reusing the existing subscription calendar stack.

**Architecture:** Add the missing clean-architecture layers for family home/member/access/permissions in `subscription_settings`. Pass `memberSubscriptionId` into the existing calendar feature and keep business errors centralized.

**Tech Stack:** Flutter, Dart, flutter_bloc, Dio, Retrofit, json_serializable, Injectable/GetIt, flutter_test.

**Spec:** `docs/superpowers/specs/2026-09-09-family-subscription-management-design.md`

## Global Constraints

- Preserve the existing UI, routes, theme, localization, and architecture.
- Response DTO fields are nullable; domain entities and UI never consume DTOs.
- Reuse the existing `ApiServices`, Dio, calendar repository, use cases, and view model.
- Do not implement or guess the missing review/complete contract.
- Backend business codes are mapped centrally, never in UI widgets.

---

### Task 1: Central family error messages

**Files:**
- Modify: `lib/core/network/failuer_mapper.dart`
- Modify: `lib/core/l10n/app_ar.arb`
- Modify: `lib/core/l10n/app_en.arb`
- Test: `test/core/errors/family_error_message_test.dart`

**Interfaces:**
- Consumes: backend error-code strings stored by `ApiException`/`Failure`.
- Produces: localized strings through `mapFailureMessage` and `ErrorMessagePresenter`.

- [ ] Write a widget test that passes each documented family code through `mapFailureMessage` and expects a non-technical localized message.
- [ ] Run `flutter test test/core/errors/family_error_message_test.dart` and verify it fails because the codes are unmapped.
- [ ] Add ARB keys and switch cases for all documented codes.
- [ ] Generate localization output and rerun the test.

### Task 2: Stop meal selection from completing the day

**Files:**
- Modify: `lib/features/calendar/presentation/manager/calendar_view_model.dart`
- Test: `test/calendar_view_model_toggle_test.dart`

**Interfaces:**
- Consumes: `SaveCalendarDayMealsEvent`.
- Produces: one save operation and updated day state, without invoking auto-select/complete.

- [ ] Add a failing behavior test proving save success never invokes the auto-select use case.
- [ ] Run the focused test and verify the auto-select call makes it fail.
- [ ] Remove the automatic auto-select call from `_saveMeals`, retaining the explicit auto-select event.
- [ ] Rerun the focused calendar tests.

### Task 3: Family management API contracts and DTO mapping

**Files:**
- Modify: `lib/core/network/network_constants.dart`
- Modify: `lib/core/network/api_services.dart`
- Create: response/request DTO and mapper files under `lib/features/subscription_settings/data/`
- Create: `test/family_management_contract_test.dart`

**Interfaces:**
- Produces: nullable DTOs and domain-safe entities for home, members, details, access, and permissions.

- [ ] Write failing JSON contract tests using the nine-file fixtures.
- [ ] Add endpoint constants and Retrofit methods.
- [ ] Add nullable response DTOs, required request DTO fields, and mappers without force unwraps.
- [ ] Generate JSON/Retrofit code and rerun contract tests.

### Task 4: Repository and use cases

**Files:**
- Create: family management remote data source contract/implementation.
- Create: family management repository contract/implementation.
- Create: focused use cases for home, members, details, access, permissions, and renewal.
- Test: `test/family_management_repository_test.dart`

**Interfaces:**
- Produces: `Future<ApiResult<DomainEntity>>` operations used by presentation.

- [ ] Write failing repository tests for mapping and failures.
- [ ] Implement remote forwarding and `safeApiCall` repository methods.
- [ ] Add thin injectable use cases and rerun tests.

### Task 5: Home, member list, and details state

**Files:**
- Create: family management view-model/event/state files.
- Modify: the existing settings, members, and member-detail screens/widgets only where data wiring requires it.
- Modify: route argument types in `lib/config/routing/routing_generator.dart`.
- Test: family view-model and navigation tests.

**Interfaces:**
- Produces: backend entities, local name filtering, selected `memberId`, and selected `memberSubscriptionId`.

- [ ] Write failing tests for loading, local search, no-plan members, and route IDs.
- [ ] Implement state/events and bind screens through injected view models.
- [ ] Preserve existing visual widgets and rerun widget tests.

### Task 6: Access and permissions state

**Files:**
- Create/modify presentation manager state for access and permissions.
- Modify: existing access and permissions screens/widgets.
- Test: access/permissions view-model and widget tests.

**Interfaces:**
- Produces: patch-style access requests, one-time generated-password side effect, and complete eight-boolean permission writes.

- [ ] Write failing tests for changed-only access payloads, manager removal, generated-password clearing, group rendering, and root permission payloads.
- [ ] Implement view-model operations and screen bindings.
- [ ] Rerun focused tests.

### Task 7: Reuse calendar flow for family members

**Files:**
- Modify: family calendar/day/restaurants/meals route arguments and screens.
- Reuse: `lib/features/calendar/**` domain/data operations.
- Test: family calendar route and backend-state tests.

**Interfaces:**
- Consumes: `memberId`, `memberSubscriptionId`, display name, selected date, and restaurant ID.
- Produces: backend-backed family calendar flow without duplicate networking.

- [ ] Write failing tests proving `memberSubscriptionId` is passed as `subscriptionId` and null blocks navigation.
- [ ] Replace family fake calendar sources with the existing calendar view model/entities.
- [ ] Wire day, restaurant search/selection, paginated slot meals, block reasons, and slot limits.
- [ ] Preserve review navigation but do not add completion behavior.

### Task 8: Generation and verification

**Files:**
- Modify generated Retrofit, JSON, localization, and Injectable files through generators only.

- [ ] Run `dart run build_runner build --delete-conflicting-outputs`.
- [ ] Run `dart format` on changed Dart files.
- [ ] Run focused family and calendar tests.
- [ ] Run `flutter analyze` and resolve introduced diagnostics.
- [ ] Review `git diff` to confirm unrelated files were not modified.
