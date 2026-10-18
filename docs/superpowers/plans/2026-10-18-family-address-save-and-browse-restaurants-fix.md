# Family Address Save & Browse Restaurants Error Handling Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ensure family member addresses are properly persisted to the backend via `AddFamilyMemberAddressUseCase` when applying the manager's address, prevent premature navigation before backend confirmation, and display proper error handling in the browse restaurants section instead of an empty state when a 409 address required error occurs.

**Architecture:** Inject `AddFamilyMemberAddressUseCase` into `FamilyAddressesViewModel` with backwards-compatible optional resolution. When "Apply manager's address" is triggered, asynchronously call `AddFamilyMemberAddressUseCase` (`POST /api/v1/customer/family-subscription-flow/members/{memberId}/addresses`) for each dependent member, surfacing loading state and failures. Update `FamilyPackageDaysBrowseRestaurantsSection` to display `browseRestaurantsFailure` with actionable retry/guidance instead of falling back to `locale.family_packages_empty`.

**Tech Stack:** Flutter, Dart, Bloc/Cubit, GetIt/Injectable, Dio.

**Spec:** [docs/family_flow_endpoint_audit.md](file:///d:/projects/meal_mate__User/docs/family_flow_endpoint_audit.md#L23) and [rules/backend_rules.md](file:///d:/projects/meal_mate__User/rules/backend_rules.md).

## Global Constraints
- Preserve existing DI patterns in `lib/core/di/di.dart` and `FamilyAddressesViewModel`.
- Keep backwards-compatibility for existing tests by making `AddFamilyMemberAddressUseCase` optional in constructor with fallback to `getIt`.
- Follow `rules/ui_rules.md` and `rules/backend_rules.md`.
- No git commits until the final verification is passing.

## Review Focus
- Applying manager address when manager address is missing or has empty coordinates.
- Partial failure during multiple member address persistence (one succeeds, one fails).
- Network error handling while applying manager address (ensure user stays on addresses screen with visible error).
- Unchecking manager address after having applied it.
- Displaying actionable error message when browsing restaurants encounters `family.address_required`.

---

### Task 1: Add Address Request Mapper & Inject UseCase into `FamilyAddressesViewModel`

**Files:**
- Modify: `lib/core/address/domain/entities/customer_address_entity.dart`
- Modify: `lib/features/family_addresses/presentation/manager/family_addresses_view_model.dart`
- Modify: `lib/features/family_addresses/presentation/manager/family_addresses_state.dart`

**Interfaces:**
- Produces: `CustomerAddressEntity.toRequest({bool isDefault = true}) -> CustomerAddressRequestEntity`
- Consumes: `AddFamilyMemberAddressUseCase` in `FamilyAddressesViewModel`
- Produces: `FamilyAddressesState.isApplyingManagerAddress: bool`

- [ ] **Step 1: Write test for `toRequest()` and `FamilyAddressesViewModel` injection**
Verify `CustomerAddressEntity.toRequest()` produces a valid request matching all address properties.

- [ ] **Step 2: Add `toRequest()` extension/method in `CustomerAddressEntity`**
Map all fields (`label`, `addressLine`, `regionId`, `governorate`, `area`, `block`, `street`, `building`, `unit`, `floor`, `latitude`, `longitude`, `notes`, `notifyOnDelivery`, `isDefault`).

- [ ] **Step 3: Update `FamilyAddressesState` with `isApplyingManagerAddress` flag**
Add `isApplyingManagerAddress` with default `false`, plus `copyWith` support.

- [ ] **Step 4: Update `FamilyAddressesViewModel` constructor**
Accept optional `AddFamilyMemberAddressUseCase? addFamilyMemberAddressUseCase`, defaulting to `getIt.isRegistered<AddFamilyMemberAddressUseCase>() ? getIt<AddFamilyMemberAddressUseCase>() : null`.

---

### Task 2: Implement Async Persistence in `toggleApplyManagerAddress`

**Files:**
- Modify: `lib/features/family_addresses/presentation/manager/family_addresses_view_model.dart`
- Modify: `lib/features/family_addresses/presentation/manager/family_addresses_event.dart`
- Modify: `test/family_addresses_view_model_test.dart`

**Interfaces:**
- `Future<void> toggleApplyManagerAddress()`:
  - If toggling ON:
    - If `state.manager?.deliveryAddress` is null, abort.
    - Emit `isApplyingManagerAddress: true`.
    - For each member `m` where `!m.isManager`:
      - Call `_addFamilyMemberAddress(m.memberId, request)` if `_addFamilyMemberAddress != null`.
      - If result is `ApiSuccessResult`, update member's `deliveryAddress` and `deliveryAddressId` with returned entity.
      - If result is `ApiErrorResult`, stop, emit `isApplyingManagerAddress: false`, `failure`, and do NOT complete step.
    - If all succeed:
      - Update `_snapshotStore.updateMemberDeliveryAddress` for all members.
      - Emit updated members, `completedMemberIds: allMemberIds`, `completed: true`, `isApplyingManagerAddress: false`.
  - If toggling OFF:
    - Clear addresses for non-managers in `_snapshotStore` and local state, emit `completed: false`.

- [ ] **Step 1: Write unit tests for successful and failed `toggleApplyManagerAddress` with mock usecase**
Verify:
1. When usecase succeeds, members are updated with server returned address IDs and `completed: true`.
2. When usecase fails, `failure` is emitted, `completed` remains `false`.
3. When toggling off, non-manager addresses are cleared.

- [ ] **Step 2: Implement `toggleApplyManagerAddress` in `FamilyAddressesViewModel`**
Implement the async logic, error handling, and snapshot store synchronization.

- [ ] **Step 3: Run unit tests**
Run: `flutter test test/family_addresses_view_model_test.dart`
Ensure all tests pass.

---

### Task 3: Update `FamilyAddressApplyManagerBanner` & `FamilyAddressesScreen`

**Files:**
- Modify: `lib/features/family_addresses/presentation/widgets/family_address_apply_manager_banner.dart`
- Modify: `lib/features/family_addresses/presentation/screens/family_addresses_screen.dart`

**Interfaces:**
- `FamilyAddressApplyManagerBanner`:
  - Show small loader in place of checkbox when `isApplyingManagerAddress == true`.
  - Disable onTap while `isApplyingManagerAddress == true`.
- `FamilyAddressesScreen`:
  - Show `CustomSnackbar.showError` when `state.failure != null && state.members.isNotEmpty`.

- [ ] **Step 1: Update `FamilyAddressApplyManagerBanner` UI**
Add `isApplyingManagerAddress` to `_ApplyManagerBannerData` selector. Display subtle `CircularProgressIndicator` inside checkbox when active and disable clicks.

- [ ] **Step 2: Update `FamilyAddressesScreen` listener**
Listen for `state.failure` changes to display errors via `ErrorMessagePresenter.fromFailure(context, state.failure!)`.

---

### Task 4: Fix Browse Restaurants Section Error Handling

**Files:**
- Modify: `lib/features/family_package_days/presentation/widgets/family_package_days_browse_restaurants_section.dart`
- Modify: `lib/l10n/app_ar.arb` & `lib/l10n/app_en.arb` (if needed for address required guidance)

**Interfaces:**
- In `FamilyPackageDaysBrowseRestaurantsSection`:
  - If `state.browseRestaurantsFailure != null`:
    - If error is `family.address_required`, display clear guidance explaining that the member needs a delivery address, with an action button allowing the user to navigate to `AppRoutes.familyAddresses`.
    - Otherwise, display `ApiErrorWidget` or standard error presenter with retry.
  - Only show `EmptyStateWidget` when `!state.isBrowseRestaurantsLoading && state.browseRestaurantsFailure == null && state.browseRestaurants.isEmpty`.

- [ ] **Step 1: Check existing localization keys for restaurants empty and address error**
Add `family_address_required_error` / `family_go_to_addresses` in `app_ar.arb` and `app_en.arb` if missing. Run `flutter gen-l10n`.

- [ ] **Step 2: Update `FamilyPackageDaysBrowseRestaurantsSection` widget tree**
Render error view when `browseRestaurantsFailure != null`.

- [ ] **Step 3: Run family package days tests**
Run: `flutter test test/family_package_days_refactor_test.dart`

---

### Task 5: End-to-End Verification, Git Commit & Push

- [ ] **Step 1: Run full test suite for family flow**
Run: `flutter test test/family_*`
- [ ] **Step 2: Run analyze check**
Run: `flutter analyze lib/features/family_addresses lib/features/family_package_days`
- [ ] **Step 3: Git status & diff review**
Verify only relevant files are staged and changed.
- [ ] **Step 4: Commit and push**
Run `git add ...` and `git commit -m "..."`, then `git push origin ...`.
