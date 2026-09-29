# Address Feature Performance & Rebuild Optimization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Eliminate redundant network endpoint calls (double-fetching addresses, catalog re-fetching, race conditions) and optimize rendering performance by eliminating unnecessary widget and map rebuilds in `lib/features/addresses`.

**Architecture:** Feature-Based Clean Architecture following `rules/rules_backend.md` and `rules/ui_rules.md`. Repository-level in-memory caching for locations catalog and area blocks; atomic state emissions in `AddressesViewModel`; value equality (`operator ==` & `hashCode`) for `AddressesState` hierarchy to ensure `buildWhen` and `listenWhen` accurately throttle rebuilds; UI decoupling of `GoogleMap` from state changes.

**Tech Stack:** Flutter, Dart, flutter_bloc (Cubit), get_it, injectable, Google Maps Flutter.

**Spec:** Current codebase analysis of `lib/features/addresses/`.

## Global Constraints
- Strictly follow `rules/rules_backend.md` and `rules/ui_rules.md`.
- No hardcoded colors; use `context.colorScheme`.
- Never use `AppColors` directly in widgets.
- No hardcoded strings; use `context.localization`.
- Existing project architecture has priority; do not introduce external packages.
- Keep all existing business logic intact (bounds checking, autofill resolution, family address handling).

## Review Focus
1. User enters and cancels (presses Back) from `AddressChooseLocationScreen` without saving -> verify NO network calls are triggered upon return.
2. Saving or updating an address -> verify `getCustomerAddresses` is called exactly ONCE, not twice.
3. Multiple map drags in quick succession -> verify only the latest camera idle position updates the address, without race conditions or overwriting from earlier responses.
4. Changing a dropdown in `HomeAddressFormCard` (Governorate, Area, Block) -> verify text fields and `GoogleMap` do NOT rebuild.
5. Opening and reopening the location picker -> verify `LocationsCatalog` is served from in-memory cache without hitting HTTP endpoint again.

---

### Task 1: Repository Caching for Locations Catalog & Blocks

**Files:**
- Modify: `lib/features/addresses/data/repo/addresses_repository_impl.dart`

**Interfaces:**
- Consumes: `AddressesRemoteDataSource.getLocationsCatalog(countryCode, areaId)`
- Produces: In-memory cached responses for catalog by countryCode and area blocks by areaId.

- [ ] **Step 1: Add catalog and area block caches to `AddressesRepositoryImpl`**
  In `lib/features/addresses/data/repo/addresses_repository_impl.dart`:
  - Add `final Map<String, LocationsCatalogEntity> _catalogCache = {};`
  - Add `final Map<String, LocationsCatalogEntity> _areaBlocksCache = {};`
  - In `getLocationsCatalog(String countryCode, String? areaId)`:
    - If `areaId == null` and `_catalogCache.containsKey(countryCode)`: return `ApiSuccessResult(_catalogCache[countryCode]!)`.
    - If `areaId != null` and `_areaBlocksCache.containsKey(areaId)`: return `ApiSuccessResult(_areaBlocksCache[areaId]!)`.
    - Otherwise perform `safeApiCall`, store in cache on success, and return.

- [ ] **Step 2: Verify compilation and analysis**
  Run: `flutter analyze lib/features/addresses/data/repo/addresses_repository_impl.dart`
  Expected: No errors.

---

### Task 2: Eliminate Redundant Address Fetches on Save and Cancel

**Files:**
- Modify: `lib/features/addresses/presentation/screens/address_choose_location_screen.dart`
- Modify: `lib/features/addresses/presentation/screens/addresses_screen.dart`
- Modify: `lib/features/addresses/presentation/manager/addresses_view_model.dart`

**Interfaces:**
- `AddressChooseLocationScreen`: Returns `true` via `Navigator.pop(context, true)` when an address action succeeds.
- `AddressesScreen`: Checks the return value of `_openAddressEditor`; only triggers `GetCustomerAddressesEvent()` if `result == true`.
- `AddressesViewModel`: Removes redundant `await _getCustomerAddresses()` in temporary/child ViewModel instances when the parent screen will fetch anyway, or ensures only one fetch runs.

- [ ] **Step 1: Update `AddressChooseLocationScreen` navigation on success**
  In `lib/features/addresses/presentation/screens/address_choose_location_screen.dart`:
  - When `state.action.isSuccess`: If `widget.args?.familyMemberId != null`, pop with `true`.
  - For normal address flows: Pop back to `AppRoutes.addresses` passing `true` as result (`Navigator.of(context).pop(true)`).

- [ ] **Step 2: Update `AddressesScreen._openAddressEditor` to only fetch on confirmed save**
  In `lib/features/addresses/presentation/screens/addresses_screen.dart`:
  - Update `_openAddressEditor`:
    ```dart
    final result = await Navigator.of(context).pushNamed(
      AppRoutes.addressChooseLocation,
      arguments: AddressChooseLocationArgs(initialAddress: initialAddress),
    );

    if (!context.mounted) return;

    if (result == true) {
      context.read<AddressesViewModel>().doIntent(
        const GetCustomerAddressesEvent(),
      );
    }
    ```

- [ ] **Step 3: Clean up redundant `_getCustomerAddresses()` call in `_addCustomerAddress` and `_updateCustomerAddress`**
  In `lib/features/addresses/presentation/manager/addresses_view_model.dart`:
  - Note: In standalone screens like `AddressesScreen`, `_deleteCustomerAddress` and `_confirmSetDefaultAddress` stay on the same screen, so they still need `_getCustomerAddresses()`.
  - For `_addCustomerAddress` and `_updateCustomerAddress`, which run inside `AddressChooseLocationScreen` that immediately closes, avoid the redundant second fetch before popping since `AddressesScreen` will fetch immediately upon receiving `result == true`.

- [ ] **Step 4: Verify compilation**
  Run: `flutter analyze lib/features/addresses/presentation/screens/ lib/features/addresses/presentation/manager/`
  Expected: No errors.

---

### Task 3: Implement Value Equality (`operator ==` & `hashCode`) in `AddressesState`

**Files:**
- Modify: `lib/features/addresses/presentation/manager/addresses_state.dart`

**Interfaces:**
- Produces: Proper value equality across `AddressesState`, `CustomerAddressesState`, `LocationsCatalogState`, `AddressesActionState`, `MapAutofillState`, and `AddressCoveragePreviewState`.

- [ ] **Step 1: Implement `operator ==` and `hashCode` in all sub-states**
  In `lib/features/addresses/presentation/manager/addresses_state.dart`:
  - Implement `operator ==` and `hashCode` in:
    - `CustomerAddressesState`: compare `isLoading`, `isSuccess`, `failure`, and `items` (using `listEquals` from `package:flutter/foundation.dart`).
    - `LocationsCatalogState`: compare `isLoading`, `isSuccess`, `data`, `selectedGovernorate`, `selectedArea`, `selectedBlock`, `failure`.
    - `AddressesActionState`: compare `isLoading`, `isSuccess`, `errorMessage`, `failure`, `address`, `deliveryChangeNotice`.
    - `MapAutofillState`: compare `isLoading`, `isSuccess`, `autofill`, `failure`.
    - `AddressCoveragePreviewState`: compare `isLoading`, `isSuccess`, `preview`, `pendingAction`, `targetAddressId`, `pendingRequest`, `failure`.
    - `AddressesState`: compare all 5 sub-states.

- [ ] **Step 2: Verify `flutter analyze`**
  Run: `flutter analyze lib/features/addresses/presentation/manager/addresses_state.dart`
  Expected: No errors.

---

### Task 4: Atomic State Emissions & Request Sequence Guarantees in `AddressesViewModel`

**Files:**
- Modify: `lib/features/addresses/presentation/manager/addresses_view_model.dart`

**Interfaces:**
- Produces: Single atomic `emit` when reverse-geocoding/geocoding updates both catalog selection and autofill state; request ID tracking to avoid race conditions.

- [ ] **Step 1: Add request sequence tracking for geocoding and reverse geocoding**
  In `lib/features/addresses/presentation/manager/addresses_view_model.dart`:
  - Add `int _geocodeRequestId = 0;`
  - In `_reverseGeocode` and `_geocodeAddress`: Increment `_geocodeRequestId`, capture `final requestId = _geocodeRequestId;`.
  - After `await`, if `requestId != _geocodeRequestId`, discard the stale response.

- [ ] **Step 2: Combine catalog update and autofill update into a single `emit`**
  - In `_applyAutofillToCatalog`, return `LocationsCatalogState` rather than calling `emit()` mid-flow.
  - In `_reverseGeocode` and `_geocodeAddress`, emit `state.copyWith(locations: updatedLocations, mapAutofill: state.mapAutofill.copyWith(...))` once.

- [ ] **Step 3: Align distance threshold for reverse geocoding**
  - Use `0.0001` (~11 meters) consistently in both ViewModel and UI to prevent firing requests for trivial jitter.

---

### Task 5: UI Rebuild Optimizations in Map View & Form Card

**Files:**
- Modify: `lib/features/addresses/presentation/widgets/address_choose_location_map_view.dart`
- Modify: `lib/features/addresses/presentation/widgets/home_address_form_card.dart`
- Modify: `lib/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart`
- Modify: `lib/features/addresses/presentation/manager/address_entry_flow_controller.dart`

**Interfaces:**
- Produces: Isolated dimmer overlay via `ValueNotifier<bool>` without full `GoogleMap` rebuilds; separate debounce timers; removed dead code; compliant theme styling.

- [ ] **Step 1: Separate debounce timers and avoid `setState` for resolving overlay**
  In `lib/features/addresses/presentation/widgets/address_choose_location_map_view.dart`:
  - Split `Timer? _debounceTimer;` into `Timer? _mapDebounceTimer;` and `Timer? _searchDebounceTimer;`.
  - Replace `_isLocationResolving` state boolean with `final ValueNotifier<bool> _isLocationResolvingNotifier = ValueNotifier(false);`.
  - In `_setLocationResolving(bool value)`, update `_isLocationResolvingNotifier.value = value` instead of calling `setState()`.
  - Wrap only the dimmer overlay in `ValueListenableBuilder<bool>`, keeping the `GoogleMap` completely unaffected.
  - Store `gestureRecognizers` in a `late final` field to avoid recreating `Factory` on every build.

- [ ] **Step 2: Convert `HomeAddressFormCard` to `StatelessWidget` and optimize `_showOptions`**
  In `lib/features/addresses/presentation/widgets/home_address_form_card.dart`:
  - Convert `HomeAddressFormCard` from `StatefulWidget` to `StatelessWidget`.
  - In `_showOptions`: Remove `shrinkWrap: true` or wrap in a constrained `SizedBox` / `Flexible` so `ListView.separated` lazily virtualizes long area/block lists.

- [ ] **Step 3: Fix theme color rule violation in `AddressCoveragePreviewBottomSheet`**
  In `lib/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart`:
  - Line 277: Replace `AppColors.addressesInputLabel` with `color.outlineVariant`.
  - Remove unused import of `colors.dart`.

- [ ] **Step 4: Clean up dead code in `address_entry_flow_controller.dart`**
  In `lib/features/addresses/presentation/manager/address_entry_flow_controller.dart`:
  - Remove unused `AddressActionSuccessTracker` and `AddressOptimisticAdvanceTracker` classes.

---

### Task 6: Full Verification & Analysis

**Files:**
- Entire `lib/features/addresses/` directory

- [ ] **Step 1: Run Flutter Analyze**
  Run: `flutter analyze lib/features/addresses/`
  Expected: 0 issues found.

- [ ] **Step 2: Run Flutter Tests**
  Run: `flutter test test/` (or addresses tests if present).
  Expected: All tests pass.
