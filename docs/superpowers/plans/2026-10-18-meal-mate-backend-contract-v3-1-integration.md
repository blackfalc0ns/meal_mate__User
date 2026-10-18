# MealMate Backend Contract v3.1 Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]).

**Goal:** Integrate Backend Contract v3.1 into the existing Flutter architecture for individual and family subscriptions, offers, coupons, readiness, coverage, checkout, payment verification, retries, advertising analytics, compatibility, centralized errors, and loading shimmer states.

**Architecture:** Preserve Feature-Based Clean Architecture. Route every API through existing Dio/Retrofit/ApiResult/safeApiCall/GetIt/Injectable layers, map DTOs to domain entities, and expose state through existing ViewModels. Keep individual and family routes separate while sharing money, errors, coupon, payment, idempotency, and loading primitives.

**Tech Stack:** Flutter/Dart, existing Dio/Retrofit, ApiResult/safeApiCall, GetIt/Injectable, ViewModel/Event/State pattern, Flutter tests.

**Spec:** User-provided “MealMate Mobile Backend Handoff — Complete Contract, Version 3.1”; supporting specs in `docs/superpowers/specs/backend_pasted_text.txt`, `docs/superpowers/specs/2026-10-05-individual-subscription-backend-contract.md`, `docs/superpowers/specs/2026-09-07-family-allergies-addresses-checkout-design.md`, and `docs/superpowers/specs/2026-09-06-address-coverage-preview-design.md`.

## Global Constraints

- Read `AGENTS.md`, `rules/ui_rules.md`, and `rules/rules_backend.md` before implementation.
- Preserve architecture, navigation, widgets, theme, spacing, localization, and dependency setup.
- Use existing Dio/Retrofit, ApiResult, safeApiCall, interceptors, GetIt, and Injectable.
- Do not redesign screens or put business logic in widgets.
- Use `lib/core/errors` for all API errors with stable code, bilingual messages, optional field, and retry/refresh advice.
- Use existing shimmer conventions; every new loading state needs a widget and tests.
- Money is KWD with three decimal places; server values are authoritative.
- UTC fields are ISO-8601; `serverNowUtc` drives countdowns and expiry.
- Never infer payment success, eligibility, price, coverage, availability, or expiry locally.
- Match by stable IDs, never names/images.
- Keep legacy fields and additive v3.1 fields.
- New idempotency key after selection, price, quote version, batch, or payload changes.
- Never use individual routes inside family flow.

## File Map

Inspect before changing: `lib/core/errors/*`; API/data sources under `lib/features/offers/data`, `lib/features/subscription_checkout/data`, `lib/features/payment/data`, and family data features; entities/DTOs/mappers/repositories/use cases/ViewModels under offers, subscription_checkout, payment, family_context, family_packages, family_addresses, family_allergies, and family_management; existing presentation loading widgets; `lib/l10n`; related tests.

### Task 1: Freeze contract and inventory current implementation

**Files:** Read `AGENTS.md`, `rules/ui_rules.md`, `rules/rules_backend.md`, `docs/superpowers/specs/backend_pasted_text.txt` and all affected feature files. Create `docs/superpowers/specs/meal_mate_mobile_backend_contract_v3_1.md` only if v3.1 is not already tracked. Test by searching all endpoint strings and mapping each to v3.1.

- [ ] Inventory each endpoint, DTO, mapper, repository, use case, ViewModel, state, screen, and shimmer.
- [ ] Map existing fields for base/campaign/promo/subtotal/discount/wallet/gateway/final/coupon/eligibility/availability/expiry.
- [ ] Do not delete fake data until all required consumers use real API data.

### Task 2: Centralized errors in `lib/core/errors`

**Files:** Modify existing error model/mapper files under `lib/core/errors`; create only missing equivalent files; test `test/core/errors/api_exception_mapper_test.dart`, `test/core/errors/subscription_contract_error_messages_test.dart`, `test/core/errors/family_error_contract_test.dart` and focused new tests.

**Interfaces:** Produce one domain error containing `statusCode`, stable `code`, optional `field`, `messageAr`, `messageEn`, and `advice`. `advice` contains `retryable`, `refreshSummaryRequired`, and `refreshAvailabilityRequired`.

- [ ] Parse all mobile-facing error fields without losing unknown fields.
- [ ] Map 400, 404, 409, 410, 422, and 502 to documented client actions.
- [ ] Preserve codes: `checkout.capacity_hold_expired`, `family.coupon_rejected`, `family.coupon_context_unavailable`, `checkout.address_required`, `allergies_required`, `dietary_preferences_required`, `no_restaurants_for_address`, `no_restaurants_for_selection`.
- [ ] Select Arabic/English messages by active locale without changing backend codes.
- [ ] Test missing advice, unknown codes, refresh flags, and bilingual selection.

### Task 3: Money, eligibility, availability, coupon, and expiry models

**Files:** Modify `lib/features/subscription_checkout/domain/entities/subscription_summary_entity.dart`, `subscription_coupon_entity.dart`, offer/family entities, response DTOs, and mappers. Test existing availability/coupon/family price tests plus new mapper tests.

- [ ] Map legacy and additive fields; enforce `subtotal = basePrice` and `discount = campaignDiscount + promoDiscount`.
- [ ] Never add `coupon.discountAmount` twice.
- [ ] Preserve wallet/gateway/final/currency/moneyScale, eligibility, availability, blocking reasons, `summaryExpiresAtUtc`, and `serverNowUtc`.
- [ ] Support coupon statuses `valid`, `not_found`, `inactive`, `not_started`, `expired`, `ineligible`, `stacking_conflict`, `usage_exhausted`.
- [ ] Keep failed coupon text and server message; never calculate discount on device.
- [ ] Test three decimals, null coupon, unknown status, additive fields, and UTC expiry.

### Task 4: Catalog and offers

**Files:** Modify data source, DTO, mapper, repository, and use cases under `lib/features/offers`, `subscription_programs`, and `subscription_types`; modify affected offer/program/type loading widgets; test existing offer/program/type tests plus endpoint tests.

- [ ] Align types, programs, bundles, durations, tiers, family programs/bundles, offers hub, and offer details routes.
- [ ] Expose stable IDs, nameAr/nameEn, active availability, category/tier, server durations.
- [ ] Match target on subscription type + program + bundle + tier + duration.
- [ ] Preserve visible unavailable offers with server reason codes.
- [ ] Add loading, empty, network error, expired, and retry states with shimmer.

### Task 5: Individual readiness, summary, coupon, and shimmer

**Files:** Modify data source/DTO/request/response/mapper/repository under `subscription_checkout`; summary entities/use cases; `subscription_summary_view_model.dart`, state, event, screen, and widgets; add feature shimmer only if absent. Test summary, coupon, readiness, address refresh, and shimmer tests.

- [ ] Implement summary query with IDs, tier, duration, startDate, includeFriday, and URL-encoded promoCode.
- [ ] Integrate customer addresses, allergies, dietary, readiness, and restaurant availability endpoints.
- [ ] Refresh summary after any plan/type/duration/date/Friday/coupon/address/readiness change.
- [ ] Block checkout when `canCheckout` is false or eligibility/availability/blocking reasons fail.
- [ ] Keep coupon after failure and use server messages.
- [ ] Add shimmer for initial summary, refresh, readiness, availability, and button loading.
- [ ] Test loading/error/retry/empty/expiry and selective rebuilds.

### Task 6: Family setup, summary, coupon, coverage, and shimmer

**Files:** Modify existing family data sources/DTOs/mappers/repositories/entities/use cases/ViewModels under `family_context`, `family_packages`, `family_addresses`, `family_allergies`, and `family_management`. Create `family_checkout` only if no existing equivalent. Test family contract/payment/loading/mapper tests.

- [ ] Align current, packages, members, member update, plan, checkout-selection, and family summary routes.
- [ ] Map member ID/display name/role/relationship/setup/plan/duration/address/eligibility/availability.
- [ ] Map familyGroupId, subtotal, discount, walletCredit, gatewayFee, fractional familyDiscountPercent, familyDiscountAmount, finalPrice, selectedNewSubscriberCount, batchId, batchVersion, canCheckout, checkoutBlockReason, blockingReasons, expiry, and serverNow.
- [ ] Treat checkoutBlockReason as first blocking code; use blockingReasons for full UI.
- [ ] Integrate member address and preview-coverage routes.
- [ ] Send family summary promoCode; preserve it after family coupon errors and do not show an undiscounted success.
- [ ] Add shimmer for current/packages/members/member setup/summary/coverage.
- [ ] Test member switching, partial readiness, batch/version changes, coupon rejection, locked quote refresh, empty/error/retry, and shimmer.

### Task 7: Checkout and idempotency

**Files:** Modify checkout API/data source/DTO/repository/use case/ViewModel layers under payment, subscription_checkout, and family feature; modify `lib/core/payment/payment_attempt.dart` and `payment_attempt_store.dart` only if required; test checkout/idempotency/store tests.

- [ ] Individual sends selections and body idempotencyKey only; never sends local prices.
- [ ] Family sends batchId, batchVersion, idempotencyKey, optional paymentMethodId, optional promoCode, callbackUrl, errorUrl, optional correlationId/clientContractVersion.
- [ ] Validate allowed callback/error app scheme/host.
- [ ] Persist paymentUrl, holdExpiresAtUtc, finalPrice, currencyCode; persist individual subscriptionId or family familyGroupId/paymentAnchorSubscriptionId.
- [ ] Reuse key only for same logical attempt; new key after payload/quote/selection changes.

### Task 8: Payment verification, retry, expiry, polling

**Files:** Modify payment status use case/repository/data source/DTO/mappers, payment ViewModel/state/events/screens, family payment status/retry layers, and `lib/core/payment` return/navigation/deep-link files. Test checkout lifecycle, return security/recovery, unresolved status, and family payment tests.

- [ ] Verify server payment status after WebView; redirect never proves success.
- [ ] Support Pending, Paid, Failed, Expired, Cancelled, Refunded, PartiallyRefunded.
- [ ] Treat PaidPreparingCalendar, ReviewRequired, and unknown values as pending/review.
- [ ] Bounded polling with increasing intervals; stop on terminal status, timeout, or disposal.
- [ ] Individual uses subscriptionId; family uses authenticated current group with no selector query params.
- [ ] Family retry uses POST family retry-payment; if unavailable, refresh summary and start new checkout.
- [ ] On hold expiry, refresh summary/availability, discard old URL, and use new idempotency key.
- [ ] Success UI uses only server-confirmed data.

### Task 9: Advertising and analytics

**Files:** Modify offers/advertising data/domain/presentation layers; offers browse screen/widgets only for render/click/impression; add advertising tests.

- [ ] Implement placements with placementKey.
- [ ] Show only inside [displayStartsAtUtc, displayEndsAtUtc), using server time.
- [ ] Send impression/click with placementId, stable eventId, and eventType.
- [ ] Impression fires after actual visibility; click before navigation; duplicate event is ignored.

### Task 10: Loading shimmer and rebuild boundaries

**Files:** Modify/create shimmer widgets only in affected feature presentation/widgets; modify broad builders/ViewModels; test all affected loading/rebuild tests.

- [ ] Add explicit loading states for catalog, details, summary, readiness, availability, family current/packages/members/summary, coupon revalidation, checkout start, payment status, retry, and coverage.
- [ ] Keep static UI outside reactive builders; use existing selectors.
- [ ] Do not create futures/controllers/streams inside build.
- [ ] Follow UI rules for styles, spacing, colors, localization, direction, and one custom widget per file.
- [ ] Test shimmer visibility on loading and removal on success/error without unrelated rebuilds.

### Task 11: Localization and API-code presentation

**Files:** Modify existing `lib/l10n` files and `lib/core/errors` mapping; update affected widgets; add localization/error tests.

- [ ] Add localized labels for new coupon, payment, expiry, retry, coverage, readiness, family, loading, empty, and error states.
- [ ] Prefer server messageAr/messageEn; fallback to localized app copy only when absent.
- [ ] Preserve backend enums/codes.
- [ ] Support configured locales and inherited RTL/LTR without language-code layout checks.

### Task 12: Compatibility, DI, generated code, and verification

**Files:** Modify DI/network registration only where required; regenerate code through project commands; test all affected suites.

- [ ] Keep legacy and additive fields; prefer aggregate aliases during migration.
- [ ] Support old clients without clientContractVersion/idempotency fields; current clients send supported version.
- [ ] Do not send undocumented fields.
- [ ] Preserve bilingual header/interceptors.
- [ ] Run formatter, `flutter analyze`, targeted contract/error/payment/family/offer/shimmer tests, then the relevant full suite.
- [ ] Verify every v3.1 route/field has DTO, mapper, repository/use case, state, UI behavior, and test.
- [ ] Verify no family flow calls individual routes, no callback-only success, no expired URL reuse, and every async state has shimmer and terminal handling.

## Final Contract Coverage Checklist

- [ ] Individual/family route table and separate flows.
- [ ] Catalog types/programs/bundles/durations/tiers and stable IDs.
- [ ] Offers hub/details and five-field target matching.
- [ ] Individual and family addresses, preferences, readiness, and coverage.
- [ ] Individual/family summaries with all money, eligibility, availability, batch, expiry, and server time fields.
- [ ] Coupon statuses, individual/family evaluation, locked quote behavior.
- [ ] Checkout payloads, callback URLs, payment method, idempotency, client version.
- [ ] Individual status/resume and family status/retry.
- [ ] Official/review payment statuses and bounded polling.
- [ ] Advertising window, placementKey, impression/click idempotency.
- [ ] Hold expiry and new key.
- [ ] HTTP status/error advice in `lib/core/errors`.
- [ ] KWD precision, UTC dates, bilingual localization, additive compatibility.
- [ ] Loading shimmer and selective rebuild verification.
- [ ] Formatting, analyzer, and tests.

