# Family Addresses Performance and Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce unnecessary rebuilds and repeated work in `family_addresses`, split oversized presentation responsibilities into focused widgets, remove verified dead state/code, and preserve the existing UI and Clean Architecture.

**Architecture:** Keep the existing Flutter + `flutter_bloc` + Injectable/Clean Architecture flow. Make rebuild boundaries explicit with `BlocSelector`/`buildWhen`, keep state-dependent UI in focused widgets, and keep all API/error behavior flowing through existing Core abstractions. Do not introduce a new state-management pattern or duplicate networking/error infrastructure.

**Tech Stack:** Flutter, Dart, `flutter_bloc`, `injectable`, GetIt, Retrofit, `ApiResult`, `safeApiCall`, existing theme/localization/spacing tokens, existing `lib/core/errors` widgets.

**Spec:** Read `AGENTS.md`, `rules/ui_rules.md`, `rules/rules_backend.md`, and the analysis of `lib/features/family_addresses` before implementation.

## Global Constraints

- Do not change the visual design, copy, navigation, API contracts, or business behavior.
- Follow `rules/ui_rules.md`: use `colorScheme`, localization, existing styles, spacing tokens, directional APIs, const widgets, and selective rebuilds.
- Follow `rules/rules_backend.md`: preserve `ApiResult`, `safeApiCall`, DTO → mapper → entity flow, Injectable constructor injection, existing `ApiServices`, and generated-file ownership.
- Reuse `lib/core/errors` before creating feature-specific error widgets: `ApiErrorWidget` for full-screen failure, `InlineApiErrorWidget` for partial failure, and existing empty/loading widgets where applicable.
- Do not edit `*.g.dart`, `di.config.dart`, or other generated files manually.
- Do not add packages or create a second networking/state-management abstraction.
- Do not delete a use case, repository method, or entity until repository-wide references and tests prove it is unused.
- Preserve existing uncommitted changes outside this feature.

---

### Task 1: Establish a baseline and dependency inventory

**Files:**
- Read: `lib/features/family_addresses/**`
- Read: `lib/core/errors/**`
- Read: `lib/core/network/api_services.dart`
- Read: `test/family_addresses_view_model_test.dart`
- Read: `test/family_addresses_loading_skeleton_test.dart`
- Read: `test/family_prerequisite_navigation_test.dart`
- Read: `test/family_subscription_operations_test.dart`
- Read: `test/family_subscription_routes_alignment_test.dart`

**Interfaces:**
- Produces a reference list of every public class/method and repository-wide usage before any deletion or split.

- [ ] Run `flutter analyze lib/features/family_addresses` and record the clean baseline.
- [ ] Run the focused tests listed above and record the baseline result.
- [ ] Search for `FamilyAddressesState.isSaving`, `FamilyAddressesState.addresses`, every family-address use case, and every `FamilyDeliveryAddress*` class across `lib` and `test`.
- [ ] Inspect the actual constructors and APIs in `lib/core/errors` before changing error rendering.
- [ ] Confirm the working tree contains no unrelated edits to include in this work.

---

### Task 2: Split `FamilyAddressesScreen` into focused widgets

**Files:**
- Modify: `lib/features/family_addresses/presentation/screens/family_addresses_screen.dart`
- Create: `lib/features/family_addresses/presentation/widgets/family_addresses_body.dart`
- Create: `lib/features/family_addresses/presentation/widgets/family_addresses_header.dart`
- Create: `lib/features/family_addresses/presentation/widgets/family_addresses_member_strip.dart`
- Create: `lib/features/family_addresses/presentation/widgets/family_addresses_actions.dart`

**Interfaces:**
- `FamilyAddressesBody` receives the selected member, flow mode, and the existing `FamilyAddressesViewModel` through the widget tree; it does not create a new state manager.
- `FamilyAddressesHeader` receives only the family name, flow mode, and localized display inputs required by the existing header/stepper.
- `FamilyAddressesMemberStrip` receives the current member list, selected index, completed member IDs, and the existing `selectMember` callback.
- `FamilyAddressesActions` receives the existing next-step callback and localized next-step label/icon.

- [ ] Move only the existing header/stepper composition into `FamilyAddressesHeader`; keep `color`, `locale`, `Spacing`, and inherited directionality rules.
- [ ] Move the member model mapping into `FamilyAddressesMemberStrip`; calculate the list only when its selector values change.
- [ ] Move the completion action section into `FamilyAddressesActions`; preserve the existing visibility condition and callback.
- [ ] Keep `FamilyAddressLocationStage` as the location-stage boundary; do not move business logic into the new widgets.
- [ ] Replace the broad screen `BlocConsumer` builder with a narrow listener plus selectors/build boundaries so changing coverage/editor state cannot rebuild unrelated family header content.
- [ ] Keep full-screen loading and failure behavior unchanged while delegating failure UI to the Core error widget identified in Task 1.
- [ ] Run formatter and focused widget/navigation tests.

---

### Task 3: Make screen-level error handling reuse `lib/core/errors`

**Files:**
- Modify: `lib/features/family_addresses/presentation/screens/family_addresses_screen.dart` or `family_addresses_body.dart` after Task 2
- Read/Reuse: `lib/core/errors/error_widgets/api_error_widget.dart`
- Read/Reuse: `lib/core/errors/error_widgets/inline_api_error_widget.dart` if a partial section error is required by the existing state

**Interfaces:**
- Retry must call the existing `FamilyAddressesViewModel.load(memberId: ...)` operation only.
- No feature-specific error-type branching may be added.

- [ ] Verify the `ApiErrorWidget.fromTypedFailure` constructor and use it when the required family data is unavailable.
- [ ] Keep the existing loading skeleton when loading is active.
- [ ] Keep usable content visible if a refresh fails after members are already loaded.
- [ ] Use `InlineApiErrorWidget` only for an independently failing section with usable surrounding content; do not replace the whole screen.
- [ ] Preserve existing snackbar behavior for address-editor action errors because those belong to the current editor interaction, not the initial screen load.
- [ ] Test initial-load failure, retry, refresh failure with existing data, and successful empty-member behavior.

---

### Task 4: Isolate `FamilyAddressLocationStage` rebuilds

**Files:**
- Modify: `lib/features/family_addresses/presentation/widgets/family_address_location_stage.dart`
- Create: `lib/features/family_addresses/presentation/widgets/family_address_map_section.dart`
- Create: `lib/features/family_addresses/presentation/widgets/family_address_coverage_section.dart`

**Interfaces:**
- `FamilyAddressMapSection` selects only `locations` and `action.isLoading` and receives the existing `AddressEntryFlowController`, member ID, and initial address.
- `FamilyAddressCoverageSection` selects only `coveragePreview` and the exact submit/loading value it needs; it keeps the existing events and callbacks.

- [ ] Move the map selector and `AddressChooseLocationMapView` into `FamilyAddressMapSection`.
- [ ] Move the coverage loading/preview selector into `FamilyAddressCoverageSection`.
- [ ] Keep the parent responsible only for ViewModel creation, lifecycle, listener side effects, and stacking the two sections.
- [ ] Preserve `ValueKey(widget.memberId)` and the coverage session key behavior.
- [ ] Ensure no API call, event dispatch, navigation, snackbar, future, stream, controller, or object with lifecycle ownership is created in `build`.
- [ ] Replace physical `Positioned(left/right)` in `family_address_location_loading_skeleton.dart` with `PositionedDirectional(start/end)` while preserving the same spacing and appearance.
- [ ] Verify that changing coverage pagination does not rebuild the map section, and changing map locations does not rebuild the coverage section.
- [ ] Run the location-stage and loading-skeleton tests.

---

### Task 5: Remove only verified dead state and simplify state updates

**Files:**
- Modify: `lib/features/family_addresses/presentation/manager/family_addresses_state.dart`
- Modify: `lib/features/family_addresses/presentation/manager/family_addresses_view_model.dart`
- Modify: affected tests only if they assert removed fields

**Interfaces:**
- Preserve the existing immutable `FamilyAddressesState` + `copyWith` architecture.
- Preserve all public behavior of `load`, `selectMember`, `addressSaved`, and `proceedToNextStep`.

- [ ] Remove `isSaving` and `addresses` only if Task 1 finds no repository-wide production/test references.
- [ ] Remove their `copyWith` parameters and constructor assignments in the same change; do not leave compatibility fields with no consumer.
- [ ] In `addressSaved`, compare the target member’s address ID/address before emitting if a duplicate callback would produce no state change; preserve `addressSaveRevision` semantics for a real save.
- [ ] Keep the existing request ID and `isClosed` guards.
- [ ] Add focused ViewModel tests for duplicate save callbacks, selecting the current member, invalid indexes, and stale load responses.
- [ ] Run `dart format` and the complete family-address ViewModel test file.

---

### Task 6: Review unused use cases and subscription-address code safely

**Files:**
- Candidate review: `lib/features/family_addresses/domain/usecase/family_addresses_usecases.dart`
- Candidate review: `lib/features/family_addresses/domain/repo/family_addresses_repository.dart`
- Candidate review: `lib/features/family_addresses/data/repo/family_addresses_repository_impl.dart`
- Candidate review: `lib/features/family_addresses/data/data_source/family_addresses_remote_data_source.dart`
- Candidate review: `lib/features/family_addresses/data/data_source/family_addresses_remote_data_source_impl.dart`
- Candidate review: `lib/features/family_addresses/domain/entities/family_delivery_address_entity.dart`
- Candidate review: `lib/features/family_addresses/data/models/**`

**Interfaces:**
- No API endpoint or domain type is removed without a complete repository-wide reference result and passing tests.

- [ ] Confirm whether `GetFamilyMemberAddressesUseCase`, `PreviewExistingFamilyMemberAddressUseCase`, and `SetDefaultFamilyMemberAddressUseCase` are used outside the current screen flow.
- [ ] Confirm whether subscription delivery address operations are consumed by `family_subscription_setup`, `family_shared`, or other features.
- [ ] If unused, remove the smallest complete vertical slice only: use case, repository contract method, implementation, remote data source method, DTO/entity/mapper code, generated files via build runner, and tests.
- [ ] If used elsewhere, leave the code in place and document it as intentionally shared; do not delete it merely because the current screen does not call it.
- [ ] Do not change backend endpoints or request/response contracts during this cleanup.

---

### Task 7: Validate architecture, rules, and performance

**Files:**
- Modify only files identified by Tasks 2–6
- Test: existing focused tests plus any new tests from Tasks 3–5

- [ ] Run `dart format` on changed Dart files.
- [ ] Run `flutter analyze lib/features/family_addresses`.
- [ ] Run all focused family-address tests, then `flutter test` if the focused suite passes.
- [ ] If annotations, Retrofit endpoints, or JSON DTOs changed, run `dart run build_runner build --delete-conflicting-outputs`; never edit generated files manually.
- [ ] Use Flutter DevTools rebuild tracking or an equivalent project performance tool to verify that changing one section does not rebuild unrelated sections.
- [ ] Verify both RTL and LTR rendering after replacing physical positioning.
- [ ] Verify all user-facing text still comes from localization, colors from `colorScheme`, spacing from `Spacing`, and styles from the existing style manager.
- [ ] Verify all full-screen/partial API errors use `lib/core/errors` and retry only the failed operation.
- [ ] Confirm no unrelated files changed and no unused imports, variables, methods, widgets, or classes remain.

---

## Acceptance Criteria

- The screen, header, member strip, map, coverage preview, and actions have independent rebuild boundaries where their state dependencies differ.
- Coverage changes do not rebuild the map; member selection does not rebuild unrelated static sections.
- No controllers, futures, streams, side effects, or API calls are created inside `build`.
- Large presentation files are split into focused widgets, with one widget class per file.
- Verified dead state/code is removed only after repository-wide usage checks.
- Existing Core error widgets under `lib/core/errors` are reused correctly.
- UI rules and backend Clean Architecture rules remain satisfied.
- `flutter analyze` and the relevant tests pass.
- No UI redesign, API contract change, package addition, or unrelated file modification occurs.
