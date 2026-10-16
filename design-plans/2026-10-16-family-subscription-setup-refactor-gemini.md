# Family Subscription Setup Performance Refactor Plan

> **For agentic workers:** Read this plan and the repository `AGENTS.md` before editing. Follow the existing Flutter architecture. Work task by task, run the verification commands after each task, and do not modify unrelated files.

**Goal:** Refactor `family_subscription_setup` so local form changes rebuild only the form, Bloc updates rebuild only the affected section, and the large setup screen is organized into independently readable sections without changing product behavior or visual identity.

**Architecture:** Keep `FamilySubscriptionSetupViewModel` and `FamilyPlanState` as the existing source of backend state. Keep temporary form state local, but move it from the screen-sized `FamilySubscriptionSetupContent` into a dedicated form widget. Replace broad screen-level rebuilding with narrow `BlocSelector`/`BlocListener` boundaries. The screen remains a composition layer.

**Tech Stack:** Flutter, `flutter_bloc`, existing theme/localization/spacing extensions, existing family feature widgets, Dart analyzer and Flutter tests.

**Spec:** This file and the project rules in `rules/ui_rules.md` and `AGENTS.md`.

## Global Constraints

- Read and follow `rules/ui_rules.md` for every UI file.
- Preserve the current routes, events, API behavior, validation messages, localization keys, colors, styles, spacing, assets, and RTL/LTR behavior.
- Do not add a package or introduce a new state-management approach.
- Do not modify unrelated files or the currently modified files outside this feature.
- Every `build` method must declare `color` and `locale` only when used.
- Use existing `BlocSelector`, `buildWhen`, spacing, styles, colors, localization keys, and reusable family widgets.
- Do not hardcode user-facing text, colors, spacing, asset paths, or breakpoints.
- Do not claim performance improvement without checking rebuild behavior or documenting that DevTools verification was unavailable.

## Current Evidence

- `family_subscription_setup_screen.dart` has duplicated `BlocListener`/`BlocConsumer` composition for the in-flow and standalone branches.
- `FamilySubscriptionSetupContent` receives the entire `FamilyPlanState`, owns three member-form controllers, member selection, relationship selection, gender selection, validation, submission, navigation, and the whole scroll view.
- Changes such as gender or relationship selection call `setState` on the screen-sized content widget.
- The screen builder is driven by `currentFlow`, so member updates rebuild the complete content tree.
- `FamilyPlanState` contains setup state plus programs, bundles, durations, tiers, restaurants, summary, payment, and checkout state; passing the full state widens rebuild scope.
- `FamilyAddMemberDialog` already demonstrates useful selective listening with `buildWhen`, `listenWhen`, and `BlocSelector`; reuse that pattern.

## Target Composition

```text
FamilySubscriptionSetupScreen
 └── FamilySubscriptionSetupBody
     ├── FamilySetupProgressSection
     ├── FamilySetupNameSection
     ├── FamilySetupMembersSection
     ├── FamilySetupMemberFormSection
     └── FamilySetupActionsSection
```

The exact file names may follow existing naming conventions, but each custom widget must be in its own file and each file must contain one widget class.

## Task 1: Record the baseline and protect the working tree

**Files:**
- Read: `AGENTS.md`, `rules/ui_rules.md`
- Read: all files under `lib/features/family_subscription_setup/presentation/`
- Do not modify existing product files in this task.

- [ ] Run `git status --short` and record the pre-existing modified files. Do not revert or overwrite them.
- [ ] Run `flutter analyze lib/features/family_subscription_setup` and save the baseline output.
- [ ] Trace the route that opens `FamilySubscriptionSetupScreen`, both `FamilyFlowScope` branches, member add/edit/delete, retry, and next navigation.
- [ ] Identify existing spacing, styles, localization keys, assets, selectors, and shared family widgets before creating anything.

**Exit condition:** The executor can explain which current changes are pre-existing and can run the feature without changing its behavior.

## Task 2: Remove duplicated screen listener composition

**Files:**
- Modify: `lib/features/family_subscription_setup/presentation/screens/family_subscription_setup_screen.dart`

**Interfaces:**
- Preserve `_buildContent`, `_shouldListen`, `_shouldListenForActions`, `_onStateChanged`, and `_onActionStateChanged` behavior.
- Preserve the difference between the standalone `Scaffold` branch and the active `FamilyFlowScope` branch.

- [ ] Extract one shared body widget or one shared listener subtree that contains the existing action listener and state listener.
- [ ] Keep `Scaffold`, app bar, and `SafeArea` as the only branch-specific composition.
- [ ] Ensure initialization still dispatches the same package/current-flow/relationships/addresses events exactly once per provider creation.
- [ ] Keep the loading, API error, content, and deleting-member overlay states unchanged.
- [ ] Run `dart format lib/features/family_subscription_setup/presentation/screens/family_subscription_setup_screen.dart`.
- [ ] Run `flutter analyze lib/features/family_subscription_setup/presentation/screens/family_subscription_setup_screen.dart`.

**Exit condition:** There is one source of truth for listeners and content building; both routes still show the same states and actions.

## Task 3: Narrow the screen state contract

**Files:**
- Modify: `lib/features/family_subscription_setup/presentation/screens/family_subscription_setup_screen.dart`
- Modify: `lib/features/family_subscription_setup/presentation/widgets/family_subscription_setup_content.dart` only as needed for the new contract.

- [ ] Stop passing the full `FamilyPlanState` into the content widget.
- [ ] Define explicit props for independently changing data, at minimum:
  - `FamilyFlowCurrentEntity? currentFlow` or the member list derived from it
  - `List<FamilyRelationshipEntity> relationships`
  - `bool isMemberSaving`
  - `bool isDeletingMember` only where the overlay needs it
  - the existing family-name controller and callbacks
- [ ] Use `BlocSelector` or narrowly scoped `BlocBuilder.buildWhen` at the screen/body boundary so changes to programs, bundles, payment, or unrelated state do not rebuild setup sections.
- [ ] Do not clone or introduce a second source of truth for backend state.
- [ ] Preserve all existing action listeners and snackbar behavior.
- [ ] Run analyzer and format the changed files.

**Exit condition:** Setup content no longer receives the monolithic state object, and unrelated `FamilyPlanState` fields cannot trigger its rebuild.

## Task 4: Extract the member form and move local state to the smallest widget

**Files:**
- Create or modify: `lib/features/family_subscription_setup/presentation/widgets/family_setup_member_form_section.dart`
- Modify: `lib/features/family_subscription_setup/presentation/widgets/family_subscription_setup_content.dart`
- Reuse: `family_setup_form_card.dart`, `family_relationship_picker_sheet.dart`, existing family field and gender widgets.

**Interfaces:**
- Inputs: controllers or locally owned controllers, selected relationship display, selected gender, saving flag, relationships, selected member id.
- Outputs: `onSubmit`, `onRelationshipTap` or an internal picker callback, `onMemberReset`, and navigation-independent form callbacks.

- [ ] Move `_nameController`, `_phoneController`, `_ageController`, `_selectedRelationshipCode`, `_selectedMemberId`, and `_gender` out of the screen-sized content state.
- [ ] Move `_resetMemberForm`, `_onMemberSelected`, `_onPickRelationship`, `_getRelationshipDisplayName`, and `_onAddOrUpdateMember` with the form state.
- [ ] Keep validation messages and event payloads exactly the same.
- [ ] Keep the existing `didUpdateWidget` reset behavior, but implement it inside the form widget or as a narrowly scoped `BlocListener` for `memberSaveSuccess`.
- [ ] Ensure `setState` runs only in this form widget and only when a value actually changes.
- [ ] Guard async relationship picker results with `mounted` as the current code does.
- [ ] Keep controllers out of `build`; dispose every controller in the owning state object.
- [ ] Run analyzer and format.

**Exit condition:** Typing, gender changes, relationship selection, member selection, and successful save rebuild only the form section and do not rebuild the member strip, stepper, or actions unnecessarily.

## Task 5: Make members a selective section

**Files:**
- Create or modify: `lib/features/family_subscription_setup/presentation/widgets/family_setup_members_section.dart`
- Modify: `lib/features/family_subscription_setup/presentation/widgets/family_subscription_setup_content.dart`
- Reuse: `family_setup_members_row.dart`, `family_setup_member_card.dart`, `family_setup_add_member_card.dart`, existing family member strip if it is the active design.

- [ ] Give the members section only the member list, maximum member count, selected member id, and callbacks it needs.
- [ ] Move avatar/model mapping into this section so it does not run when only the form changes.
- [ ] Add stable `ValueKey` values based on member id for member cards where the existing card API permits it; do not use list index as the identity.
- [ ] Preserve current add-member card count, selected state, horizontal scrolling behavior, and avatar asset mapping.
- [ ] Keep the current responsive behavior for four or fewer cards versus horizontal scrolling for larger counts.
- [ ] Run analyzer, format, and the existing relevant widget tests if present.

**Exit condition:** Member list changes rebuild the members section, while form typing and gender changes do not rebuild it.

## Task 6: Keep actions independent from form rebuilds

**Files:**
- Create or modify: `lib/features/family_subscription_setup/presentation/widgets/family_setup_actions_section.dart`
- Modify: `lib/features/family_subscription_setup/presentation/widgets/family_subscription_setup_content.dart`
- Reuse: `family_flow_actions.dart` and existing action callbacks.

- [ ] Move primary/secondary action composition into its own widget.
- [ ] Pass only localized labels, icons, callbacks, and the member-saving loading flag.
- [ ] Preserve the edit/add label switch and navigation callback.
- [ ] Ensure loading state is selected from `isMemberSaving` only.
- [ ] Do not move navigation or backend logic into a reusable presentational widget.

**Exit condition:** Member saving toggles the action loading indicator without rebuilding unrelated sections beyond what is required by the parent composition.

## Task 7: Simplify the content widget into a composition layer

**Files:**
- Modify: `lib/features/family_subscription_setup/presentation/widgets/family_subscription_setup_content.dart`

- [ ] Convert the content widget to `StatelessWidget` if no local state remains; otherwise keep only composition state that cannot be moved.
- [ ] Keep the existing scroll physics, horizontal padding, vertical spacing, progress-step visibility, and section order.
- [ ] Compose the extracted sections using explicit narrow props.
- [ ] Keep `FamilyFlowScope.isActive(context)` usage for flow-specific layout only; never infer direction from locale codes.
- [ ] Remove unused imports, methods, state fields, and helper calculations.
- [ ] Confirm no custom private widget classes are defined inside this file.
- [ ] Run format and analyzer.

**Exit condition:** The parent content file reads as layout composition and contains no member-form validation or controller lifecycle logic.

## Task 8: Consolidate initialization without changing request behavior

**Files:**
- Modify: `lib/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart`
- Modify: `lib/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart`
- Modify: `lib/features/family_subscription_setup/presentation/screens/family_subscription_setup_screen.dart`

- [ ] First inspect whether an existing initialization event pattern exists elsewhere in the project.
- [ ] If the existing pattern supports it, add one `InitializeFamilySubscriptionSetupEvent` carrying the optional selected package and dispatch it once from provider creation.
- [ ] Have the ViewModel preserve the current four logical operations and their loading/error semantics.
- [ ] Do not serialize independent requests unless the current backend contract requires ordering.
- [ ] Preserve the initial selected-package sync and `_didSyncInitialPackage` behavior.
- [ ] If introducing the event would widen scope or alter error semantics, leave initialization unchanged and document that decision in the final report.

**Exit condition:** No duplicate requests occur on rebuild, retry still works, and initial package synchronization behaves exactly as before.

## Task 9: Add targeted rebuild regression coverage

**Files:**
- Create or modify: the nearest existing test location for family subscription setup widgets; follow repository naming conventions.
- Do not create a new test framework or package.

- [ ] Add a widget test that changes gender in the member form and verifies the members section is not rebuilt, using a lightweight rebuild counter or existing test spy pattern.
- [ ] Add a widget test that emits an updated member list and verifies the members section updates while the form controllers preserve their text.
- [ ] Add a widget test that toggles `isMemberSaving` and verifies only the action loading state changes.
- [ ] Add a test for the standalone branch and the active `FamilyFlowScope` branch if the project has test helpers for the scope.
- [ ] Keep tests focused on observable rebuild boundaries and preserved behavior, not implementation details such as private method names.
- [ ] Run the focused tests first, then the full relevant feature test target.

**Exit condition:** Tests fail if a future change reintroduces broad rebuilds or loses form state during backend updates.

## Task 10: Final verification

**Files:**
- Read all changed files.
- No additional source changes unless required by verification failures.

- [ ] Run `dart format --output=none --set-exit-if-changed` on every changed Dart file.
- [ ] Run `flutter analyze lib/features/family_subscription_setup`.
- [ ] Run the focused family setup tests and record their output.
- [ ] Run the existing app test command if the repository defines one.
- [ ] Manually verify: initial loading, retry, empty members, existing members, add member, edit member, delete member, relationship picker, invalid form, member save error, next navigation, standalone route, active family flow, Arabic/RTL, English/LTR, and a narrow viewport.
- [ ] If DevTools is available, enable rebuild tracking and verify that gender/relationship changes do not rebuild the stepper, member section, or action section; otherwise state that rebuild tracking was not available.
- [ ] Run `git diff --check` and `git status --short`.
- [ ] Confirm only intended files under `family_subscription_setup` and its explicitly required tests were modified.

## Acceptance Criteria

- Changing gender or relationship rebuilds only the member form section.
- Typing in member fields does not rebuild the whole setup screen.
- Updating `currentFlow` refreshes the member section while preserving local form input unless a successful save intentionally resets it.
- Unrelated fields in `FamilyPlanState` do not rebuild setup content.
- Add/edit/delete behavior, snackbars, loading overlays, retry, navigation, localization, and responsive behavior remain unchanged.
- No new package or state-management solution is introduced.
- Analyzer, formatter, focused tests, and repository checks pass.

## UX Rules for the Next Action

- Label the member form action `إضافة فرد` when the form is empty and ready for a new member.
- After the user enters member data, the action must communicate save behavior. Use an existing localized equivalent of `حفظ وإضافة الفرد` or `حفظ الفرد`; if no key exists, report that a new localization key is required instead of hardcoding text.
- When an existing member is selected for editing, use the existing localized equivalent of `حفظ التعديل`.
- Disable `التالي: البرنامج` while the family name is empty, `members.length < state.minMembers`, a member save is running, required initial data is loading, or the member form has unsaved changes.
- Enable `التالي: البرنامج` only when the family name is valid, the minimum member count is reached, no member save is running, and the form has no unsaved member changes.
- Derive this state from existing controllers and Bloc state. Do not add a second backend state source.
- After a successful member save, clear the form dirty state; the next button may then become active if the minimum count is satisfied.
- Preserve the current next route and family-name save behavior.

## Task 11: Audit feature structure and remove only proven-unused files

**Files:**
- Inspect: every file under `lib/features/family_subscription_setup/`
- Inspect: route registrations, dependency injection, imports, exports, tests, and cross-feature references.
- Modify/delete only files proven to be unused and not shared by another feature.

- [ ] Build an inventory grouped by `data`, `domain`, `presentation/manager`, `presentation/screens`, `presentation/widgets`, and `presentation/models`.
- [ ] For every file, search the repository for imports, constructor calls, route references, DI registrations, event dispatches, and public symbol references with `rg`. Search both the file path and each public class name.
- [ ] Mark a file removable only when it has no live reference from application code, route configuration, DI, tests, generated code, or another feature.
- [ ] Trace overlapping widgets, especially the member form/card/row/dialog variants, before consolidating or deleting anything.
- [ ] Check `family_address_options.dart` and `family_member_form_validation.dart` for indirect usage through exports or helper methods.
- [ ] Check `family_setup_member_tile.dart`, `family_setup_members_section.dart`, and `family_setup_members_row.dart` across all family routes before changing them.
- [ ] Do not delete a file only because it is not imported by `family_subscription_setup_screen.dart`; it may serve another route or flow.
- [ ] If a file is unused, remove stale imports and DI registrations in the same task, then run analyzer.
- [ ] If overlapping widgets are both used, keep them and document their ownership instead of deleting one.
- [ ] Record kept files, deleted files, the reason for each deletion, and repository search evidence in the final implementation summary.

**Exit condition:** The feature has no proven-unused source files, duplicate active registrations, or stale imports. Every deletion is backed by repository-wide reference checks and analyzer output.

## Stop Conditions

- Stop and report if an extracted widget requires a missing localization key, theme color, style, spacing token, asset field, or responsive breakpoint.
- Stop and report if existing local modifications conflict with the intended edit; do not overwrite them.
- Stop and report if the current family flow uses a different active widget path than the one traced above.
- Stop and report if a test or analyzer failure is caused by a pre-existing unrelated modification rather than this refactor.

