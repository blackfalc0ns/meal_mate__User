# Payzah Migration and Payment Security Implementation Plan

> **For Gemini / agentic workers:** Implement task-by-task using the executing-plans workflow. Track the checkboxes. This is an implementation handoff, not permission to perform purchases, refunds, deployment, or database migrations.

**Goal:** Replace active legacy-gateway behavior with Payzah hosted checkout in every mobile payment flow, remove obsolete integrations, and prevent redirects or stale attempts from being treated as successful fulfillment.

**Architecture:** Preserve the existing Flutter feature-based architecture: ApiServices → RemoteDataSource → Repository → UseCase → ViewModel/Event/State → UI, and DTO → Mapper → Entity. Keep shared URL parsing and redirect handling in core; application payment decisions stay in feature ViewModels and authenticated backend status APIs.

**Tech Stack:** Flutter/Dart, flutter_bloc, Dio/Retrofit, GetIt/Injectable, json_serializable, webview_flutter, existing localization and test infrastructure. No new package is required by this plan.

**Spec:** The user-supplied “Payzah mobile payment contract — 2026-10-06”, summarized under Contract below. That contract supersedes earlier mobile provider sections, not historical transaction data.

## Global constraints and execution boundaries

- Read `AGENTS.md` and `rules/ui_rules.md`. AGENTS names `rules/backend_rules.md`, but that file was absent during inspection; the actual existing backend rules are `rules/rules_backend.md`. Read that file and report the discrepancy; do not silently create a replacement or edit project instructions.
- Preserve existing architecture, visual identity, shared widgets, colors, styles, spacing, and all configured locales. No UI redesign or unrelated auth, biometric, snackbar, or billing refactor.
- The workspace already contains extensive unrelated changes. Capture `git status --short` before work and preserve them. Never reset, clean, stash, or stage the entire workspace. Do not commit unless requested; if requested, stage only implementation-owned changes.
- Remove obsolete active provider code and current-checkout fixtures. Preserve historical provider labels/IDs, historical fixtures explicitly testing history, applied migrations, transaction records, and archival documents. Never globally replace historical MyFatoorah records with Payzah.
- Do not put merchant keys, credentials, provider status calls, refund submission, webhook handling, or admin gateway configuration in the customer app.
- Backend capability gaps must be documented explicitly. Do not invent endpoints, JSON field names, integrationType values, provider domains, terminal-status strings, or successful outcomes.
- Write meaningful failing tests before implementation and confirm they fail for the intended reason. Run focused tests after each task, then analyze and run regression tests once integration is complete.

## Contract

1. Active checkout provider is Payzah, payment-method ID `3`, code `PAYZAH`, obtained from the payment-method endpoint. KNET/card choice takes place in hosted checkout; merchant account controls availability and fees.
2. Open API-supplied `paymentUrl`. Provider initialization returns its `PaymentID`, persisted separately on the server. Application processing and return links use immutable `pz-<TrackId>` handles. Do not derive either ID from a URL or substitute one for the other.
3. Browser return is GET or POST `/api/v1/payments/payzah/return?trackId=<persisted-track-id>`. Let the backend receive and process this request. Do not intercept it as completed payment.
4. Fixed return destinations are `mealmate://checkout/success`, `/error`, `/pending`, `/review`, with application `paymentId`. Redirects are untrusted hints, never payment evidence. Callback `paymentStatus` and arbitrary `to` destinations have no authority.
5. Success needs both server-verified capture and accepted application processing. Pending means check application status. Review means reconciliation by support and no new payment for that unresolved operation.
6. Provider fee/total fields may be null. Null means unknown, never zero. KWD uses three decimals. Do not add a fee to a total without knowing whether that total already includes it.
7. Historical provider operations must never be sent to Payzah. Accepted/uncertain refunds reserve the amount and require review; acceptance does not mean funds returned.

## Verified repository findings

| Surface | Existing evidence | Required correction |
| --- | --- | --- |
| Shared WebView | `lib/core/widget/payment_redirect_web_view.dart` detects `/api/v1/payments/myfatoorah`, consumes `to`, accepts any non-error mealmate link as success hint | Remove legacy detection and permissive parser; strictly parse fixed destinations and let backend return load |
| Single checkout | `lib/features/payment/presentation/manager/payment_view_model.dart` sends `mealmate://payment/success` and `/error` | Use fixed checkout destinations and explicit unresolved states |
| Method mapping | `lib/features/payment/data/mapper/payment_mapper.dart` falls back to mada for unrecognized code; enum has no Payzah | Recognize Payzah explicitly, avoid old logo/description and unknown-provider fallback |
| Status model | `payment_status_response_dto.dart` and `payment_entity.dart` contain isPaid/isFailed, no attempt identity or application-processing field | Confirm actual server contract before extending models or deciding success |
| Upgrade | `restaurant_tier_upgrade_view_model.dart` defaults method ID to 1; regards empty paymentUrl as immediate success | Remove default; require explicit authoritative applied outcome for zero-payment upgrades |
| Upgrade WebView | Separate screen shares `PaymentRedirectWebView` | Wire all four outcomes and attempt identity in both screens |
| Family checkout | `family_payment_setup_screen.dart` routes to shared PaymentWebViewScreen; family actions already send checkout/success and error | Preserve routes and carry verified attempt context through shared screen |
| Resume billing | `subscription_billing_action_coordinator.dart` constructs PaymentCheckoutEntity; request DTO defaults checkout/callback | Preserve all response context and use checkout/success |
| Tests | Several current upgrade fixtures say MYFATOORAH_HOSTED and one uses demo.myfatoorah.com | Replace current-provider fixtures with actual Payzah API examples; retain historical tests separately |

## Task 1 — Confirm wire contracts and inventory removal

**Files:** Inspect payment DTOs, `lib/core/network/api_services.dart`, `network_constants.dart`, family checkout mapper/DTOs, upgrade options/request/status DTOs, billing response/action DTOs, Android manifest, iOS Info.plist, existing app-link handling, pubspec and asset registry.

- [x] Capture baseline status and run the searches below. Classify each result as active integration, reusable payment feature, historical record/test, or archived documentation.

```powershell
git status --short
rg -n -i 'myfatoorah|fatoorah|payzah|MYFATOORAH_HOSTED|mealmate://payment|checkout/callback' lib test assets android ios pubspec.yaml
rg -n 'PaymentRedirectWebView|paymentMethodId|paymentUrl|paymentId|integrationType|fee|totalAmount' lib/features/payment lib/features/family_checkout lib/features/subscription_upgrade lib/features/subscription_settings
```

- [x] Obtain actual backend response examples or existing checked-in schemas for methods, initialization, subscription status, family checkout, upgrade creation/status, and resume. Record exact fields, types, nullability and status values in the implementation report.
- [x] Specifically confirm how authenticated status proves accepted fulfillment, exposes review, identifies the current payment attempt, and prevents retry while captured/unresolved. `isPaid` alone is usable only if backend explicitly guarantees capture AND accepted application processing for the operation being verified.
- [x] Do not require a new field on the existing checkout response merely because provider initialization has PaymentID: the contract preserves app-facing checkout schema. If checkout has no application handle, obtain binding from an existing authenticated status response. Until binding is available, a redirect ID may trigger status checking only, never identify a different operation or authorize completion.
- [x] If no existing response proves operation/attempt binding or no server review/retry guard exists, continue independent cleanup and tests, then report that exact backend dependency. Do not invent a payment-status URL or claim full security completion.

**Deliverable:** A concrete list of removable active symbols/assets and confirmed wire examples. No provider credentials in examples.

## Task 2 — Strict return parser and hosted navigation

**Create:** `lib/core/payment/payment_return.dart` (pure parser/result, no UI/network). `test/core/payment/payment_return_test.dart`.
**Modify:** `lib/core/widget/payment_redirect_web_view.dart`.

**Interface:** `enum PaymentReturnDestination { success, error, pending, review }`; immutable `PaymentReturn` exposes `destination` and `String paymentId`; `PaymentReturn? parsePaymentReturn(Uri uri)` returns null for an invalid/unrecognized link. Replace the two callback API with `void Function(PaymentReturn) onPaymentReturn`; update both consumers in Task 4.

- [x] Write tests first for all four valid links; fake host; extra path segment; wrong scheme; missing/empty/duplicated paymentId; provider PaymentID instead of pz handle; arbitrary `to`; malformed URI; fragment; duplicate delivery. Use exact matching, not contains, regex over the whole URL, or suffix matching.

```dart
test('parses fixed Payzah pending return', () {
  final result = parsePaymentReturn(
    Uri.parse('mealmate://checkout/pending?paymentId=pz-track-123'),
  );
  expect(result?.destination, PaymentReturnDestination.pending);
  expect(result?.paymentId, 'pz-track-123');
});
test('rejects an unrelated custom-scheme link', () {
  expect(parsePaymentReturn(Uri.parse(
    'mealmate://attacker/success?paymentId=pz-track-123',
  )), isNull);
});
test('rejects duplicated identifiers', () {
  expect(parsePaymentReturn(Uri.parse(
    'mealmate://checkout/success?paymentId=pz-a&paymentId=pz-b',
  )), isNull);
});
```

- [x] Run `flutter test test/core/payment/payment_return_test.dart`; verify the intended missing-parser failure before implementation.
- [x] Implement exact scheme `mealmate`, host `checkout`, path from the four-item set; reject userinfo, explicit port and fragment. Require exactly one nonempty `paymentId` with `pz-` prefix and nonempty suffix, bounded length, no control characters. Confirm any stricter TrackId character set/length with the backend; do not invent GUID-only parsing. Never consume `to`, amount, paymentStatus, subscriptionId or upgradeId from the link. Ignore non-authoritative extra query fields unless the confirmed schema requires rejecting them.
- [x] Delete `_isBackendPaymentCallback`, `_handleBackendPaymentCallback`, old host exceptions and legacy `to` routing. Navigation to the legitimate HTTPS Payzah return endpoint must proceed normally so GET/POST reaches the backend. Prevent recognized custom-scheme return navigation only after parsing, then dispatch typed result once. Block unsupported custom schemes safely without marking success or failure.
- [x] Validate the initial API paymentUrl before loading: absolute HTTPS, nonempty host, no userinfo, no javascript/data/file/http scheme. Use exact documented backend-approved checkout origins if supplied. Do not blanket allow `*.payzah.net` or force every hosted page/3DS hop to remain on the initial host. If no verified hosted/3DS origin policy exists, document that gap and keep the URL scheme boundary; endpoint initialization URLs are not evidence of hosted checkout origins.
- [x] Never inject auth headers/cookies/tokens into provider navigation. Do not bypass certificate errors, enable mixed content, add JS bridges, or log the paymentUrl/query/body. Unrestricted JS may remain where hosted checkout requires it; it grants no authority to complete payment.
- [x] Add WebView delegate integration tests proving backend return navigates, accepted custom links stop navigation, unrelated schemes never trigger completion, and duplicate notifications dispatch once. Run parser and delegate tests.

## Task 3 — Methods, nullable money and response identity

**Modify:** `lib/features/payment/domain/entities/payment_entity.dart`; `data/mapper/payment_mapper.dart`; `data/models/response/payment_method_response_dto.dart`; `payment_checkout_response_dto.dart`; `payment_status_response_dto.dart`; payment method logo/tile; family checkout mapper; upgrade method DTO/entity/mapper/logo/tile; billing response DTO/mapper/entity only where confirmed fields exist.
**Tests:** Extend `test/payment_sandbox_method_test.dart`, `test/restaurant_tier_upgrade_mapper_test.dart`, `test/restaurant_tier_upgrade_summary_mapper_test.dart`; create `test/payment_payzah_mapper_test.dart`.

- [x] Write failing mapping tests for method ID 3/code PAYZAH, unavailable Payzah, conflicting code/ID, unknown method, nullable fees/totals, and unchanged wallet/history mapping.
- [x] Add Payzah enum/type and map the confirmed code/ID explicitly. Unknown/conflicting provider data must not silently become mada, Payzah, or an available default. Preserve wallet and legitimate zero-payment/sandbox methods only if the current API exposes and permits them. The app must never expose a client-only payment bypass.
- [x] Use API availability and actual selected ID. Remove method ID 1 fallback in upgrade submission. Do not replace it with `?? 3`: absent selection is validation failure, not permission to invent a choice.
- [x] Show Payzah title with neutral existing icon or an approved brand asset. Remove mada/visa/apple descriptions from the Payzah tile; do not invent merchant-supported methods/fees. Do not display integrationType as customer-facing explanation.
- [x] Model confirmed provider fee/total fields as nullable through DTO → Entity → UI. Missing and explicit null remain null; explicit zero stays zero. Distinguish plan price from provider-inclusive total. Use existing formatter with three decimals for KWD; never calculate or approve a charge from callback data.
- [x] Add application payment handle/processing status fields only where wire examples provide them, propagating them through family/resume and upgrade route arguments. Provider PaymentID is not the app handle and is not a mobile lookup key.
- [x] Regenerate affected serializers using existing project tooling, inspect generated diffs, and avoid unrelated generator churn. Run mapping tests and check analysis for exhaustive enum switches.

## Task 4 — Secure operation state and all entry points

**Modify:** `lib/features/payment/presentation/manager/payment_event.dart`, `payment_state.dart`, `payment_view_model.dart`; `presentation/screens/payment_web_view_screen.dart`; `domain/entities/payment_args.dart`; upgrade Event/State/ViewModel/WebView screen and `restaurant_tier_upgrade_args.dart`; `family_checkout/presentation/widgets/family_payment_methods_actions_section.dart`; `family_checkout/presentation/screens/family_payment_setup_screen.dart`; billing action coordinator/request DTO and checkout/resume callers where needed.
**Create:** `test/payment_return_security_test.dart`; `test/payment_fulfillment_state_test.dart`. Extend `test/restaurant_tier_upgrade_view_model_test.dart`, `test/restaurant_tier_upgrade_screen_test.dart` and existing family/billing tests.

**State requirements:** Represent verifying, pending, review-required, accepted, failed distinctly in existing feature state. Carry operation context captured from authenticated initialization: subscription ID, upgrade ID where applicable, attempt handle when confirmed, and polling generation. Add a typed result event using PaymentReturn from Task 2; link data must never replace the initialized operation IDs.

- [x] Write failing tests for spoofed success with unpaid server result, captured-but-unapplied review, old attempt callback, missing URL unpaid upgrade, late old poll response, double tap, timeout and closed ViewModel.
- [x] Standardize callback/error values to `mealmate://checkout/success` and `mealmate://checkout/error` across single/family/upgrade/resume request construction. Retain request fields only when the API still accepts them; backend selects fixed final destinations regardless of caller strings.
- [x] Match returned paymentId against expected attempt handle whenever known. Mismatch/unknown historical ID cannot activate or mark failure for the current attempt. If binding is unknown, query only the authenticated initialized operation and require server-authoritative current-attempt/fulfillment evidence.
- [x] All four redirect destinations are hints. Success/pending start or resume status verification for the initialized operation. Error may show provisional cancellation/failure but cannot override an already accepted payment or release holds; reconcile status before enabling a new charge. Review immediately blocks new-payment actions for this operation and checks status; a later forged error/success cannot remove the review block. Only authoritative reconciliation can resolve it.
- [x] Update both WebView screens to consume typed outcomes. Never navigate to success merely because a redirect, query paymentStatus, empty paymentUrl, expired hold, or provider PaymentID exists.
- [x] Fix upgrade creation's existing `isPaid || paymentUrl empty` success shortcut. A no-charge upgrade can succeed only on explicit authenticated applied/accepted outcome confirmed by the schema. Empty URL plus unpaid/pending is unresolved/error, never success.
- [x] Use bounded backoff and one in-flight status request per operation; poll GET/status only. At exhaustion show pending with a status-only retry. API/network timeout is unknown, not failed or an instruction to resubmit checkout. Existing correlation/idempotency key must be retained for the same initialization retry according to backend policy; never assume client keys replace server idempotency.
- [x] Increment/cancel generation on new attempt, logout, closure, or disposal. Reject responses from obsolete polling generations after every await, including cache synchronization. Cache/subscription synchronization and success navigation happen once, only after accepted processing. Dispose controllers/listeners and avoid setState/emit after closure.
- [x] Disable repeat submit while initializing/verifying or captured/review-required. Enforce across checkout screen, family action, upgrade, and resume entry points, not only the WebView. Server remains the actual enforcement boundary; reopening the app cannot bypass review.
- [x] On back/close/resume, retain unresolved operation identity and recheck status rather than starting checkout automatically. Rehydrate from existing authenticated operation/status APIs after process death; do not persist keys or a trust decision derived from the redirect. If no API can rediscover unresolved operations, report that backend gap.
- [x] Inspect external-return handling for warm and cold starts. Reuse the existing app-link mechanism if present; if there is none, do not install a dependency silently. Document the gap and obtain approval for any required platform/package addition. Native deep-link filters narrow routing but cannot authenticate custom-scheme links; authenticated status remains mandatory.
- [x] Run focused feature tests; ensure unrelated mealmate links retain their existing behavior outside the payment WebView.

## Task 5 — Pending/review UX and localization

**Modify:** Existing payment/upgrade screen state rendering and smallest reusable feature widgets; `lib/core/l10n/app_ar.arb`, `app_en.arb`, all configured locale files; generated localizations using project tooling.

- [x] Add localized Payzah label and unresolved state copy through locale keys, not raw widget strings. Suggested Arabic review copy: «عملية الدفع تحتاج مراجعة من الدعم. لا تبدأ عملية دفع أخرى لهذا الطلب حتى يتم تأكيد النتيجة.» Suggested pending copy: «نتيجة الدفع لم تتأكد بعد. يمكنك التحقق من حالة الطلب.» English equivalents must communicate the same actions.
- [x] Review action opens the existing support destination and supplies a copyable nonsecret application payment handle when available. Pending action performs status verification only. Neither button creates checkout, refunds, or calls Payzah.
- [x] Keep error/cancel distinct from review; do not say “payment failed” or “refunded” for captured/uncertain outcomes. If fees are unknown, omit a numeric fee or show localized “confirmed at checkout”; never show 0.000 KWD by default.
- [x] Use existing spacing/styles/theme, RTL via Directionality, existing loaders/error/empty widgets, and scoped listeners. Test Arabic/English rendering, long text, accessibility labels, retry action and disabled submit behavior.

## Task 6 — Remove obsolete integration safely

**Modify/remove:** Only active legacy symbols, unused provider-specific assets/configuration/dependencies proven by Task 1; current-checkout tests referencing obsolete URLs/provider fixtures. Preserve shared hosted-checkout WebView and historical data types.

- [x] Remove MyFatoorah callback helpers/URL checks, old destination builders, active integration constants and legacy provider-only SDK wiring if found. Pubspec currently uses a generic WebView; do not remove it as part of gateway cleanup.
- [x] Check every asset reference before deleting a logo. Mada/Visa/KNET are payment networks, not necessarily legacy-gateway artifacts; delete only assets exclusively tied to the retired provider, and keep assets needed by historical display or other legitimate surfaces.
- [x] Replace current-provider fixture values using actual backend Payzah examples. Do not invent `PAYZAH_HOSTED` merely as a replacement for `MYFATOORAH_HOSTED` unless the API returns that exact value.
- [x] Remove obsolete current mobile-guide instructions or mark superseded sections; retain archival guides and historical test cases with explicit purpose. Do not rewrite git history or applied migrations.
- [x] Search again. Active production code/current-provider fixtures must contain no MyFatoorah endpoint or credentials, no `mealmate://payment/...`, and no `checkout/callback` builder. Report retained historical references with reasons; never hide them just to obtain zero search hits.

## Security test matrix — mandatory acceptance cases

| Case | Required result |
| --- | --- |
| Fake success link, server unpaid | No activation, no success navigation |
| Correct capture but application processing rejected | Review; new payment blocked |
| Captured provider ID from another environment | Mobile uses pz handle; backend verifies stored environment, never client override |
| Callback from attempt A after B initialized | No fulfillment/cache update for B; no releasing B's holds |
| Duplicate return / webhook / app resume | Server idempotency plus client dedupe; one activation/navigation |
| Old async response after new attempt/logout | Ignored; no stale cache mutation or navigation |
| Missing/duplicate/malformed ID, unknown custom host/path | Rejected; no success/failure side effect |
| Query `to`, amount, currency or paymentStatus injected | Never used to authorize routing/fulfillment/charge |
| Backend return GET or POST | Reaches server; WebView does not short-circuit verification |
| HTTP/javascript/data/file URL or TLS error | Checkout rejected; no certificate bypass |
| Status API offline/timeout/401/403 | Unknown/status error or existing session-expiry flow; no automatic new charge |
| User closes/reopens app while pending/review | Rediscover operation and reconcile; review guard still enforced server-side |
| No paymentUrl and not accepted | No success shortcut |
| Legitimate no-charge upgrade with explicit applied status | Success once through authenticated application result |
| Null fee/total versus explicit zero | Unknown remains unknown; real zero renders correctly |
| Historical provider transaction/refund | Display retained; never sent to Payzah |
| Accepted/uncertain refund | Review/reserved; no automatic resubmit or “funds returned” claim |

## Backend security responsibilities — verify contract, do not implement in Flutter

- Persist immutable track/reference, expected money/currency, original provider PaymentID and environment per attempt. Verify exact binding with Payzah server status; check response money whenever provided. Store and uniquely enforce pz handles across environments.
- Serialize/idempotently process callbacks and notifications. Merchant/browser return is sufficient; optional JSON webhook accepts documented trackId and re-verifies. Do not invent HMAC, secret, event schema or webhook as a mobile dependency.
- Bind authenticated status and checkout actions to the account and operation; reject IDOR and obsolete quote/hold attempts. Captured rejected processing enters review; backend blocks another payment for the unresolved operation. Client boolean guards cannot enforce this across devices.
- Fixed return destinations only; ignore arbitrary to. Historical IDs/no bound attempt enter review and never trigger Payzah status/refund calls.
- Refund payload uses original server-verified payzahRefrenceCode/track ID and documented refund fields. Acceptance/uncertainty reserves amount, never auto-resends and never marks returned funds. No invented receipt IDs/status endpoint.
- Settings GET/PUT is admin-only, encrypted key storage, masked responses, new key on environment switch. Customer app must never access this endpoint. Configure absolute HTTPS PublicBaseUrl and secrets server-side; readiness is not credential/live verification.
- Backend migration remains an operator-reviewed forward migration preserving history. This plan authorizes no database migration, transaction, refund, or deployment.

## Task 7 — Verification and final handoff

- [x] Run the exact focused tests added/changed in Tasks 2–5. Include existing `payment_sandbox_method_test.dart`, `subscription_coupon_checkout_test.dart`, `payment_success_screen_test.dart`, and upgrade mapper/ViewModel/screen/payment-section suites. Update old request fixture callback URLs without weakening assertions.

```powershell
flutter test test/core/payment/payment_return_test.dart test/payment_payzah_mapper_test.dart test/payment_return_security_test.dart test/payment_fulfillment_state_test.dart
flutter test test/payment_sandbox_method_test.dart test/subscription_coupon_checkout_test.dart test/payment_success_screen_test.dart test/restaurant_tier_upgrade_mapper_test.dart test/restaurant_tier_upgrade_summary_mapper_test.dart test/restaurant_tier_upgrade_view_model_test.dart test/restaurant_tier_upgrade_screen_test.dart test/restaurant_tier_payment_section_test.dart
flutter analyze
git diff --check
git diff --stat
rg -n -i 'myfatoorah|fatoorah|mealmate://payment|checkout/callback' lib test assets android ios pubspec.yaml
```

- [x] Run the full existing test suite if available. Record unrelated baseline failures separately; do not repair unrelated auth work or claim all tests pass if they do not.
- [x] Inspect diff manually for unrelated generator/localization changes, credentials, unsafe logging, broad host allowlists, removed historical labels and raw hardcoded strings.
- [x] Manual QA with mocked backend status first: single, family, upgrade and resume; four return states; forged/stale redirects; repeated taps; network failure; lifecycle resume; RTL/LTR. Use a real merchant sandbox transaction only when separately authorized and configured. No paid action is necessary to validate the parser/state tests.
- [x] Deliver changed files, removed active legacy components, retained historical references, test command outcomes, manual QA results and exact unresolved backend dependencies. State explicitly whether real sandbox payment, refunds, migration or deployment were run. Do not claim end-to-end payment readiness without an authorized real sandbox transaction and backend fulfillment verification.

**Definition of done:** Active mobile checkout uses the API's Payzah method and hosted URL; legacy active integration is removed; all four returns have safe explicit states across every flow; redirects never establish success; no empty-URL success shortcut remains; unknown money remains nullable; unresolved capture blocks another payment via server-enforced policy; history is preserved; tests pass or concrete external dependencies are openly recorded.
