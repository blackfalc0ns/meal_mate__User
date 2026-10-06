# Subscription Upgrade Refactor — Gemini Implementation Plan

> **For agentic workers:** Use `superpowers:executing-plans`, if available, to execute task by task. Track the checkboxes below. This is a handoff to Gemini; implement only this scope. Do not start by rewriting the feature.

**Goal:** Extract the existing restaurant tier upgrade flow into `lib/features/subscription_upgrade`, reduce unnecessary rebuilds and asynchronous work, and use the existing `flutter_animate: ^4.5.2` dependency while preserving design and business behavior.

**Architecture:** Preserve Feature-Based Clean Architecture, Cubit/ViewModel + Event + State, GetIt/Injectable, Retrofit, existing `ApiResult` and repository contracts. Keep the three screen lifecycles independent as they currently are. Reuse existing visual sections and add focused reactive boundaries where evidence supports them.

**Tech stack:** Flutter/Dart, flutter_bloc, injectable/build_runner, webview_flutter, flutter_animate already declared in pubspec.yaml.

**Spec:** The approved user requirements are reproduced below; this document is the execution specification and plan. Only the upgrade portion is to be extracted; family management and family calendar stay in place.

## 1. Mandatory instructions from the user

**حافظ على التصميم الحالي. ممنوع تغيير الشكل أو ترتيب العناصر أو المسافات أو الألوان أو الخطوط أو الأحجام أو النصوص أو الـnavigation من نفسك. لو تغيير التصميم ضروري، اشرح للمستخدم السبب والمكان والتأثير والبدائل، واستنى موافقته الصريحة قبل تنفيذ الجزء ده. باقي الشغل المستقل يكمل.**

**الشاشات الكبيرة تتقسم لسكاشن واضحة حسب المسؤولية، وكل custom Widget في ملف مستقل. الشاشة تجمع السكاشن، وكل سكشن مرتبط بالـState يسمع للبيانات اللي محتاجها بس. التقسيم يحافظ على نفس التصميم والسلوك.**

Adding restrained animation is authorized. Changing geometry, introducing a new visual effect that changes the design, replacing an indicator with a skeleton, changing error layouts, or redesigning payment interaction is not authorized. Animation duration is an implementation choice, not a Figma measurement; propose conservative values below and preserve the final rendered state exactly.

Read `AGENTS.md`, `rules/ui_rules.md`, and `rules/rules_backend.md` before implementation. The user supplied the name `rules/backend_rules.md`, but the actual backend rules file inspected in this repository is `rules/rules_backend.md`. Do not rename rules or create a duplicate.

Additional constraints:

- Do not extract `family_management` or `family_calendar` in this task.
- Do not rename existing public classes, route strings, events, or API endpoints merely because the folder changes.
- Do not add packages, upgrade dependencies, or introduce another state-management solution.
- Reuse existing theme, spacing, styles, localization, icons and widgets.
- Keep all currently supported locales and inherited RTL/LTR behavior.
- Do not move all similarly named files across the project. Use the manifest and inspect consumers.
- Do not claim zero rebuilds: Flutter may legitimately rebuild for theme, locale, constraints and lifecycle changes. Eliminate unrelated state-driven rebuilds and measure them.
- Do not claim performance gains from adding animation. Validate frame timing separately.
- Never edit generated files manually. Review generation diffs and avoid unrelated generator churn.
- At inspection time, `lib/features/addresses/presentation/widgets/current_address_card.dart` already had user modifications. Recheck git status and preserve all unrelated edits.
- This plan authorizes refactoring, not changing upgrade eligibility, prices, payment defaults, success navigation or error wording.

## 2. Evidence from the current implementation

Read these files again before editing; the user may have changed them since this plan was written.

| Current file | Verified concern | Required direction |
|---|---|---|
| `presentation/screens/restaurant_tier_upgrade_screen.dart` | A broad BlocBuilder builds loading/error/empty states and the entire selection Scaffold; `_selectionChildren` and `_buildOptionCard` assemble selection content | Keep the page shell stable; isolate options, per-card selection and continue action |
| `presentation/screens/restaurant_tier_upgrade_confirmation_screen.dart` | Broad BlocConsumer rebuilds the entire page; `toUiEntity` fallback is called inside builder; `_confirmationChildren` mixes static sections, payment selection and submitting state | Prepare fallback once outside build; compose existing sections with narrow listeners |
| `presentation/screens/restaurant_tier_upgrade_web_view_screen.dart` | Broad BlocConsumer includes PaymentRedirectWebView; local `_hasStartedVerification` guards redirect only, while retry dispatches verification directly | Limit rebuilding to processing/error dependencies and also protect verification in ViewModel |
| `presentation/manager/restaurant_tier_upgrade_view_model.dart` | Selection recalculates UI data; multiple async methods await without systematic lifecycle guards; polling loop delays and requests can continue after close | No-op equal selections; guard duplicate work and stale/closed completions; stop future polling work |
| `presentation/manager/restaurant_tier_upgrade_state.dart` | Plain immutable State with no equality implementation; nullable clearing uses explicit flags | Preserve clearing semantics; selectors must use values with intentional equality |
| `data/mapper/restaurant_tier_upgrade_mapper.dart` | DTO conversion and presentation conversion live in the same mapper, imported by screens and ViewModel | Keep DTO mapping in data; extract the UI-only conversion to presentation without altering values |
| `presentation/widgets/staggered_slide_item.dart` | Used by multiple family screens/widgets | Leave this file and family consumers unchanged; do not move it with upgrade |
| `lib/core/widget/payment_redirect_web_view.dart` | Already owns its WebViewController in initState | Preserve its state identity; rebuilding a parent does not by itself mean controller recreation |

Current caller: `lib/features/profile/presentation/widgets/profile_billing_plan_card.dart` opens the upgrade selection route with `RestaurantTierUpgradeArgs`. Current code receives a subscription ID, but family upgrade support is not established. Do not add a family entry point or claim backend support.

## 3. Move manifest and external references

For every path below, replace only the feature root:

`lib/features/subscription_settings/<relative-path>` → `lib/features/subscription_upgrade/<relative-path>`.

Move these files with names and public interfaces preserved:

```text
data/data_source/restaurant_tier_upgrade_remote_data_source.dart
data/data_source/restaurant_tier_upgrade_remote_data_source_impl.dart
data/mapper/restaurant_tier_upgrade_mapper.dart
data/repo/restaurant_tier_upgrade_repository_impl.dart
data/models/request/subscription_upgrade_request_dto.dart
data/models/response/subscription_upgrade_options_response_dto.dart
data/models/response/subscription_upgrade_request_response_dto.dart
data/models/response/subscription_upgrade_status_response_dto.dart
data/models/response/subscription_upgrade_summary_response_dto.dart
domain/entities/restaurant_tier_upgrade_args.dart
domain/entities/restaurant_tier_upgrade_entity.dart
domain/entities/subscription_upgrade_entity.dart
domain/repo/restaurant_tier_upgrade_repository.dart
domain/usecase/create_subscription_upgrade_request_usecase.dart
domain/usecase/get_subscription_upgrade_options_usecase.dart
domain/usecase/get_subscription_upgrade_summary_usecase.dart
domain/usecase/get_subscription_upgrade_status_usecase.dart
presentation/manager/restaurant_tier_upgrade_event.dart
presentation/manager/restaurant_tier_upgrade_state.dart
presentation/manager/restaurant_tier_upgrade_view_model.dart
presentation/screens/restaurant_tier_upgrade_screen.dart
presentation/screens/restaurant_tier_upgrade_confirmation_screen.dart
presentation/screens/restaurant_tier_upgrade_web_view_screen.dart
```

Move all existing `presentation/widgets/restaurant_tier_*.dart` inside subscription_settings after checking their consumers. These include the action panel, badge, comparison row, continue button, count badge, current subscription card, detail row, details section, feature chip, logo strip, option card, payment method logo/tile, payment section, preview, quick comparison section, section card, upgrade actions, hero card and summary section. If a family file consumes one of these upgrade widgets, update that import only; do not move its consumer. Do not create barrel exports or compatibility duplicates.

Inspect `part` directives and generation annotations before moving related generated companions. These DTOs must retain their current serialization behavior; extraction is not a serialization migration.

Allowed external modifications:

- `lib/config/routing/routing_generator.dart`: imports only unless a focused fix is required; keep route cases/arguments behavior.
- `lib/config/routing/app_routes.dart`: read-only; no route string changes planned.
- `lib/features/profile/presentation/widgets/profile_billing_plan_card.dart`: migrated argument import only.
- `lib/core/network/api_services.dart`: migrated upgrade DTO imports only; preserve family imports and endpoint signatures.
- `lib/core/di/di.config.dart`: regenerate Injectable references.
- Existing tests and any other verified consumers: upgrade import updates only.
- `lib/core/di/di.dart`: change only if generator configuration requires it; normal feature moves should not require a new setup.
- Shared WebView/theme/localization code: inspect/reuse; any necessary change requires a narrowly documented scope and regression validation. Missing design tokens or localization keys must be reported rather than invented.

## 4. Task 1 — Capture baseline and extract without behavior changes

- [ ] Read rules, inspect `git status --short`, and record pre-existing changes.
- [ ] Search all upgrade consumers in `lib` and `test`, including mapper methods and generated imports. Record any dependencies not in the manifest.
- [ ] Run the existing focused tests before moving files. Record baseline failures separately; do not silently repair unrelated failures.
- [ ] Capture the selection, confirmation and WebView states in supported directions before UI refactoring, when a runnable app/device is available. Record screenshot environment, selected tier, payment method, locale and viewport.
- [ ] Move files using literal paths within this workspace; update imports by a manifest-backed mapping, not global replacement of `subscription_settings`.
- [ ] Regenerate bindings with `dart run build_runner build --delete-conflicting-outputs`. Inspect generated output for unintended changes.
- [ ] Run the focused tests and analyzer. Review diff to prove that the first phase changes location/imports only.

PowerShell inspection commands:

```powershell
git status --short
rg --files lib/features/subscription_settings
rg -n 'restaurant_tier_upgrade|subscription_upgrade|RestaurantTierUpgrade' lib test
rg -n 'StaggeredSlideItem' lib
```

Deliverable: extracted feature works through existing profile routes; family behavior and files remain in their current feature.

## 5. Task 2 — Prepare presentation data outside build

**Files:** moved mapper, ViewModel, selection/confirmation screens; create `presentation/mapper/restaurant_tier_upgrade_ui_mapper.dart`.

- [ ] Inspect every method in the old mapper. Keep DTO→entity and request entity→DTO mapping in data.
- [ ] Transfer `toUiEntity` and UI-only tier badge/option helpers to `RestaurantTierUpgradeUiMapper` in the new presentation file. Search consumers before transferring helpers; DTO mapping must not depend on presentation.
- [ ] Preserve the existing arguments, return values, prices, strings and asset choices exactly; update mapper tests as necessary.
- [ ] Initialize fallback confirmation UI data in initialization, not in the Bloc builder. Keep the current fallback display behavior if args exist but summary has not loaded.
- [ ] Keep selected-target-dependent data separate from invariant current-subscription data. Do not feed an always-new whole `uiData` object to the current subscription card on each tier selection.
- [ ] In selection screen, inspect `_buildOptionCard`: prepare immutable per-option presentation values once per successful options load if it currently maps repeatedly. Store them in presentation state/view data, not DTOs.
- [ ] Use immutable lists or preserve unchanged list identity. Do not introduce a global cache; invalidate prepared data when its actual source changes.

Interfaces: repository/UseCase signatures remain unchanged; presentation mapper consumes the existing domain entities and returns the existing `RestaurantTierUpgradeEntity`. Keep DTOs out of screens, State and ViewModel.

## 6. Task 3 — Split selection and confirmation into sections

Reuse existing visual widgets. New files represent useful composition/reactive boundaries, not arbitrary chunks split by line count.

Proposed files under `presentation/widgets/`:

| File / class | Responsibility and dependencies |
|---|---|
| `restaurant_tier_selection_body.dart` / `RestaurantTierSelectionBody` | Same scroll layout, padding and order; compose existing current card and options section |
| `restaurant_tier_options_section.dart` / `RestaurantTierOptionsSection` | Existing heading/subtitle and options; observe options data, not submitting/payment state |
| `restaurant_tier_selectable_option.dart` / `RestaurantTierSelectableOption` | One existing option card; select whether this target tier is selected |
| `restaurant_tier_continue_section.dart` / `RestaurantTierContinueSection` | Current bottom action; observe selection/eligibility and read current args on tap |
| `restaurant_tier_confirmation_body.dart` / `RestaurantTierConfirmationBody` | Existing hero/comparison/summary/details/payment/actions composition |
| `restaurant_tier_payment_selection_section.dart` / `RestaurantTierPaymentSelectionSection` | Adapt existing payment section to only its necessary state |
| `restaurant_tier_submission_section.dart` / `RestaurantTierSubmissionSection` | Existing action labels and callbacks; observe submission state |
| `restaurant_tier_submission_overlay.dart` / `RestaurantTierSubmissionOverlay` | Existing submitting indicator/interaction blocking; observe submitting only |

If an existing widget already supplies a boundary, reuse it instead of adding the proposed wrapper. Explain final file choices in the handoff report.

- [ ] Reduce page-level builders to load/error/empty/ready branch dependencies. Separate BlocListener for effects from builders for visual content.
- [ ] Keep the ready Scaffold and scroll subtree stable across selection/payment/submitting transitions.
- [ ] Move `_selectionChildren` and `_confirmationChildren` composition into the corresponding body widgets; keep simple Row/Column/Padding directly composed where appropriate.
- [ ] Do not put multiple custom widget classes in one file. A StatefulWidget and its associated State remain a normal single component.
- [ ] Keep current theme, styles, spacing, assets, SafeArea, scroll physics, text, order and conditional sections.
- [ ] Do not add GlobalKeys or RepaintBoundary everywhere. Add paint boundaries only if profiling demonstrates a benefit.

Selector example for a card with immutable option input:

```dart
BlocSelector<RestaurantTierUpgradeViewModel, RestaurantTierUpgradeState, bool>(
  selector: (state) => state.selectedOption?.targetTier == option.targetTier,
  builder: (context, isSelected) {
    // Compose the existing RestaurantTierOptionCard with its existing API.
    // Pass the prepared option data and isSelected, preserving visuals.
    return buildExistingCard(context, option, isSelected);
  },
)
```

This snippet specifies the selector; `buildExistingCard` is explanatory, not a function to create. Implement the existing card constructor directly after reading its real signature. Never copy pseudocode into production.

For multiple dependencies, a Dart record provides value equality for primitive/reference-stable values:

```dart
selector: (state) => (
  methods: state.upgradeSummary?.paymentMethods,
  selectedId: state.selectedPaymentMethod?.id,
),
```

Do not select the entire State, create fresh lists in selectors, or return new wrapper objects without meaningful equality. Preserve theme/locale responsiveness; never cache context or localized widgets across locale changes.

Acceptance table:

| Trigger | Expected state-driven rebuild scope |
|---|---|
| Select a different tier | Previous/new selected cards, target-dependent summary if displayed, continue action |
| Select same tier | No emission and no API request |
| Select payment method | Payment selection and only sections actually dependent on that method |
| Select same payment method | No emission |
| Start/finish submission | Actions and existing overlay, not options/hero/details |
| Polling status changes | Processing/error display; WebView identity/controller remains stable |
| Theme/locale changes | All affected visual text/style updates correctly |

## 7. Task 4 — Preserve effects and protect async lifecycle

**Files:** moved ViewModel, State/Event only if needed, confirmation/WebView listeners, `test/restaurant_tier_upgrade_view_model_test.dart`.

- [ ] Add same-choice guards using stable tier identifiers and payment method IDs. Keep current unavailable-method checks.
- [ ] Guard duplicate submission at method entry before the first await. Confirm rapid taps issue one create request.
- [ ] Guard duplicate status verification in ViewModel; the WebView redirect flag alone does not cover retries.
- [ ] Check `isClosed` after every await and before emits, further requests and subscription-cache refreshes.
- [ ] Introduce operation generation tokens where overlapping load/summary requests can replace newer state. Invalidate tokens on close/reset/terminal failure as appropriate. Do not combine unrelated operations under one token if it cancels valid work.
- [ ] Preserve existing polling schedule/backoff and timeout behavior. On close or terminal failure, stop scheduling requests; complete/cancel pending waits without leaving unresolved Futures.
- [ ] Do not claim physical HTTP cancellation unless supported by the current API layer. Logical cancellation must ignore late results and prevent subsequent requests. Do not redesign Retrofit contracts just for this task.
- [ ] Stop obsolete polling when `MarkUpgradeFailedEvent` occurs so a later paid response cannot override the terminal result.
- [ ] Keep retry functional after status error: release in-flight guard on all exit paths. Reset must not leave verification permanently locked.
- [ ] Keep payment payload, callback URLs, pricing and immediate-payment path intact.
- [ ] Preserve cache refresh on paid success. Define/test what happens if close occurs while refresh is pending, without emitting after close.
- [ ] Audit confirmation listener branches separately: a changed submitFailure must not re-open an old payment URL. Trigger navigation on a new request result edge, errors on a new failure edge, success on a success transition. Keep current navigation destination.
- [ ] Preserve one owner closing each ViewModel. Do not switch injected factories into shared singletons or close another screen's instance.

Guard patterns to adapt inside the real methods:

```dart
if (isClosed || state.isSubmitting) return;
// Emit in-flight state synchronously before the request.
final result = await existingRequest();
if (isClosed || requestGeneration != _requestGeneration) return;
// Handle the existing ApiResult cases.
```

`existingRequest` and token names illustrate lifecycle ordering, not new APIs. Use the existing UseCase calls; declare any counters/guards explicitly and cover them with deterministic tests.

## 8. Task 5 — Introduce restrained flutter_animate motion

**Create:** `presentation/widgets/restaurant_tier_entry_animation.dart` / `RestaurantTierEntryAnimation`, only if multiple upgrade sections need the same policy.

- [ ] Inspect resolved `flutter_animate` version in pubspec.lock and local package API before coding; do not change `^4.5.2`.
- [ ] Start with one-shot opacity entrance on ready selection/confirmation sections. Suggested duration: 180–220 ms, no delay for interactive controls. If sequencing adds value, cap delays and total entrance time rather than staggering every list item.
- [ ] Prefer fade only to preserve geometry. Translation can be added only if existing design evidence supports it or the user approves it. No bounce, blur, shimmer, endless loop, animated height/width or whole-WebView animation.
- [ ] Do not add success/failure pages, indicators or transitions that alter existing navigation.
- [ ] Animation starts once per mounted ready content; selecting a tier/payment method or toggling submitting must not restart the entrance. Avoid changing keys by selection or replacing the ready subtree on unrelated state.
- [ ] Honor `MediaQuery.disableAnimationsOf(context)` and inherited accessibility settings. Return the original child when animations are disabled.
- [ ] Reuse the already declared library; leave family `StaggeredSlideItem` and its consumers untouched.
- [ ] Use no screen-level setState to drive animation frames. Let the library own lifecycle controllers; manually created controllers must be disposed.

Minimal permitted pattern, to confirm against the installed API:

```dart
if (MediaQuery.disableAnimationsOf(context)) return child;
return child.animate().fadeIn(duration: const Duration(milliseconds: 200));
```

Document mounted identity explicitly; `.animate()` alone does not guarantee once-per-route behavior if its widget is repeatedly unmounted. Keep loading/error transitions behaviorally unchanged and preserve hit testing during submission.

## 9. Task 6 — WebView stability and focused regression tests

Reuse `PaymentRedirectWebView`. Its controller is already created in initState; do not solve an unverified controller recreation issue by duplicating shared code.

- [ ] Limit the WebView screen builder to `statusFailure` and `isPollingStatus` dependencies, with terminal navigation in listener.
- [ ] Keep the WebView widget type/key/location stable while toggling processing. Existing transition to API error may still unmount it; changing that error design requires approval.
- [ ] Inspect shared callbacks for mounted/lifecycle behavior. If shared widget changes are necessary, explain the exact defect and add payment-flow regressions, including non-upgrade consumers.
- [ ] Extend the existing fake-repository style, using Completers and call counts, not new mocking dependencies or real payment requests.

Tests required for actual behavior changes:

| Test | Setup/action | Assertion |
|---|---|---|
| Duplicate submit | Hold create request with Completer; dispatch submit twice | One create call and correct paymentMethodId |
| Close during request | Hold load/create/status request; close ViewModel; complete it | No emit-after-close error, no new polling/cache work |
| Duplicate verify | Hold first status request; dispatch verify twice | One active polling sequence |
| Terminal failure during poll | Start pending verification, mark failed, complete paid result | Failure remains terminal; no success navigation/cache refresh |
| Retry after API error | First status returns error; retry returns paid | Retry succeeds and in-flight guard is released |
| Stale options completion | Request A held, then B completes, then A completes | State retains B |
| Same selection | Load data, reselect same tier/method | No extra state emission or request |
| Side-effect isolation | Existing payment URL followed by another failure emission | URL navigation happens once; failure is presented once |
| Reduced motion | Mount ready UI with disableAnimations true | Final layout visible immediately, no ongoing entrance frames |
| Rebuild boundaries | Select another tier/payment method with instrumentation | Unrelated current card/hero/details do not rebuild for that state change |

Use targeted test names inside the existing ViewModel/screen/payment tests. Create `test/restaurant_tier_upgrade_rebuild_test.dart` or `test/restaurant_tier_upgrade_animation_test.dart` only when existing tests cannot cleanly host these checks. Count builds with test instrumentation that does not become a production logging API. Use fake clocks/test-controlled async completion where possible; do not make tests wait for the production polling minute.

Preserve these existing tests:

```text
test/restaurant_tier_upgrade_view_model_test.dart
test/restaurant_tier_upgrade_screen_test.dart
test/restaurant_tier_upgrade_mapper_test.dart
test/restaurant_tier_upgrade_summary_mapper_test.dart
test/restaurant_tier_payment_section_test.dart
```

## 10. Task 7 — Verify, measure, and deliver

- [ ] Format changed Dart files only. Do not format unrelated feature files.
- [ ] Run focused tests, then flutter analyze. Classify baseline versus introduced failures.
- [ ] Inspect all old-path matches: upgrade paths must disappear, valid family subscription_settings paths must remain.
- [ ] Inspect git diff to ensure no user changes were overwritten, no family files moved, no endpoint/route/payload changed and no generated files hand-edited.
- [ ] Compare ready-state screenshots with baseline at identical locale/device/data after entrance settles. Validate no layout shift, new overflow or changed colors/typography.
- [ ] In Flutter DevTools, count builds for tier selection, payment selection and submitting transitions. Record actual counts and the specific unchanged sections.
- [ ] Profile animation/scroll on the same physical device, same refresh rate, same data and Profile mode before/after. Report build/raster frame timing and janky frames; do not use debug-mode FPS as evidence.
- [ ] If device/DevTools/Figma is unavailable, explicitly report the unverified part. Do not assert pixel-perfect rendering or measured performance improvement.
- [ ] Deliver changed-file summary, final section boundaries, tests/commands/results, performance evidence and remaining limitations.

Commands from repository root:

```powershell
flutter test test/restaurant_tier_upgrade_view_model_test.dart test/restaurant_tier_upgrade_screen_test.dart test/restaurant_tier_upgrade_mapper_test.dart test/restaurant_tier_upgrade_summary_mapper_test.dart test/restaurant_tier_payment_section_test.dart
flutter analyze
rg -n 'features/subscription_settings/(data/.+subscription_upgrade|domain/.+subscription_upgrade|.+restaurant_tier)' lib test
git diff --stat
git diff --check
git status --short
```

Run newly added test files too. Broaden testing to shared payment consumers only if shared files change or a failure reveals a related risk. Do not make commits, publish, or merge unless separately requested.

## 11. Final completion criteria

- [ ] Upgrade lives in subscription_upgrade with valid DI/routing/network references.
- [ ] Family management/calendar and their shared animation remain in place.
- [ ] Large screens compose focused sections with one custom widget per file.
- [ ] Unrelated state changes do not rebuild the whole ready page.
- [ ] No repeated submission/verification, stale state overwrite or post-close emission from changed code.
- [ ] flutter_animate is used conservatively, respects reduced motion and does not replay on selection/submission updates.
- [ ] Original design and navigation are preserved; any necessary design change received explicit prior user approval.
- [ ] Regression checks pass or blockers are precisely reported, with no invented performance claims.

Suggested Gemini execution prompt:

> اقرأ الخطة كاملة وقواعد المشروع، ثم نفّذ فصل `subscription_upgrade` فقط على مراحل. حافظ على التصميم والسلوك الحاليين، وقسّم الشاشات الكبيرة لسكاشن بحدود rebuild واضحة، وحسّن async lifecycle، واستخدم `flutter_animate` الموجود بحركات خفيفة. أي تغيير ضروري في التصميم اشرح سببه وتأثيره واسألني قبل تنفيذه. لا تغيّر ملفات العائلة أو شغل غير متعلق بالمهمة. اختبر كل مرحلة، وميّز النتائج المقاسة عن الأجزاء التي لم تتمكن من التحقق منها.
