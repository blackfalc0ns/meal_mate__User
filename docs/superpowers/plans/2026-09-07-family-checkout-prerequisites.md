# Family Checkout Prerequisites Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add mandatory per-basket-member allergies and addresses before completing family checkout.

**Architecture:** Add family-specific data/domain/presentation features for member-owned mutations while reusing the existing allergy catalog, address DTOs/mappers, map/form widgets, and family checkout UI. A shared basket predicate determines which unpaid members participate in every post-plan step.

**Tech Stack:** Flutter, Dart, Cubit, Dio/Retrofit, GetIt/Injectable, json_serializable, flutter_test.

**Spec:** `docs/superpowers/specs/2026-09-07-family-allergies-addresses-checkout-design.md`

## Global Constraints

- Preserve feature-based Clean Architecture and the existing `ApiServices`, `ApiResult`, `safeApiCall`, interceptors, and DI.
- Response DTO fields are nullable; request fields follow the backend contract.
- Do not change individual allergy or address behavior.
- Do not add a family dietary-preference step or gate checkout on rejected ingredients.
- Use localized UI text and existing theme/style/spacing components.

---

### Task 1: Basket Membership Contract

**Files:**
- Modify: `lib/features/family_subscription_setup/domain/entities/family_member_entity.dart`
- Test: `test/family_basket_member_test.dart`

**Interfaces:**
- Produces: `bool get isInCheckoutBasket`, true when the member has no subscription ID and has a complete plan.

- [ ] Write a failing table-driven test covering complete unpaid, incomplete unpaid, and already subscribed members.
- [ ] Run `flutter test test/family_basket_member_test.dart`; expect the missing getter failure.
- [ ] Implement `isInCheckoutBasket => memberSubscriptionId == null && isPlanCompleted`.
- [ ] Run the test and commit the entity plus test.

### Task 2: Family Allergy API Contract

**Files:**
- Create: `lib/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart`
- Create: `lib/features/family_allergies/data/data_source/family_allergies_remote_data_source.dart`
- Create: `lib/features/family_allergies/data/data_source/family_allergies_remote_data_source_impl.dart`
- Create: `lib/features/family_allergies/data/repo/family_allergies_repository_impl.dart`
- Create: `lib/features/family_allergies/domain/entities/family_member_allergy_selection.dart`
- Create: `lib/features/family_allergies/domain/repo/family_allergies_repository.dart`
- Create: `lib/features/family_allergies/domain/usecase/save_family_member_allergies_usecase.dart`
- Modify: `lib/core/network/network_constants.dart`
- Modify: `lib/core/network/api_services.dart`
- Test: `test/family_allergies_contract_test.dart`

**Interfaces:**
- Consumes: existing allergy catalog use case.
- Produces: `saveMemberAllergies(String memberId, List<FamilyMemberAllergySelection>) -> ApiResult<bool>`.

- [ ] Write failing serialization tests asserting `NONE` becomes `{'allergies':[{'code':'NONE'}]}` and MILK High includes `severity` only.
- [ ] Write a failing Retrofit boundary test for `PUT /members/{memberId}/allergies` returning `true`.
- [ ] Run both tests and confirm missing types/endpoints.
- [ ] Implement nullable response-safe API layers and map domain selections to the family request DTO.
- [ ] Generate JSON, Retrofit, and DI outputs.
- [ ] Run the focused tests and commit.

### Task 3: Family Allergy Screen and Gate

**Files:**
- Create: `lib/features/family_allergies/presentation/manager/family_allergies_event.dart`
- Create: `lib/features/family_allergies/presentation/manager/family_allergies_state.dart`
- Create: `lib/features/family_allergies/presentation/manager/family_allergies_view_model.dart`
- Create: `lib/features/family_allergies/presentation/screens/family_allergies_screen.dart`
- Create focused widgets under `lib/features/family_allergies/presentation/widgets/`
- Modify: routing and ARB translation files.
- Test: `test/family_allergies_screen_test.dart`

**Interfaces:**
- Produces: per-member confirmed selections and navigation to `AppRoutes.familyAddresses` only when every basket member has a successful save.

- [ ] Write widget tests proving only basket members appear, NONE is selectable, there is no Skip button, and Next remains disabled before save.
- [ ] Run tests and confirm they fail for missing screen/state.
- [ ] Implement Cubit events for load catalog, select member, toggle allergy/NONE, and save current member.
- [ ] Build the screen from existing chips/member-strip/button components; show severity only for selected real allergens.
- [ ] Add localized Arabic/English strings and route from package completion to allergies.
- [ ] Generate localization/DI output, run tests, and commit.

### Task 4: Family Member Address API

**Files:**
- Create family-address data source/repository/use cases under `lib/features/family_addresses/`.
- Modify: `lib/core/network/network_constants.dart`
- Modify: `lib/core/network/api_services.dart`
- Test: `test/family_addresses_endpoint_test.dart`

**Interfaces:**
- Produces list/add/update/preview-new/preview-existing/set-default methods, each requiring `memberId`.

- [ ] Write failing MockDio/Retrofit tests for all six documented paths and path substitutions.
- [ ] Run and confirm endpoint failures.
- [ ] Implement APIs using existing `CustomerAddressRequestDto`, `CustomerAddressResponseDto`, and coverage DTOs.
- [ ] Implement repositories with `safeApiCall` and existing address mappers.
- [ ] Generate Retrofit/DI output, run tests, and commit.

### Task 5: Family Address Screen

**Files:**
- Create manager/screen/widgets under `lib/features/family_addresses/presentation/`.
- Modify routing and ARB files.
- Test: `test/family_addresses_flow_test.dart`

**Interfaces:**
- Consumes: Task 4 use cases plus existing location catalog/geocode use cases and reusable address map/form widgets.
- Produces: navigation to family payment after all basket members have a covered selected address.

- [ ] Write widget/state tests for member isolation, manual/map requests, uncovered blocking, and last-member navigation.
- [ ] Run tests and confirm missing behavior.
- [ ] Implement per-member address state keyed by `memberId` and preview-before-save behavior.
- [ ] Reuse the individual map/manual form components without changing their individual APIs.
- [ ] Add localized routes/actions, run tests, and commit.

### Task 6: Complete Family Summary and Checkout

**Files:**
- Modify family summary DTO/entity/mapper, checkout request entity/DTO/repository/use case/ViewModel, blocker routing, and payment screen.
- Test: `test/family_checkout_contract_test.dart`
- Test: `test/family_checkout_blocker_navigation_test.dart`

**Interfaces:**
- Produces stable per-attempt `correlationId` and actionable blocker destinations.

- [ ] Write failing DTO tests for family identifiers, English tier name, checkout endpoint, final price, manager-prepaid fields, and checkout response.
- [ ] Write a failing request test requiring `correlationId` in checkout JSON.
- [ ] Write blocker mapping tests for allergies, incomplete plan, address, not-draft, and invalid amount.
- [ ] Implement missing DTO/entity/mapper fields and propagate `correlationId` through every layer.
- [ ] Generate one correlation ID when a payment attempt begins and reuse it on retries until success/cancellation.
- [ ] Correct Active handling to status `3`, route blockers, open the existing payment WebView, and refresh summary after initialization failure.
- [ ] Run tests and commit.

### Task 7: End-to-End Verification

**Files:**
- Modify only defects found in the new family flow.

- [ ] Run `dart format` on touched files.
- [ ] Run all focused family contract and widget tests.
- [ ] Run `flutter analyze`; distinguish new findings from the known addresses async-context info.
- [ ] Run `flutter test`; distinguish unrelated pre-existing influencer/widget failures.
- [ ] Run `git diff --check` and inspect that no unrelated files changed.
- [ ] Commit final generated outputs and integration corrections.
