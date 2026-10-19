# Offers and Promotions v2 Integration Plan

> **For agentic workers:** Execute the checked tasks in order. Read the supplied v2 specification and project rules before implementation. Keep the existing feature architecture and UI.

**Goal:** Connect offers, codes, pricing, checkout, wallet, referrals, and offer calendar to the v2 backend contract without mock business data.

**Architecture:** Extend the existing `ApiServices → RemoteDataSource → Repository → UseCase → ViewModel → Event/State → UI` flow. Keep DTOs in data, map to entities, and use existing `ApiResult`, `safeApiCall`, GetIt/Injectable, and `lib/core/errors`.

**Tech Stack:** Flutter, Dart, Dio, Retrofit, json_serializable, flutter_bloc.

**Spec:** `C:/Users/orignal store/.codex/attachments/44efa8e3-4668-4ffc-a2c4-3c452b41a8e2/Pasted text.txt` (Offers & Promotions Mobile Master Integration Guide v2.0).

## Global constraints

- Read `AGENTS.md`, `rules/ui_rules.md`, and `rules/rules_backend.md` before implementation. `AGENTS.md` names `rules/backend_rules.md`, but the file present in this checkout is `rules/rules_backend.md`.
- Existing architecture, screens, localization, theme, routing, and error widgets take priority over the spec's suggested `lib/models/offers/` directory and plain Dart models.
- Never calculate the payable amount in Flutter. Show the server preview and use checkout's `finalPrice` as the gateway charge. Never assume preview remains valid after checkout.
- Treat the v2 document as the intended new contract; differences from the current mobile code are migration work. Verify live method, auth, and payload behavior against the backend environment before removing old paths.
- Keep existing unrelated, uncommitted family checkout changes untouched. Do not include them in commits.

## Current integration map

| Area | Existing source | v2 action |
| --- | --- | --- |
| Offers | `lib/features/offers/`, `lib/features/offer_details/`, `EndPoints.customerOffersAvailable` is currently POST | Migrate list to GET; preserve details, cards, and routes; add saved, calendar, hub, and eligible restaurants. |
| Code entry | `promo_code_input_screen.dart` directly invokes `EvaluateOfferUseCase`; current endpoint is `/offers/evaluate` | Add validation flow and distinguish `promoCode` from `offerId`; remove fabricated `OfferEntity` on code success. |
| Pricing | `subscription_checkout` GET `/subscription-flow/summary` | Add v2 POST preview for offer flow and display its quote; retain existing summary behavior where still needed for subscription prerequisites. |
| Payment | `payment` POST `/subscriptions/checkout`, payment status and WebView already exist | Extend checkout request with `offerId` and idempotency key, preserve existing payment verification, then load confirmation. |
| Wallet | `lib/features/wallet/data/wallet_fake_data_source.dart` is used by wallet screens | Integrate real balances and paged transactions; preserve refund UI and do not invent refund API behavior. |
| Errors | `lib/core/errors/` already parses backend code, Arabic/English messages, and presents typed failures | Add offer/payment codes to existing mapping and presentation; use existing full screen/inline error widgets appropriately. |

## Task 1: Contract and transport inventory

**Files:** Inspect `lib/core/network/network_constants.dart`, `api_services.dart`, `lib/core/di/di.dart`, relevant DTOs/entities, route arguments, `lib/core/errors/*`, and corresponding tests. Add focused contract tests under `test/`.

- [ ] Enumerate each v2 route, method, auth requirement, query/body shape, and response keys in a testable checklist. Mark `/offers/available` as GET and `/subscriptions/checkout` as POST.
- [ ] Record where current offer selection, code entry, subscription summary, checkout, status polling, confirmation, wallet, and referral UI obtain data. Distinguish existing subscription summary data from v2 pricing preview.
- [ ] Add failing Retrofit/serialization contract tests for the exact v2 core flow: `offerId` only, `promoCode` only, both, and neither; checkout retains `startDate`, `paymentMethodId`, callbacks, and one stable idempotency key per attempt.
- [ ] Confirm `tier` wire type and discount rate unit in actual backend responses before changing mappers; current `OfferEntity.formattedDiscount` multiplies `discountRate` by 100 while the v2 example uses `25.0` for 25%.

## Task 2: Core error handling

**Files:** Modify only where needed: `lib/core/errors/subscription_error_codes.dart`, `api_exception_mapper.dart`, `failure_mapper.dart`, `error_message_presenter.dart`; add `test/core/errors/offers_v2_errors_test.dart`.

- [ ] Test that `{code,message,errors}` with HTTP 400/404 retains the backend `code` in `Failure`, without displaying a raw technical code to the user. Cover `not_found`, `inactive`, `not_started`, `expired`, `usage_exhausted`, `ineligible`, `self_referral`, `already_attributed`, `checkout.coupon_full_discount_unsupported`, `checkout.capacity_unavailable`, and `offers.customer.unavailable`.
- [ ] Add localized messages using the project's existing l10n mechanism. Preserve the shared mapper's behavior for unrelated errors. Prefer backend `messageAr`/`messageEn` if present; otherwise localize by code and use generic fallback.
- [ ] In offer and payment ViewModels, preserve useful data on refresh/action failures; use `InlineApiErrorWidget` or existing form feedback. Reserve full screen `ApiErrorWidget` for a failed initial load with no usable data. `200 []` is an empty state.

## Task 3: Offers catalog, details, saved offers, calendar, and hub

**Files:** Extend `lib/core/network/{network_constants.dart,api_services.dart}`, `lib/features/offers/{data,domain,presentation}` and the existing `offer_details` screen/manager. Add focused DTO/mapper/repository and ViewModel tests.

- [ ] Add GET `/offers/available`, GET `/offers/hub`, GET `/offers/{id}`, GET `/offers/{offerId}/eligible-restaurants`, GET `/offers/saved`, POST/DELETE `/offers/{offerId}/save`, POST/DELETE `/offers/{offerId}/calendar[/date]`, and GET `/offers/calendar` through existing layers. Use the v2 exact method, path, and query/body names.
- [ ] Extend nullable response DTOs and map `isSaved`, availability, terms, `allowPromoCodeStacking`, applicable IDs, server time, and eligible restaurants to domain entities. Keep nullable dates/amounts safe; do not turn missing business values into fabricated offers.
- [ ] Preserve browse/detail layouts. Wire saved state and reminders through events and states, with rollback if optimistic save fails. Use returned server state after success; avoid duplicate reminder entries on a repeated POST.
- [ ] Use server `endsAtUtc` and hub server time for countdown and expired display. Keep empty saved/calendar lists as empty states. Verify correct locale and RTL rendering under `rules/ui_rules.md`.

## Task 4: Code validation and offer selection

**Files:** Extend `lib/features/offers/data/models/{request,response}`, mapper, repository, use case, `offers_view_model.dart`, `promo_code_input_screen.dart`, `redeem_package_screen.dart`; update relevant route argument/entity files.

- [ ] Add POST `/offers/validate-discount` request with `code`, `programId`, and `bundleId`; map `isValid`, `codeType`, percentage, calculated amount, eligibility code, and localized failure messages. Test valid offer code, referral code, invalid response, and 400 error.
- [ ] Carry the chosen `offerId` independently of optional `promoCode` from browse/details through package choice, pricing, checkout, and back navigation. For a typed code, carry `promoCode`; do not synthesize an `OfferEntity` with fake IDs or descriptions.
- [ ] Keep offer choice and code choice when both are supplied, so the server can select the larger discount or stack when allowed. UI must display the *applied* discounts from preview rather than claiming both were applied.

## Task 5: Price preview and checkout

**Files:** Extend `lib/features/subscription_checkout/` or the existing pricing boundary, `lib/features/payment/{data,domain,presentation}`, `lib/core/network/*`, payment route args, and focused tests.

- [ ] Add POST `/subscription-pricing/preview` with `programId`, `bundleId`, `tier`, `durationDays`, `offerId`, `promoCode`, `includeFriday`, and `fridayDays` where applicable. Map `basePlanPrice`, Friday add-on, gross amount, each discount, wallet credit, `finalCustomerPrice`, currency, and service day counts.
- [ ] Show server preview on the existing summary/payment UI. Request a new quote when package, tier, duration, Friday setting, selected offer, or code changes. Disable pay while quote inputs differ from displayed quote.
- [ ] Extend existing atomic POST `/subscriptions/checkout` DTO/entity/mapping with `offerId` and v2 `idempotencyKey` while preserving current required selection fields. Generate a key once per payment attempt; reuse it for retry of the same request, and create a new key only when the purchase inputs change.
- [ ] Use checkout `finalPrice` and `paymentUrl`. Handle backend full discount rejection and capacity changes through `lib/core/errors`. Do not infer whether a `0.050 KWD` quote can settle; follow the backend response and keep payment blocked on an explicit backend rejection.
- [ ] Reuse current WebView and GET `/subscriptions/{id}/payment` verification. On paid status, load GET `/subscriptions/{id}/confirmation` and show server receipt, applied discount, and referral share values. Preserve pending/failed/cancelled behavior and do not mark paid from callback alone.
- [ ] Test preview math as *mapping only* (60 - 15 - 5 yields server `40.000`), checkout DTO JSON, idempotent retry, pending-to-paid verification, failed payment, and changed quote before checkout.

## Task 6: Customer wallet and referrals

**Files:** Extend `lib/features/wallet/` with existing-layer data/domain/manager files, `lib/features/offers/` hub/referral state, `lib/core/network/*`; test wallet/referral DTOs and ViewModels.

- [ ] Integrate GET `/wallet`, GET `/wallet/transactions?walletType=promotional|cash&page=&pageSize=`, and GET `/referrals/summary` with nullable DTOs and explicit mappers. Keep cash and promotional balances separate; display total balance only as returned by backend.
- [ ] Replace use of `WalletFakeDataSource` in wallet balance and transaction screens after equivalent real data is wired. Do not remove its usages in refund screens until those behaviors have a real supported source; keep refund functionality scoped to documented APIs.
- [ ] Wire referral code, reward percentage/counts, earned credits, message, and share URL into the existing offers hub. Use the existing share mechanism if present; add a package only if the project truly lacks one and project rules allow it.
- [ ] Test paged ledger append and refresh, empty ledger, separate wallet types, referral policy absent, and error-with-stale-data behavior.

## Task 7: Integration verification and cleanup

- [ ] Run `dart run build_runner build --delete-conflicting-outputs` after changing Retrofit/JSON DTOs. Review generated diff for only intended endpoint/model changes.
- [ ] Run targeted `flutter test` for tasks 1–6, then `flutter analyze` on touched areas; fix reported regressions.
- [ ] Run a manual Android/iOS smoke flow with a real test account: browse offer → details → select package → preview → checkout → payment status → confirmation; repeat with code only and with both offer and code. Compare displayed preview, checkout `finalPrice`, and gateway amount.
- [ ] Verify saved offers/reminders, wallet and referral screens, Arabic/English messages, empty states, pending payment, expiry, and server errors. Confirm no old mock offer/wallet business values appear in completed paths.
- [ ] Review `git diff` to exclude existing unrelated family checkout edits. Commit only scoped implementation and tests in reviewable slices.

## Spec notes to verify against live responses

- The v2 text states GET `/offers/available`, whereas the current mobile code uses POST. Implement v2 only after confirming the deployed route; treat any failure as a backend contract discrepancy, not a reason to silently retain fake data.
- The v2 error example has `code/message/errors`; its table names Arabic/English messages. The shared error mapper already supports optional localized fields. Keep parsing both forms.
- The v2 model snippets are examples, not the repository architecture. Their non-null assertions and `lib/models/offers/` placement should not be copied into this project's data layer.
