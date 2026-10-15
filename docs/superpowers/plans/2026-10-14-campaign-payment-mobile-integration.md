# Campaign Payment Mobile Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate campaign checkout payment in the Flutter app from the existing campaign checkout session through provider payment, deep-link return, authoritative status polling, and existing success/failure UI.

**Architecture:** Extend the existing `offers` feature and shared payment/deep-link infrastructure. Keep the required clean-architecture flow `UI → Event → ViewModel → UseCase → Repository → RemoteDataSource → ApiServices`, map defensive DTOs into domain entities, and reuse existing payment WebView/browser and terminal result screens wherever their contracts allow it.

**Tech Stack:** Flutter, Dart, Retrofit, Dio, `ApiResult`, `safeApiCall`, Injectable/GetIt, Flutter Bloc/Cubit, JSON serialization, existing localization/theme/routing/deep-link infrastructure.

**Spec:** Campaign payment mobile integration contract supplied by the user and the advertising/coupons handoff files in `advertising-coupons-screens/`.

## Global Constraints

- Follow `rules/ui_rules.md` and `rules/rules_backend.md`.
- Preserve the existing feature-based clean architecture and state-management patterns.
- Reuse existing payment, WebView/browser, deep-link, error, localization, styles, colors, spacing, and widgets before creating new ones.
- Do not manually edit generated `*.g.dart` or `di.config.dart` files.
- Do not call the provider webhook from the mobile app.
- Never treat a callback query parameter as proof of payment; `GET /api/v1/customer/campaigns/{sessionId}/payment` is authoritative.
- Do not calculate or mutate server prices locally.
- Keep all API response DTO fields defensive/nullable; request DTO required fields must match the contract.
- Do not add packages or create a second Dio/Retrofit client.
- Do not hardcode user-facing strings, colors, dimensions, or spacing.
- Preserve RTL/LTR through inherited `Directionality`; do not branch on a language code.

## Existing Code To Reuse

- Existing campaign session path in `lib/features/offers/`:
  `campaign_session_entity.dart`, campaign session request/response DTOs, mapper, remote data source, repository, and `create_campaign_checkout_session_usecase.dart`.
- Existing shared network client and generated Retrofit service in `lib/core/network/api_services.dart`.
- Existing payment flow in `lib/features/payment/`, including `payment_screen.dart`, `payment_web_view_screen.dart`, `payment_success_screen.dart`, `payment_failed_screen.dart`, payment entities/arguments, and payment ViewModel patterns.
- Existing deep-link coordinator in `lib/core/payment/payment_deep_link_coordinator.dart`.
- Existing routes in `lib/config/routing/app_routes.dart` and `lib/config/routing/routing_generator.dart`.
- Existing error widgets under `lib/core/errors/`.
- Existing Arabic/English ARB files under `lib/core/l10n/`.

## Target API Contract

### Existing session creation

Use the existing campaign checkout session endpoint and preserve its returned `sessionId`. The session reserves campaign capacity for 15 minutes. A repeated request with the same idempotency key and identical payload returns the stored result; the same key with a different payload is a conflict.

### Start campaign payment

```http
POST /api/v1/customer/campaigns/{sessionId}/payment
Authorization: Bearer {CUSTOMER_ACCESS_TOKEN}
Content-Type: application/json
```

```json
{
  "idempotencyKey": "mobile-generated-stable-key",
  "callbackUrl": "mealmate://campaign-payment/callback",
  "errorUrl": "mealmate://campaign-payment/error",
  "paymentMethodId": 3
}
```

Response fields:

```json
{
  "sessionId": "...",
  "paymentId": "pz-...",
  "paymentUrl": "https://...",
  "amount": 12.500,
  "currency": "KWD",
  "status": "Pending",
  "expiresAtUtc": "..."
}
```

### Read campaign payment status

```http
GET /api/v1/customer/campaigns/{sessionId}/payment
Authorization: Bearer {CUSTOMER_ACCESS_TOKEN}
```

Response fields:

```json
{
  "sessionId": "...",
  "paymentId": "pz-...",
  "status": "Paid",
  "isPaid": true,
  "isFailed": false,
  "amount": 12.500,
  "currency": "KWD",
  "expiresAtUtc": "...",
  "subscriptionId": "..."
}
```

Terminal statuses are `Paid`, `Failed`, `Expired`, and `Cancelled`; `Pending` is polled with bounded exponential backoff. Common API errors are `404` ownership/not found, `409` expired session or idempotency conflict, `422` invalid quote/URL/contact, and `503` provider initialization/status unavailable. Preserve the server error code for localized UI copy.

## File Map

### Files to modify

- `lib/core/network/api_services.dart` — add the two campaign payment Retrofit methods with exact HTTP paths, `@Path`, body, and response DTOs.
- `lib/features/offers/data/data_source/offers_remote_data_source.dart` and `_impl.dart` — expose and delegate start-payment and status calls.
- `lib/features/offers/domain/repo/offers_repository.dart` and `lib/features/offers/data/repo/offers_repository_impl.dart` — expose `ApiResult` operations and map DTOs through `safeApiCall`.
- `lib/features/offers/data/mapper/offer_mapper.dart` or a focused campaign payment mapper — map nullable response DTOs to domain entities without leaking DTOs.
- `lib/features/offers/domain/entities/campaign_session_entity.dart` — retain `sessionId` and add only campaign payment data required by the UI if the existing entity cannot carry it.
- `lib/features/offers/presentation/manager/offers_event.dart`, `offers_state.dart`, and `offers_view_model.dart` — add campaign payment intents/state only if the current manager is the established owner of this flow; otherwise create a focused campaign payment manager following the same pattern.
- `lib/features/offer_details/presentation/screens/offer_details_screen.dart` and/or the existing campaign entry screen — pass the campaign ID/bundle/duration/context into the existing checkout-session flow.
- `lib/features/payment/presentation/screens/payment_web_view_screen.dart` and payment argument models only if they require a campaign-specific session/payment identity to return safely.
- `lib/core/payment/payment_deep_link_coordinator.dart` — recognize `mealmate://campaign-payment/callback` and `/error`, preserve `sessionId`/`paymentId`/optional status, and route to authoritative status handling.
- `lib/config/routing/app_routes.dart` and `lib/config/routing/routing_generator.dart` — add only the minimum campaign checkout/payment/result routes if existing routes cannot represent the flow.
- `lib/core/l10n/app_ar.arb` and `lib/core/l10n/app_en.arb` — add campaign payment statuses, actions, and server-error-code messages.
- Existing payment result argument/adapter files — only if the current success/failure screens need a campaign-specific adapter; do not fork the screens unnecessarily.

### Files to create only when existing equivalents are insufficient

- `lib/features/offers/data/models/request/start_campaign_payment_request_dto.dart`
- `lib/features/offers/data/models/response/campaign_payment_response_dto.dart`
- `lib/features/offers/domain/entities/campaign_payment_entity.dart`
- `lib/features/offers/domain/entities/start_campaign_payment_request_entity.dart`
- `lib/features/offers/data/mapper/campaign_payment_mapper.dart`
- `lib/features/offers/domain/usecase/start_campaign_payment_usecase.dart`
- `lib/features/offers/domain/usecase/get_campaign_payment_status_usecase.dart`
- `lib/features/offers/presentation/manager/campaign_payment_event.dart`
- `lib/features/offers/presentation/manager/campaign_payment_state.dart`
- `lib/features/offers/presentation/manager/campaign_payment_view_model.dart`
- `lib/features/offers/presentation/screens/campaign_checkout_screen.dart` — only if no existing screen can display the campaign quote/session action.
- `lib/features/offers/presentation/screens/campaign_payment_screen.dart` — only if the existing payment screen cannot accept a campaign payment intent.
- `lib/features/offers/presentation/screens/campaign_payment_result_screen.dart` — only if the existing result screens cannot represent pending polling and campaign-specific routing.
- Feature-specific widgets under `lib/features/offers/presentation/widgets/` only for real reusable campaign components; one widget class per file.

## Implementation Tasks

### Task 1: Inspect and lock the existing flow

**Files:** Read-only inspection of the existing files listed above.

- [ ] Trace the current `create_campaign_checkout_session` flow from entry screen through ViewModel, UseCase, repository, data source, and `ApiServices`.
- [ ] Trace the existing payment start, WebView/browser, return, status polling, success, and failure flows.
- [ ] Confirm whether the existing payment screens accept generic payment arguments or are tied to subscription IDs.
- [ ] Confirm how deep links are parsed and how duplicate callbacks are prevented.
- [ ] Confirm generated Retrofit/Injectable conventions and current test fixtures before adding types.
- [ ] Record the smallest reuse path; do not create the three named campaign screens if existing screens can safely cover their roles.

### Task 2: Add defensive API contracts

**Files:** `api_services.dart`, new/updated request and response DTOs.

- [ ] Add `startCampaignPayment(sessionId, request)` for `POST /api/v1/customer/campaigns/{sessionId}/payment`.
- [ ] Add `getCampaignPaymentStatus(sessionId)` for `GET /api/v1/customer/campaigns/{sessionId}/payment`.
- [ ] Match JSON names and numeric types exactly; preserve decimal amount and currency from the server.
- [ ] Make response fields nullable/defensive, including optional `paymentId`, `expiresAtUtc`, and `subscriptionId`.
- [ ] Keep request fields required/optional exactly as specified: stable `idempotencyKey`, `callbackUrl`, `errorUrl`, optional `paymentMethodId` defaulting to 3.
- [ ] Add DTO serialization tests for full, pending, terminal, and partially missing responses.
- [ ] Run build_runner after annotations are complete; never edit generated files manually.

### Task 3: Connect data and domain layers

**Files:** remote data source, repository, mapper, entities, UseCases.

- [ ] Add remote data source methods that only call `ApiServices` and do not navigate or show UI feedback.
- [ ] Add repository methods returning `ApiResult<CampaignPaymentEntity>` and use `safeApiCall`.
- [ ] Map status strings into a domain-safe status representation while preserving unknown server values for diagnostics/localized fallback.
- [ ] Add `StartCampaignPaymentUseCase` and `GetCampaignPaymentStatusUseCase` with constructor injection.
- [ ] Keep DTOs out of the domain and presentation layers.
- [ ] Add mapper/repository tests for success, missing optional values, and propagated typed failures.

### Task 4: Model campaign payment state and idempotency

**Files:** existing or new campaign payment event/state/ViewModel files.

- [ ] Add intents for start payment, handle return, read status, poll status, retry start, and clear/finish flow.
- [ ] Store `sessionId`, `paymentId`, amount, currency, expiry, optional subscription ID, status, failure, and loading flags in immutable state.
- [ ] Generate one stable idempotency key per logical start-payment attempt and persist it across retry of the same request; generate a new key only for a genuinely new attempt.
- [ ] Ensure repeated taps cannot start parallel requests.
- [ ] Implement bounded exponential backoff for `Pending`, with cancellation when the ViewModel is disposed or a terminal status arrives.
- [ ] Stop polling on `Paid`, `Failed`, `Expired`, `Cancelled`, `404`, `409`, or a non-retryable validation error.
- [ ] Preserve the server error code in state so localization maps codes rather than displaying raw diagnostics.
- [ ] Test state transitions, duplicate tap protection, idempotency-key reuse, polling stop conditions, and disposal cancellation.

### Task 5: Implement campaign checkout UI

**Files:** existing campaign entry/checkout screen or `campaign_checkout_screen.dart` plus feature widgets only if required.

- [ ] Display campaign name, selected bundle, duration, requested service dates, delivery governorate/address, final customer price, currency, eligibility, and ineligibility reasons from server data.
- [ ] Use the existing checkout/session creation action and preserve the returned `sessionId`.
- [ ] Show loading, empty/invalid quote, ineligible, capacity full, expired session, network error, and retry states using existing loaders/error widgets and localized copy.
- [ ] Disable the action while submitting and prevent accidental duplicate session creation.
- [ ] Keep dates as server `DateOnly` values and do not recalculate price or capacity locally.
- [ ] Navigate to payment using the created session only after a successful server response.

### Task 6: Implement campaign payment UI using existing payment surfaces

**Files:** existing payment screen/WebView route or `campaign_payment_screen.dart` only if necessary.

- [ ] Display amount and currency from the start-payment response.
- [ ] Submit the exact request with callback/error URLs and selected payment method.
- [ ] Open the returned `paymentUrl` in the existing system browser or in-app WebView mechanism.
- [ ] Never call or expose the webhook from Flutter.
- [ ] Handle `409` idempotency conflict versus expired session distinctly, and handle `422` and `503` with localized server-code copy.
- [ ] Persist enough flow context (`sessionId`, `paymentId`, idempotency key) to recover after app pause/close according to existing payment persistence patterns.

### Task 7: Implement return, status polling, and terminal routing

**Files:** `payment_deep_link_coordinator.dart`, routing files, existing/new result screen and result adapter.

- [ ] Register/recognize `mealmate://campaign-payment/callback` and `mealmate://campaign-payment/error`.
- [ ] Parse `sessionId`, `paymentId`, and optional callback `status` only as hints; always issue `GET /campaigns/{sessionId}/payment`.
- [ ] Show a pending state while status is pending and poll with bounded backoff.
- [ ] Treat only an API response with `status == Paid`/`isPaid == true` as authoritative success.
- [ ] Route `Paid` into the existing success screen with campaign amount/currency/subscription data where supported.
- [ ] Route `Failed`, `Expired`, and `Cancelled` into the existing failure/status UI with retry/back navigation appropriate to the campaign session.
- [ ] Handle missing/invalid deep-link parameters without crashing; offer a recovery action that reloads the persisted session.
- [ ] Prevent duplicate callback handling and duplicate status requests during one return event.

### Task 8: Localization, accessibility, and visual compliance

**Files:** Arabic/English ARB files, generated localization output, campaign widgets/screens.

- [ ] Add localized labels for campaign checkout/payment, each terminal status, pending polling, retry, expired session, capacity conflict, idempotency conflict, invalid quote/URL/contact, and provider unavailable.
- [ ] Map server error codes to localized copy; never show raw server exception text.
- [ ] Add semantic labels for payment status, amount/currency, campaign identity, and actionable buttons.
- [ ] Use existing theme colors, text styles, spacing constants, and directional paddings.
- [ ] Validate both RTL and LTR with inherited `Directionality`; do not use language-code checks.
- [ ] Regenerate localization output through the project’s existing command.

### Task 9: Tests and verification

**Files:** tests beside existing offers/payment/deep-link tests; no production test fakes beyond existing patterns.

- [ ] Unit-test request DTO JSON and response DTO parsing.
- [ ] Unit-test mapper status handling and nullable fields.
- [ ] Repository tests for successful start/status calls and typed failures for 404/409/422/503.
- [ ] ViewModel tests for start-payment success, duplicate tap suppression, stable idempotency key, pending polling, terminal stop, and retry.
- [ ] Deep-link tests proving callback status is ignored as authority and status API is always called.
- [ ] UI tests for loading, pending, paid, failed, expired, cancelled, and localized server-code error states.
- [ ] Test that the webhook URL is never invoked by mobile code.
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`.
- [ ] Run `dart format` on changed Dart files.
- [ ] Run focused Flutter tests, then `flutter analyze`.
- [ ] Run `git diff --check` and confirm only requested files changed.

## Acceptance Criteria

- A customer can create a campaign checkout session and retain its `sessionId`.
- A customer can start payment with stable idempotency behavior and receive/open `paymentUrl`.
- The app never calls the payment webhook.
- Returning from the provider always triggers authenticated status lookup.
- Pending status polls with backoff and stops on every terminal state.
- Only server-confirmed `Paid` reaches the success UI.
- 404/409/422/503 errors preserve codes and display localized copy.
- Existing payment success/failure surfaces are reused where compatible; no duplicate screens are created without a verified need.
- Arabic/English, RTL/LTR, loading, retry, expiry, and accessibility behavior follow project rules.
- Generated code is current, formatting/analyzer/tests pass, and no unrelated files are modified.

## Self-Review Checklist

- [ ] Every API field and endpoint in the supplied contract appears in a task.
- [ ] Callback URLs, deep links, webhook boundary, and authoritative status rule are covered.
- [ ] Idempotency semantics and all documented status/error codes are covered.
- [ ] Existing success/failure/payment UI reuse is explicitly checked before creating pages.
- [ ] No placeholder implementation or invented backend field remains.
- [ ] The plan preserves the project’s UI and backend rules.
