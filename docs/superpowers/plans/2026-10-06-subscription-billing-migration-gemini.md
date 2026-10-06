# Subscription Billing Migration, Freeze Consent, and UI Refactor — Gemini Implementation Plan

> **For agentic workers:** Use `superpowers:executing-plans` if available. Execute task by task and track checkboxes. This is an implementation handoff to Gemini; inspect the latest checkout before editing.

**Goal:** Move the individual subscription/billing screen and its owned presentation, domain, and data code from `profile` into the existing `subscription_settings` feature, improve its visual fidelity and rebuild isolation, and require a freeze-information sheet before continuing a new freeze.

**Architecture:** Preserve feature-based Clean Architecture: Screen → Event → ViewModel → UseCase → Repository → DataSource → existing ApiServices; DTO → Mapper → Entity on return. Extract billing responsibilities from the mixed profile classes rather than moving the entire profile feature. `subscription_settings` already exists; do not create a second subscription-management architecture.

**Tech Stack:** Flutter, flutter_bloc, Injectable/GetIt, Dio/Retrofit, json_serializable/build_runner, existing Wolt wrapper, `flutter_animate: ^4.5.2` (already declared in pubspec).

**Spec:** The approved requirements and evidence below are the self-contained design specification for this handoff. The user authorized writing this plan; implementation is for the receiving agent. Do not execute the separate address-coverage plan.

## Global constraints

- Read `AGENTS.md`, `rules/ui_rules.md`, and `rules/rules_backend.md`. The supplied instructions name `rules/backend_rules.md`, but that path was absent in the inspected checkout; `rules/rules_backend.md` is the existing backend rule file.
- Preserve existing working-tree changes. Re-read `git status --short` before starting: the checkout has had ongoing subscription-upgrade/localization work. Do not reset, stash, overwrite, or broadly format unrelated files.
- Scope includes this individual billing screen, owned widgets, owned data/domain/state, route consumers, DI, necessary generated bindings, and focused tests. Existing family screens/logic are outside scope.
- Core `ApiServices`, network configuration, error handling, language interceptor, `AppWoltModalSheet`, theme, and reusable widgets remain shared. Update affected imports/types; do not create another Dio/client.
- Keep server endpoint paths, JSON keys, permissions, and action semantics unchanged unless explicitly specified below. Renaming a Dart model must not rename a JSON field.
- Every custom widget gets its own file; the screen composes sections and delegates effects. Use existing colors, typography, spacing, assets, localization, and Directionality. Do not hardcode user-facing app copy. Server-supplied localized notice text is data and should be displayed as returned.
- Regenerate generated source through build_runner; never hand-edit `.g.dart` or DI output. Inspect generated collateral changes.
- No commit, push, deployment, live mutation, new package, or unrelated refactor. The requested animation dependency already exists.

## 1. Verified evidence and intended behavior

### Current implementation

- `lib/features/profile/presentation/screens/profile_billing_screen.dart` owns a `ProfileViewModel`, starts `GetProfileBillingEvent` in provider creation, and uses a broad `BlocConsumer` whose builder depends on billing data and action loading.
- The same screen contains dialogs, freeze date selection, cancellation/resume effects, and a private `_BillingReasonInputField` widget. Extract this private widget into its own file.
- `_confirmFreeze` checks active/pending freeze, then immediately opens the date-range picker. Policy information currently appears later, in final confirmation. The requested first consent sheet is missing.
- `ProfileRepositoryImpl.getProfileBilling()` concurrently aggregates five reads: current subscription, uncompleted subscriptions, invoices, default payment method, and freeze policy. Preserve this aggregation/error behavior during migration; do not quietly replace it with five independent UI requests.
- Billing methods share `ProfileRepository`, `ProfileRemoteDataSource`, and `ProfileViewModel` with profile editing/upload. Split responsibilities; preserve actual profile operations.
- A separate `ProfileUncompletedSubscriptionRepository`/implementation owns unfinished subscription actions and must move with this flow.
- `ProfileBillingActionsResponseDto` and `ProfileBillingActionsEntity` currently omit `freezeNotice` and `freezeNoticeAr`. Add nullable fields and mapping; the attached current-subscription response supplies these keys.
- `GetCurrentCustomerSubscriptionUseCase` is consumed outside profile, including calendar and payment. Its move requires updating all consumers, not keeping two competing implementations.
- Existing route generator imports `ProfileBillingScreen` and constructs it around line 547. Preserve the existing public route value to keep entry points compatible.

### Design evidence

Figma: https://www.figma.com/design/OSfVgAwRxYbu8lJmpXOPXC/MealMate-Mobile-APP?node-id=1836-15656&m=dev

The inspected node `1836:15656` is a RECTANGLE, not an entire screen. Verified properties: pale green linear gradient (`#EEF6E7` to `#E3F1D8`), near-white stroke `#FDFEFD`, stroke width about 2.119, radius about 27.547, opacity about 0.6, and shadow `(0, 7.801, 7.801, rgba(76,76,76,0.07))`. These are Figma measurements, not permission to insert literal colors into Flutter widgets. Inspect its parent/frame and scaling before choosing final tokens. Do not apply the rectangle's opacity to all card content or guess full-screen geometry from this node.

The user screenshot shows: subscription summary at top, image beside localized bundle/tier/status, renewal date and remaining service days, progress, four action tiles, invoice card/empty illustration, orange freeze information banner, and green management CTA. Treat screenshot values as sample API data, never hardcoded content. Purple floating debug controls are not part of the target product UI.

### Freeze flow specification

For a NEW freeze:

1. Check eligibility and active/pending freeze using existing behavior.
2. Immediately show a scrollable information sheet with `AppWoltModalSheet.show<bool>`.
3. Display full server notice from current subscription actions, with existing freeze-policy rules where available. Actions: localized Agree/Continue and Cancel.
4. Continue only when result is explicitly `true`. Back, close icon, swipe, barrier tap, Cancel, and null result all stop the flow; no picker and no freeze POST.
5. After agreement, open the existing date picker, validate the range, collect optional reason and final confirmation, then issue the existing freeze request.
6. Preserve the separate `freeze.confirm_overwrite_selections` consent. Agreement to general policy must NOT automatically set `acknowledgeLostSelections: true`.
7. Existing active/pending freeze taps open their existing details flows, without masquerading as a new freeze or resubmitting it.

The supplied log is fragmented. Confirmed keys include `freezeNotice`, `freezeNoticeAr`, `freezeStartDelayDays`, `maximumFreezeDays`, `freezeExtendsSubscriptionEnd`, `earliestFreezeStartDate`, and `freezeDetailsEndpoint`. The readable notice says freezing activates automatically, extends expiry without waiting for administration approval, already confirmed kitchen-window deliveries remain, delivery pauses and resumes, and previously selected meals in the frozen range are cancelled with replacement days at the subscription end. Do not reconstruct a truncated prefix and claim it is verbatim backend copy.

Treat server dates/limits as authoritative; example delay 3, maximum 7, and date 2026-10-30 are fixture examples, not fixed rules. Do not create a new endpoint or make a freeze-details fetch mandatory merely to obtain a notice already present in current-subscription actions.

## Task 1 — Baseline and ownership inventory

**Files:** Read existing profile/subscription_settings/core code and billing tests; no implementation edits in this task.

- [ ] Record status and baseline analysis; inspect current rules completely.
- [ ] Search all billing/current-subscription consumers, including profile, calendar, payment, subscription upgrade, route generator, ApiServices, and tests.
- [ ] Record which files are wholly billing-owned and which require method extraction. Inspect image upload/profile editing dependencies before changing constructor injection.
- [ ] Run existing billing tests and distinguish pre-existing failures from this change.

```powershell
git status --short
rg -n 'ProfileBilling|ProfileUncompleted|GetCurrentCustomerSubscriptionUseCase|GetProfileBillingEvent|profileBilling' lib test
rg --files test | rg 'profile_billing|profile.*view_model|subscription.*billing'
flutter test test/profile_billing_plan_card_test.dart test/profile_billing_freeze_response_test.dart test/profile_billing_freeze_policy_and_calendar_test.dart test/profile_billing_freeze_details_endpoint_test.dart test/profile_billing_empty_state_test.dart test/profile_billing_active_freeze_card_test.dart test/features/profile/domain/profile_billing_freeze_policy_test.dart test/features/profile/data/mapper/profile_billing_mapper_test.dart test/features/profile/data/mapper/profile_billing_uncompleted_mapper_test.dart
flutter analyze
```

Deliverable: current dependency map and baseline, not an assumption that file prefixes prove ownership.

## Task 2 — Move data/domain ownership and split shared classes

**Target files:**

| Source | Destination/action |
| --- | --- |
| `profile/data/models/response/profile_billing_response_dto.dart` | `subscription_settings/data/models/response/subscription_billing_response_dto.dart` |
| `profile/data/models/request/profile_billing_action_request_dto.dart` | `subscription_settings/data/models/request/subscription_billing_action_request_dto.dart` |
| `profile/data/mapper/profile_billing_mapper.dart` | `subscription_settings/data/mapper/subscription_billing_mapper.dart` |
| `profile/domain/entities/profile_billing_entity.dart` | `subscription_settings/domain/entities/subscription_billing_entity.dart` |
| Billing methods in profile datasource pair | Extract `subscription_settings/data/data_source/subscription_billing_remote_data_source.dart` and `_impl.dart` |
| Billing methods in profile repository pair | Extract `subscription_settings/domain/repo/subscription_billing_repository.dart` and `data/repo/subscription_billing_repository_impl.dart` |
| ProfileUncompletedSubscription repository pair | Move to `subscription_settings`, rename prefix to `SubscriptionUncompletedSubscription` |

All table paths are relative to `lib/features/`. Rename owned `ProfileBilling*` classes to `SubscriptionBilling*`, preserving shape and existing mapper behavior.

- [ ] Move these usecases to `subscription_settings/domain/usecase/`: `get_current_customer_subscription_usecase.dart`, `get_subscription_freeze_details_usecase.dart`, `create_subscription_renewal_request_usecase.dart`, `create_subscription_freeze_request_usecase.dart`, `get_subscription_cancellation_quote_usecase.dart`, `create_subscription_cancellation_request_usecase.dart`, `delete_uncompleted_subscription_usecase.dart`, `get_subscription_resume_preview_usecase.dart`, and `resume_subscription_usecase.dart`.
- [ ] Move/rename `get_profile_billing_usecase.dart` to `get_subscription_billing_usecase.dart` with `GetSubscriptionBillingUseCase`.
- [ ] Preserve method signatures/return types apart from systematic entity prefixes. In particular, aggregate entry point becomes `Future<ApiResult<SubscriptionBillingEntity>> getSubscriptionBilling()`; `GetSubscriptionBillingUseCase.call()` returns that type. Keep current-subscription usecase class name and caller signature to minimize collateral changes.
- [ ] Extract implementations without changing requests, parallel aggregation, safeApiCall, empty-state behavior, error codes, freeze-date policy, or currency/date mapping.
- [ ] Update all external imports/types and fake repositories to new owners. Core ApiServices continues exposing the same endpoints using moved DTOs.
- [ ] Remove moved methods and dependencies from profile contracts only after their consumers point at new owners. Keep customer profile/edit/image/upload functionality intact. Do not retain duplicate billing code or forwarding implementations merely to hide incomplete migration.
- [ ] Update serialization `part` filenames and Injectable registration annotations, then regenerate.

```powershell
dart run build_runner build --delete-conflicting-outputs
rg -n 'features/profile/.+(profile_billing|profile_uncompleted|get_current_customer_subscription|subscription_freeze|subscription_cancellation|subscription_resume|resume_subscription|subscription_renewal)' lib test
```

Expected: no imports of moved implementations; any remaining profile references must be actual profile concerns. Run baseline suites with updated imports and confirm calendar/payment consumer compilation. Preserve family-owned repositories and screens.

## Task 3 — Dedicated billing state and screen/widget migration

**Create:** `subscription_settings/presentation/manager/subscription_billing_view_model.dart`, `subscription_billing_event.dart`, `subscription_billing_state.dart`.

**Move:** `profile/presentation/screens/profile_billing_screen.dart` → `subscription_settings/presentation/screens/subscription_billing_screen.dart`; class `SubscriptionBillingScreen`.

- [ ] Extract billing events, billing data/action state, and billing methods from ProfileViewModel. Preserve renewal, freeze, cancellation quote/request, delete unfinished, resume preview/request, reset action, and existing post-success refresh/payment navigation semantics.
- [ ] Name the initial load event `GetSubscriptionBillingEvent`; use it once in provider creation. Keep moved action event names where already descriptive (`FreezeSubscriptionEvent`, etc.). Dedicated state exposes `billing` and `billingAction`; moved action state is `SubscriptionBillingActionState`.
- [ ] Use one lifecycle-owned billing ViewModel per screen; no global singleton for route-local loading/effects. Guard duplicate in-flight loads/actions and suppress emissions after disposal. Do not add new cancellation/version systems unless needed for a demonstrated race.
- [ ] Move every owned `profile_billing_*.dart` widget to `subscription_settings/presentation/widgets/subscription_billing_*.dart`, rename classes consistently, and update tests. This includes action, plan, payment, invoice history/empty invoices, empty subscription, loading skeleton, unfinished subscription, freeze rules/date column, pending freeze, and active freeze widgets. Search full inventory; do not overlook transitively imported widgets.
- [ ] Extract `_BillingReasonInputField` to `subscription_billing_reason_input_field.dart`; preserve controller init/dispose and input contents.
- [ ] Extract effect/dialog orchestration into `subscription_billing_effects.dart` and `subscription_billing_action_coordinator.dart` under presentation. Coordinator accepts current entities and callbacks; it never directly invokes Dio/repositories.
- [ ] Update `lib/config/routing/routing_generator.dart` to construct `SubscriptionBillingScreen`. Keep route identifiers/values and navigation arguments compatible so profile and drawer entry points still work.
- [ ] Remove billing fields/events/constructor dependencies from ProfileViewModel/State/Event after extraction; update profile tests/DI. Verify profile still loads/edits independently.

Deliverable: no subscription billing data or action implementation owned by profile; working screen with preserved behavior before visual refinements.

## Task 4 — Server notice parsing and mandatory first consent sheet

**Modify:** moved response DTO, domain actions entity, mapper, coordinator.
**Create:** `subscription_settings/presentation/widgets/subscription_freeze_notice_sheet.dart`.
**Tests:** `test/subscription_billing_freeze_notice_contract_test.dart`, `test/subscription_billing_freeze_consent_flow_test.dart`.

- [ ] Add optional `String? freezeNotice`, `String? freezeNoticeAr` to actions DTO and entity constructors; forward them through mapper without replacing them with invented statements. Null/empty/whitespace is ordinary absence.
- [ ] Write regression parsing tests before implementing these fields. Example after migration:

```dart
test('current subscription preserves server freeze notices', () {
  final entity = SubscriptionBillingCurrentResponseDto.fromJson({
    'subscription': {
      'subscriptionId': 'subscription-fixture',
      'actions': {
        'canFreeze': true,
        'freezeNotice': 'Server localized freeze policy',
        'freezeNoticeAr': 'سياسة التجميد من الخادم',
        'maximumFreezeDays': 7,
      },
    },
  }).toEntity();
  expect(entity.subscription!.actions.freezeNotice,
      'Server localized freeze policy');
  expect(entity.subscription!.actions.freezeNoticeAr,
      'سياسة التجميد من الخادم');
});
```

- [ ] Resolve message using nonempty server-localized `freezeNotice` first (existing Accept-Language lifecycle), then a locale-matching legacy field/policy message. Do not use RTL as a proxy for Arabic language. If no actual notice is available, present available policy rules plus existing localized explanation; if neither supplies meaningful information, show a localized unavailable/retry state and do not silently bypass required consent. Do not invent a freezeNoticeEn API key without evidence.
- [ ] Pass the selected notice as a plain String into the sheet. Body supports long text and larger text scale; buttons remain reachable. Reuse AppButton and existing semantic styling.
- [ ] Use the existing wrapper; core wrapper remains unchanged. Interface:

```dart
Future<bool> requestFreezeConsent(BuildContext context, String notice) async {
  final accepted = await AppWoltModalSheet.show<bool>(
    context: context,
    title: context.localization.billing_freeze_confirm_title,
    child: SubscriptionFreezeNoticeSheet(notice: notice),
  );
  return accepted == true;
}
```

`SubscriptionFreezeNoticeSheet({required String notice})` owns localized Continue/Cancel buttons; each calls `Navigator.of(context).pop(true/false)` using the sheet's context. Use `stickyActionBar` if consistent with existing wrapper usage; ensure its dismissal targets the sheet route. Add localization keys to all configured locales only when existing keys do not express the needed meaning.

- [ ] Introduce a presentation-only `isFreezeFlowOpen` guard covering sheet, date picker, and final confirmation. Reset in `finally`; rapid taps produce exactly one flow. After each await check mounted and current subscription/eligibility before continuing.
- [ ] Insert consent after active/pending handling and before `showAppDateRangePicker`. No loading mutation state, freeze POST, or picker before agreement. Agreement alone performs no mutation.
- [ ] Preserve date policy minimum, inclusive maximum-days validation, API yyyy-MM-dd formatting, optional reason, and final confirmation. Preserve overwrite-selection error/retry with explicit separate agreement.
- [ ] Test: notice visible first; Cancel/back/barrier/drag stops; Agree opens picker only; cancelled picker/final confirmation produces zero POST; valid final confirmation produces one POST; repeated taps one sheet; unavailable action blocked; active/pending taps show details; overwrite acknowledgement remains false until separately accepted; AR/EN/null/whitespace notice; disposal while modal awaits.

Run the two new suites plus existing freeze response/policy/details tests. Do not test against a real paid subscription by issuing live freezes.

## Task 5 — Rebuild isolation with measurable checks

**Files:** moved screen, effects, section widgets, dedicated state/ViewModel.
**Test:** `test/subscription_billing_rebuild_isolation_test.dart`.

- [ ] Keep `BlocListener` for one-time effects separate from rendering. Effects must be consumed/reset so an unrelated state update cannot reopen a dialog, navigate twice, or repeat a snackbar.
- [ ] Use a page-level selector only for initial load/error/data availability. Split existing content into stable section boundaries: summary/action row, invoices, payment, unfinished subscriptions, freeze status/rules, management CTA.
- [ ] Section selectors select only needed immutable entity/record fields; avoid allocating fresh Lists/maps in selectors. Action-loading selector should live around relevant buttons, not rebuild invoice illustrations/text or the whole scroll view.
- [ ] Preserve widget keys/positions and scroll position during action transitions. Use const where applicable. Do not add RepaintBoundary everywhere; rebuild and repaint are different concerns.
- [ ] Use a fake repository and instrumented test section builder to measure billingAction loading/success/failure emissions. Assert unchanged invoice/payment bodies do not rebuild; relevant action controls do update. Confirm repeated pumps/unrelated profile updates produce no extra aggregate fetches.
- [ ] Record before/after Flutter DevTools rebuild evidence in a focused manual run; do not promise zero rebuilds (locale/theme/data changes legitimately rebuild).

Acceptance: no requests in build/selectors; one initial aggregate load; no duplicate mutation; unchanged sections isolated from action-only updates; all actual data updates remain visible.

## Task 6 — Visual fidelity and one-time entrance motion

**Files:** moved billing widgets; add `subscription_billing_entrance.dart` if needed; existing theme/localization only for verified missing tokens.

- [ ] Inspect Figma parent/frame, screenshot, current theme/assets, and actual plan card before adjusting geometry. Record measured properties and token choices. If parent access fails, report limitation and use screenshot composition plus verified rectangle properties; do not claim pixel-perfect full-frame verification.
- [ ] Refine summary card hierarchy: bundle, tier, status badge, image, renewal line, remaining days, progress, and four balanced tiles. Keep server canRenew/canFreeze/canCancel/canUpgrade and reasons controlling availability. Preserve existing upgrade route and CTA behavior.
- [ ] Refine invoice empty/list card, its illustration and hierarchy, warning banner, and management CTA. Preserve nonempty invoices, payment methods, unfinished subscriptions, active/pending freeze cases even if absent from screenshot.
- [ ] Use theme semantic colors. If pale gradient/stroke/shadow require missing semantic tokens, add the smallest theme extension consistently across configured themes using verified Figma evidence; do not scatter color literals through widgets. Resolve Figma component scaling before adding exact spacing/radius values.
- [ ] Support inherited LTR/RTL, 320px-width devices and larger text. Do not clip long bundle names or policy copy. No reliance on sample dates, status, prices, or API IDs.
- [ ] Use the existing flutter_animate dependency for fade plus small vertical translation, about 240–320ms and 40–60ms section stagger. These timings are proposed implementation choices, not extracted Figma animation.
- [ ] Keep section entrance state stable for the route lifetime. Animate a section only on its first content appearance; preserve a played-section registry above transient loading/content branches so refreshed/replaced content does not replay. Do not give animation wrappers changing UniqueKeys. No repeating animations or API callbacks from animation hooks.
- [ ] Honor `MediaQuery.disableAnimationsOf(context)`: render final visible state immediately. Never couple consent eligibility to animation completion. Reuse Wolt's built-in modal transition; no second competing modal animation.

Implementation pattern for a stable entrance widget (track completion/first mount in its State; do not put this boolean in API state):

```dart
Widget entrance(BuildContext context, Widget child, bool alreadyPlayed) {
  if (MediaQuery.disableAnimationsOf(context) || alreadyPlayed) return child;
  return child.animate()
      .fadeIn(duration: 280.ms, curve: Curves.easeOut)
      .slideY(begin: 0.025, end: 0, duration: 280.ms,
          curve: Curves.easeOut);
}
```

This is an effect pattern, not a complete lifecycle implementation. The route/section must mark entrance as played and retain that fact across refreshes; mounted animation state itself should not be recreated on action emissions. Verify using bounded test pumps; avoid pumpAndSettle on indefinitely animated skeletons.

Reference: [flutter_animate 4.5.2 package documentation](https://pub.dev/packages/flutter_animate/versions/4.5.2).

Deliverable: screenshots in Arabic/English for representative loading, content, empty invoices, no subscription, active freeze, and consent states; motion only on first appearance, with reduced-motion behavior verified.

## Task 7 — Final verification and handoff

- [ ] Add route/DI smoke coverage: old public entry point opens new screen; billing ViewModel resolves; profile editing still resolves; moved current-subscription usecase resolves in calendar/payment consumers.
- [ ] Run migrated existing billing suites and new notice/flow/isolation tests. Preserve old test filenames if renaming adds unnecessary noise; imports and test target classes must point to new owners.
- [ ] Inspect every stale profile-billing import/class reference and classify exceptions. No owned billing implementation remains in profile. Localization keys/public route names may retain historical `profile_billing` naming for compatibility.
- [ ] Regenerate only necessary output, format explicit changed Dart paths, analyze, and compare final status with baseline.

```powershell
flutter test test/profile_billing_plan_card_test.dart test/profile_billing_freeze_response_test.dart test/profile_billing_freeze_policy_and_calendar_test.dart test/profile_billing_freeze_details_endpoint_test.dart test/profile_billing_empty_state_test.dart test/profile_billing_active_freeze_card_test.dart test/features/profile/domain/profile_billing_freeze_policy_test.dart test/features/profile/data/mapper/profile_billing_mapper_test.dart test/features/profile/data/mapper/profile_billing_uncompleted_mapper_test.dart test/subscription_billing_freeze_notice_contract_test.dart test/subscription_billing_freeze_consent_flow_test.dart test/subscription_billing_rebuild_isolation_test.dart
flutter analyze
git diff --check
git status --short
rg -n 'ProfileBillingScreen|features/profile/.+profile_billing|ProfileUncompletedSubscription' lib test
```

- [ ] Manually verify navigation, scroll preservation, real enabled/disabled actions, repeated taps, first consent, cancellation at each step, valid date flow, overwrite consent, final success refresh, pending/active freeze, invoices, and resume/payment flow. Confirm no extra calendar request was introduced by this screen refactor.
- [ ] Report moved files, extracted classes, shared consumers updated, tests/results, baseline issues, Figma access limits, screenshots, rebuild measurements, and any unfinished requirement. Distinguish mocks from live read verification.

## Acceptance checklist

- [ ] Screen and all owned widgets are under `subscription_settings/presentation`.
- [ ] Billing DTO/mapper/entity/data-source/repository/usecases and unfinished subscription logic are owned by `subscription_settings`; core networking stays shared.
- [ ] ProfileViewModel/State/Event no longer own billing; profile editing/upload remains functional.
- [ ] Routes/DI/calendar/payment/upgrade consumers compile and preserve navigation behavior.
- [ ] Freeze notice fields survive DTO → mapper → entity and are displayed in AppWoltModalSheet before date selection for new freezes.
- [ ] Only explicit first agreement continues; dismissals produce no picker or mutation; final confirmation and overwrite consent remain separate.
- [ ] Action-only updates do not rebuild unchanged invoice/payment content or replay entrance animations.
- [ ] Existing flutter_animate ^4.5.2 is used; reduced motion works; no redundant dependency changes.
- [ ] UI follows verified design evidence, existing tokens, configured locales, and accessibility needs.
- [ ] Tests/checks have recorded results; no unrelated source changes or live subscription mutations.

## Prompt to give Gemini

> اقرأ `docs/superpowers/plans/2026-10-06-subscription-billing-migration-gemini.md` كاملة وقواعد المشروع، ثم نفذها خطوة بخطوة. انقل شاشة الاشتراكات والفواتير وكل الويدجت والداتا والدومين والمنطق الخاص بيها من profile إلى subscription_settings، وافصلها عن ProfileViewModel من غير ما تكسر البروفايل أو مستهلكي الاشتراك الحالي في التقويم والدفع. حافظ على routes وعقد API وسلوك الإجراءات الحالي. زر التجميد الجديد لازم يعرض نص السيرفر وشروط التجميد أولًا باستخدام AppWoltModalSheet، والموافقة فقط تفتح اختيار التواريخ؛ الإغلاق أو الرفض لا ينفذ أي تجميد. ضيف freezeNotice وfreezeNoticeAr للموديل والمابّر، وحافظ على موافقة فقد اختيارات الوجبات كخطوة مستقلة. حسّن التصميم وفق Figma والصورة، وقلل rebuilds بقياسات واختبارات فعلية. flutter_animate ^4.5.2 موجودة بالفعل؛ استخدمها لظهور خفيف مرة واحدة مع احترام تقليل الحركة. لا تعدل شغل subscription_upgrade الموجود أو العائلة أو خطة التغطية، ولا تعمل commit أو live mutations. سلّم نتائج الاختبارات والتحليل والصور وحدود التحقق بوضوح.
