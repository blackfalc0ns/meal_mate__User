# Offers and campaigns contract implementation plan

**Goal:** Apply the 2026-10-20 mobile handoff using the existing feature architecture.
**Architecture:** Retrofit ? remote source ? repository/mapper ? use cases ? ViewModel/state. Reuse campaign payment.
**Spec:** User attachment 714eff5e-def0-417f-bc7e-2fbc8964c8e3/Pasted text.txt.
**Constraints:** No new packages, no unrelated edits, generate serializers and DI. New campaign UI awaits Figma per rules/ui_rules.md. Existing UI changes only correct integration.

## Tasks
- [x] Reproduce GET filtering bug in offer_purchase_mode_transport_test.dart, implement POST body for explicit includeCampaigns through existing ApiServices/data source, verify actual wire request.
- [x] Preserve campaign-sourced coupons with codes in offers_state.dart and existing navigation; block unavailable items and empty coupon actions. Cover partition/navigation.
- [x] Add nullable campaign list/details/options/quote DTOs and domain entities, mappers, Retrofit endpoints, source/repository methods and use cases. Preserve campaignBundleId and nullable prices. Test response mapping and request serialization with fake Dio adapter.
- [x] Add campaign selection ViewModel/state with independent list loading, cursor pagination, parent selection invalidation, quote readiness and persistent checkout attempt. Pass quoteId and persisted idempotencyKey to session creation. Cover selection/race/checkout with tests.
- [x] Persist campaign payment request before network submission, restore same key/body on restart, wait for subscriptionId before success. Test restart and unknown/committing statuses.
- [x] Generate code, format changed files, run focused tests and analyzer, review diff. Report Figma/live sandbox dependencies without claiming complete UI/payment QA.

## Verification and remaining work

- 2026-10-20: `flutter test --no-pub test/features/offers test/offers_v2_contract_test.dart test/core/errors/offers_v2_errors_test.dart --reporter expanded`: 100 tests passed.
- `dart analyze lib/features/offers lib/features/offer_details/presentation/screens/offer_details_screen.dart lib/core/network/api_services.dart lib/core/network/network_constants.dart test/features/offers`: no issues.
- `git diff --check`: passed. Build runner regenerated Retrofit, JSON and DI; its broader dependency warnings were inspected and the new factories are registered.
- New campaign list/selection ViewModel and API path are implemented but not exposed by a new campaign tab/screen. This requires Figma under rules/ui_rules.md; user has been asked. Existing campaign payment screen is reused; a new campaign selection UI must consume the session state and navigate with its sessionId.
- No live API, payment provider, sandbox checkout, or device visual QA was performed. No commercial payment readiness claim.
- Cancellation endpoint/use case is connected. A new cancellation UI is outside this backend integration pass.
- Availability reason codes are preserved in the offer model; presentation of new reason codes needs their localization mapping.

## Follow-up: scoped backend clarification

- New instruction supersedes the earlier campaign-coupon exception: exclude every explicit sourceType=Campaign from offers lists, hero, saved, and filters, even when it has a promoCode.
- Offers screen retry now uses POST available with includeCampaigns=false, matching initial load and refresh.
- Unavailable cards retain disabled actions and display the reason through the existing localized error-code mapper; details and quick preview show the reason too.
- Direct offer checkout always requires explicit review/terms consent, including when termsAcceptanceRequired=false; selected server option, available payment method, canCheckout and unexpired quote remain required.
- Acceptance count 11 depends on the backend payload. The app does not fabricate missing offers or reclassify CouponOnly.
- Focused offers/contract/error suite: 103 tests passed. New regression tests reproduced the missing filtering/reason/consent behaviors before fixes.
