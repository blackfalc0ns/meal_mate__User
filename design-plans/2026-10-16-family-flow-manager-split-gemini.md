# Family Flow Manager Split Implementation Plan

> **For agentic workers:** Read this plan, `AGENTS.md`, `rules/ui_rules.md`, and `rules/rules_backend.md` before editing. Execute task by task. Do not rewrite the feature or change UI behavior while moving state ownership.

**Goal:** Replace the oversized shared `FamilyPlanState` usage across the family flow with a feature-owned `Event + State + ViewModel` per step, while keeping `family_shared` as the flow coordinator and preserving all existing API, navigation, UI, and snapshot behavior.

**Architecture:** Each backend-enabled feature keeps the existing Clean Architecture path: UI → Event → ViewModel → UseCase → Repository → RemoteDataSource → ApiServices, with DTO → Mapper → Entity on the response path. `family_shared` owns only cross-step flow coordination, current step, target member, and the existing snapshot store; feature managers own only their own request, selection, loading, and failure state.

**Tech Stack:** Flutter, `flutter_bloc`, Injectable/GetIt, Retrofit, existing `ApiResult`/`safeApiCall`, existing domain entities and shared widgets.

**Spec:** `rules/rules_backend.md`, `rules/ui_rules.md`, and this plan.

## Global Constraints

- Preserve existing routes, API endpoints, DTOs, mappers, use cases, repositories, UI, localization, RTL/LTR behavior, and snapshot semantics unless a task explicitly requires a compatible state-owner change.
- Do not introduce a new state-management package, generic Cubit/base repository, second Dio client, second API service, or a new result wrapper.
- Use constructor injection and existing `@injectable`/`@Injectable(as: ...)` registrations.
- Keep DTOs in `data`, entities and repository contracts in `domain`, and `Event + State + ViewModel` in `presentation/manager`.
- Do not modify generated `*.g.dart`, `api_services.g.dart`, or `di.config.dart` manually.
- Do not delete fake data, entities, or shared widgets until repository-wide references prove they are unused.
- Do not change visual design or add new UI text, colors, spacing, or assets.
- Keep exactly one immutable state class with `copyWith` per feature, following the existing project pattern.

## Target Structure

```text
family_shared/presentation/manager/
├── family_subscription_flow_event.dart
├── family_subscription_flow_state.dart
└── family_subscription_flow_view_model.dart

family_subscription_setup/presentation/manager/
├── family_subscription_setup_event.dart
├── family_subscription_setup_state.dart
└── family_subscription_setup_view_model.dart

family_programs/presentation/manager/
├── family_programs_event.dart
├── family_programs_state.dart
└── family_programs_view_model.dart

family_package_days/presentation/manager/
├── family_package_days_event.dart
├── family_package_days_state.dart
└── family_package_days_view_model.dart

family_allergies/presentation/manager/
├── family_allergies_event.dart
├── family_allergies_state.dart
└── family_allergies_view_model.dart

family_addresses/presentation/manager/
├── family_addresses_event.dart
├── family_addresses_state.dart
└── family_addresses_view_model.dart

family_checkout/presentation/manager/
├── family_checkout_event.dart
├── family_checkout_state.dart
└── family_checkout_view_model.dart
```

## State Ownership Rules

### `family_shared` coordinator state

Keep only:

- current `FamilyFlowCurrentEntity?` snapshot reference
- `isLoading`
- `failure`
- `currentStep`
- `targetMemberId`
- coordinator methods for loading/restoring snapshot, updating the current step, selecting target member, and checking step prerequisites

Keep `FamilyFlowSnapshotStore` as the temporary cross-step store. Do not move feature-specific loading flags or API failures into this state.

### `FamilyProgramsState`

Keep only fields required by programs:

- `currentFlow` or the minimum member projection required by the existing UI
- `programs`
- `selectedMemberIndex` or `selectedMemberId`, following the existing route contract
- `selectedProgramIndex` or `selectedProgramId`
- `isCurrentFlowLoading`
- `isProgramsLoading`
- `isLoadingMorePrograms`
- `hasMorePrograms`
- `programsPage`
- `isPlanSaving`
- `failure`

Do not copy packages, relationships, addresses, bundles, durations, tiers, restaurants, summary, payment methods, or checkout fields into this state.

Apply the same rule to every other feature: keep only that step's data and operation flags.

## Task 1: Baseline and dependency map

**Files:**
- Read: `AGENTS.md`, `rules/ui_rules.md`, `rules/rules_backend.md`
- Inspect: all `lib/features/family_*` folders involved in the flow
- Inspect: `lib/core/network`, `lib/core/errors`, `lib/core/di`
- Inspect: existing tests and generated registration files

- [ ] Run `git status --short` and record pre-existing changes. Do not revert them.
- [ ] Trace routes from `family_subscription_flow_screen.dart` through setup, programs, package days, allergies, addresses, and checkout.
- [ ] Search every reference to `FamilyPlanState`, `FamilyProgramsViewModel`, `FamilySubscriptionFlowViewModel`, and all family events.
- [ ] Map which use cases and repositories each current manager actually calls.
- [ ] Record which fields each screen reads before removing any field.
- [ ] Run the existing focused family tests and `flutter analyze` to establish a baseline.

**Exit condition:** A dependency table exists showing each state field, its consumers, and its owning feature.

## Task 2: Stabilize the shared flow coordinator

**Files:**
- Modify only if required: `family_shared/presentation/manager/family_subscription_flow_event.dart`
- Modify only if required: `family_shared/presentation/manager/family_subscription_flow_state.dart`
- Modify only if required: `family_shared/presentation/manager/family_subscription_flow_view_model.dart`
- Reuse: `family_subscription_setup/domain/entities/family_flow_snapshot_store.dart`

- [ ] Keep coordinator loading through `GetFamilyFlowCurrentUseCase`; do not call `ApiServices` or a data source directly.
- [ ] Keep snapshot restoration before network loading when the current store contains a valid flow.
- [ ] Preserve `currentStep`, `targetMemberId`, `canProceedTo`, and target-member resolution semantics.
- [ ] Add coordinator events only if the existing project pattern requires them; otherwise keep simple coordinator methods already used by `FamilyFlowScope`.
- [ ] Ensure `updateMemberProgram`, `updateMemberAddress`, allergies updates, and disliked-ingredient updates update the snapshot and emit the latest flow without owning feature loading flags.
- [ ] Add equality guards before emitting unchanged `currentStep` or `targetMemberId`.
- [ ] Run analyzer and the existing flow-scope tests.

**Exit condition:** `family_shared` is a small coordinator/session layer and contains no programs, payment, or package-specific state.

## Task 3: Extract `FamilyProgramsState` without changing behavior

**Files:**
- Modify: `family_programs/presentation/manager/family_programs_state.dart`
- Modify: `family_programs/presentation/manager/family_programs_event.dart`
- Modify: `family_programs/presentation/manager/family_programs_view_model.dart`
- Modify: `family_programs/presentation/screens/family_program_setup_screen.dart`
- Modify: `family_programs/presentation/widgets/*` only for state type/field changes

- [ ] Replace `FamilyPlanState` with `FamilyProgramsState` and keep immutable `copyWith` semantics.
- [ ] Keep the existing sealed events and add no event for UI-only local calculations.
- [ ] Preserve current flow loading, programs loading, load-more guards, selected-member behavior, pending program IDs, snapshot updates, and sequential save behavior.
- [ ] Keep the API path through `GetFamilyFlowCurrentUseCase`, `GetFamilyProgramsUseCase`, and `SaveFamilyMemberPlanUseCase`.
- [ ] Ensure the ViewModel still uses constructor injection and `doIntent` dispatch.
- [ ] Synchronize selected program when either current flow or programs finish loading; do not rely only on widget-side effective-index calculations.
- [ ] Model the response's `availability` only if the backend contract requires program selection to respect `canSelect`; if added, create nullable response DTO fields, a domain entity, and a mapper field rather than reading DTOs in UI.
- [ ] Preserve `ApiErrorWidget` for screen failure with no usable data and `EmptyStateWidget` for successful empty programs.
- [ ] Run tests covering initial load, empty response, pagination, member selection, program selection, and save failure.

**Exit condition:** `family_programs` compiles and behaves identically while its manager state contains no unrelated feature fields.

## Task 4: Move programs UI to selective listeners

**Files:**
- Modify: `family_programs/presentation/screens/family_program_setup_screen.dart`
- Modify: `family_programs/presentation/widgets/family_program_content.dart`
- Modify: `family_programs/presentation/widgets/family_program_member_section.dart`
- Modify: `family_programs/presentation/widgets/family_program_selection_section.dart`
- Modify: `family_programs/presentation/widgets/family_program_actions_section.dart`

- [ ] Replace broad `BlocBuilder<FamilyProgramsViewModel, FamilyPlanState>` with the new state type and narrow `BlocSelector`/`buildWhen` boundaries.
- [ ] Let the member section observe only members and selected member.
- [ ] Let the selection section observe only programs, selected program, loading, and pagination fields.
- [ ] Let actions observe only `selectedMember.hasProgram` and `isPlanSaving`.
- [ ] Remove `FamilyFlowScope.updateFamilyName` from `build`; perform it through a listener or coordinator update triggered by state changes.
- [ ] Keep screen-level listener responsible for navigation only after successful save. The action widget must dispatch save and must not navigate immediately.
- [ ] Keep the standalone and active-flow routes equivalent except for scaffold/header composition.
- [ ] Preserve all existing widgets and visual structure.
- [ ] Do not create controllers, futures, streams, or notifiers inside `build`.

**Exit condition:** Selecting a program does not rebuild the static header/member section unnecessarily, and saving cannot navigate before success.

## Task 5: Extract `FamilyPackageDaysState`

**Files:**
- Modify/create manager files under `family_package_days/presentation/manager/`
- Modify the feature screen/widgets only for state type and selector changes

- [ ] Keep only selected member, selected program/bundle/duration, custom duration, Friday inclusion, loading flags, and failures required by package-days APIs.
- [ ] Preserve existing use cases, repository contracts, DTOs, mappers, and API service calls.
- [ ] Preserve pending selections and snapshot updates when moving between members.
- [ ] Keep events sealed and route UI actions through `doIntent`.
- [ ] Replace any `FamilyPlanState` references in this feature with `FamilyPackageDaysState`.
- [ ] Run focused package-days tests before moving on.

## Task 6: Extract `FamilyAllergiesState`

**Files:**
- Modify/create manager files under `family_allergies/presentation/manager/`
- Modify the feature screen/widgets only for state type and selector changes

- [ ] Keep only the selected member, allergy selections, disliked ingredients, loading flags, save status, and failures required by allergies.
- [ ] Preserve snapshot update methods and existing backend use cases.
- [ ] Use the existing `ApiResult` and typed failure handling.
- [ ] Keep usable content visible when a partial section request fails; use `InlineApiErrorWidget` where the existing UI supports inline retry.
- [ ] Run focused allergy tests.

## Task 7: Extract `FamilyAddressesState`

**Files:**
- Modify/create manager files under `family_addresses/presentation/manager/`
- Modify address screens/widgets only for state type and selector changes

- [ ] Keep only target member, addresses, selected address, coverage/loading flags, save status, and failures required by addresses.
- [ ] Preserve `GetFamilyFlowCurrentUseCase` usage only where the current feature contract needs it; otherwise read target member from the coordinator/snapshot.
- [ ] Keep full-screen `ApiErrorWidget` only when no usable address content exists, and inline errors when address data remains visible.
- [ ] Preserve address updates in `FamilyFlowSnapshotStore`.
- [ ] Run focused address tests.

## Task 8: Extract `FamilyCheckoutState`

**Files:**
- Modify/create manager files under `family_checkout/presentation/manager/`
- Modify checkout screens/widgets only for state type and selector changes

- [ ] Keep only summary, payment methods, selected payment method, checkout loading/result, target member/flow snapshot, and failures required by checkout.
- [ ] Preserve payment and checkout use cases, repository contracts, and API flow.
- [ ] Do not move checkout business logic into `family_shared`.
- [ ] Keep error handling aligned with `rules/rules_backend.md`: full-screen error only with no usable content, inline error for partial sections, and existing action feedback for submit failures.
- [ ] Run focused checkout tests.

## Task 9: Remove obsolete `FamilyPlanState` references safely

**Files:**
- Repository-wide references under `lib/`, `test/`, and DI configuration sources

- [ ] Run `rg -n "FamilyPlanState|family_plan_state" lib test`.
- [ ] Replace each reference with the owning feature state, not with a new shared replacement.
- [ ] Keep shared domain entities such as `FamilyFlowCurrentEntity`, `FamilyMemberEntity`, and `FamilyFlowSnapshotStore` where they are reused legitimately.
- [ ] Do not move DTOs, repositories, or use cases across feature boundaries just to shorten imports.
- [ ] Delete the old state only after `rg` shows no live references and analyzer confirms no stale imports.
- [ ] Never delete or modify generated files manually.

**Exit condition:** No feature manager depends on the monolithic state, and every state field has one clear owner.

## Task 10: Validate the complete flow

**Files:**
- Tests under `test/` following existing conventions

- [ ] Test restoring a cached flow and restoring the current step/target member.
- [ ] Test moving from setup to programs while preserving members and family name.
- [ ] Test selecting programs for multiple members and preserving pending selections.
- [ ] Test returning to a previous step and reading the latest session snapshot.
- [ ] Test failed save keeps the current screen and shows the existing error presentation.
- [ ] Test successful save navigates exactly once.
- [ ] Test app restart/force refresh loads server state instead of stale in-memory session data.
- [ ] Test each step's manager ignores unrelated state changes because it no longer receives a global state.

## Task 11: Final verification

- [ ] Run `dart run build_runner build --delete-conflicting-outputs` after DTO, Injectable, or Retrofit changes.
- [ ] Run `dart format --output=none --set-exit-if-changed` on changed Dart files.
- [ ] Run `flutter analyze`.
- [ ] Run focused family flow tests, then the repository test command.
- [ ] Run `git diff --check` and inspect `git status --short`.
- [ ] Manually verify Arabic/RTL and English/LTR, narrow and large screens, back navigation, retry, empty states, partial failures, save loading, and exactly-once navigation.
- [ ] Use DevTools rebuild tracking where available and document the result.
- [ ] Confirm only intended feature files and tests changed.

## Acceptance Criteria

- Every step has its own `Event + State + ViewModel` under its feature manager.
- `family_shared` contains only flow coordination, session/snapshot access, navigation support, shared widgets, and shared UI models.
- No feature manager owns the state of another feature.
- All backend calls still follow the mandated Clean Architecture path.
- No DTO leaks into domain or UI.
- Existing API behavior, navigation, UI, localization, and snapshot restoration remain intact.
- The old monolithic `FamilyPlanState` is removed only after all references are migrated and analyzer/tests pass.
- The flow returns to previous steps using the latest snapshot without losing unsaved-in-flow changes.

## Stop Conditions

- Stop if a feature consumes state that cannot be represented without inventing a new backend contract.
- Stop if the existing snapshot store cannot represent a required cross-step value; report the exact missing field before adding one.
- Stop if moving a state field would change API ownership or navigation semantics.
- Stop if generated code or pre-existing local modifications conflict with the migration; do not overwrite them.
- Stop if a screen currently depends on a shared field whose owner cannot be proven from repository usage.

