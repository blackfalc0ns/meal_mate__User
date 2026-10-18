# MealMate Mobile Backend Contract v3.1 Specification & Inventory

## 1. Overview & Version
- **Contract Version:** 3.1
- **Status:** Integrated & Frozen
- **Target App:** `meal_mate__User` (Customer Flutter Mobile)
- **Base Architecture:** Clean Architecture (Core + Features)
- **Currency:** `KWD` (3 decimal places, strictly server-authoritative)
- **Timezone:** UTC (`ISO-8601`), `serverNowUtc` drives countdowns and expiry windows.

## 2. Route Matrix & Flow Separation
Individual and Family subscription flows must remain strictly separated. No individual endpoint may be called from within a family flow.

### Individual Routes (`/api/v1/customer/subscription-flow/...` & `/customer/subscriptions/...`)
| Purpose | Method & Path | Query / Body Params | Notes |
|---|---|---|---|
| Types | `GET /types` | - | Available vs disabledReason |
| Prerequisites | `GET /prerequisites` | - | missingStep, actionEndpoint |
| Catalog Programs | `GET /catalog/programs` | `page`, `pageSize` | `addressCoverage`, `hasDeliveryAddress` |
| Legacy Programs | `GET /programs` | `page`, `pageSize` | Backward compatible |
| Catalog Bundles | `GET /catalog/programs/{programId}/bundles` | `page`, `pageSize` | Options with availability |
| Durations | `GET /programs/{programId}/bundles/{bundleId}/durations` | `includeFriday` | Server durations & Friday availability |
| Catalog Tiers | `GET /catalog/programs/{programId}/bundles/{bundleId}/tiers` | `durationDays`, `startDate`, `includeFriday`, `page`, `pageSize` | Availability per tier, theme design |
| Restaurant Availability | `GET /restaurant-availability` | `programId`, `bundleId`, `tier`, `durationDays`, `startDate`, `includeFriday` | Full period verification |
| Readiness | `GET /readiness` | Same as summary | `canOpenSummary`, `canCheckout`, `checkoutBlockReason` |
| Summary | `GET /summary` | IDs, `durationDays`, `startDate`, `includeFriday`, `promoCode`, `restaurantsPage`, `restaurantsPageSize` | Price breakdown, coupon evaluation, `summaryExpiresAtUtc` |
| Payment Methods | `GET /payment-methods` | `amount={finalPrice}` | Gateway fees and providers |
| Checkout | `POST /api/v1/customer/subscriptions/checkout` | Body: selections, `callbackUrl`, `errorUrl`, `paymentMethodId`, `promoCode`, `idempotencyKey`, `correlationId` | Server verifies and locks price |
| Payment Status | `GET /api/v1/customer/subscriptions/{subscriptionId}/payment` | - | Bounded polling; terminal states: Paid, Failed, Expired, Cancelled |
| Resume Preview | `GET /api/v1/customer/subscriptions/{subscriptionId}/resume` | - | Can pay directly, suggested start date |
| Resume Execute | `POST /api/v1/customer/subscriptions/{subscriptionId}/resume` | Body | Executes resume attempt |

### Family Routes (`/api/v1/customer/family-subscription-flow/...`)
| Purpose | Method & Path | Notes |
|---|---|---|
| Packages | `GET /packages` | Family package list |
| Current | `GET /current` | Current draft or active family group |
| Members | `GET /members` | All members and basket status |
| Member Plan | `PUT /members/{memberId}/plan` | Assigns plan to member |
| Member Allergies | `PUT /members/{memberId}/allergies` | `[{"code":"NONE"}]` or codes |
| Member Addresses | `GET /members/{memberId}/addresses` | Member address list |
| Member Add Address | `POST /members/{memberId}/addresses` | Add address for member |
| Member Preview Coverage | `POST /members/{memberId}/addresses/preview-coverage` | Preview coverage for member |
| Member Set Default | `POST /members/{memberId}/addresses/{addressId}/set-default` | Set member default address |
| Member Selection | `PUT /members/{memberId}/checkout-selection` | Toggle basket participation |
| Summary | `GET /summary` | Group summary with `batchId`, `batchVersion`, `canCheckout`, `blockingReasons`, promoCode |
| Payment Methods | `GET /payment-methods` | Filtered by finalPrice |
| Checkout | `POST /checkout` | Body: `batchId`, `batchVersion`, `idempotencyKey`, `paymentMethodId`, `promoCode`, `callbackUrl`, `errorUrl` |
| Retry Payment | `POST /retry-payment` | Retry failed payment attempt |

### Advertising & Offers Routes
| Purpose | Method & Path | Notes |
|---|---|---|
| Available Offers | `GET /api/v1/customer/offers/available` | Offers hub |
| Offer Details | `GET /api/v1/customer/offers/{id}` | Offer targets & terms |
| Evaluate Offer | `POST /api/v1/customer/offers/evaluate` | Validation |
| Redeem Offer | `POST /api/v1/customer/offers/redeem` | Conversion |

## 3. Centralized Error Contract (`lib/core/errors`)
- All backend errors map through `ApiExceptionMapper` and `FailureMapper`.
- Error structure: `statusCode`, `code`, `field`, `messageAr`, `messageEn`, `advice`.
- `advice` contains:
  - `retryable`: bool
  - `refreshSummaryRequired`: bool
  - `refreshAvailabilityRequired`: bool
- Specific codes preserved:
  - `checkout.capacity_hold_expired`
  - `family.coupon_rejected`
  - `family.coupon_context_unavailable`
  - `checkout.address_required`
  - `family.address_required`
  - `allergies_required`
  - `dietary_preferences_required`
  - `no_restaurants_for_address`
  - `no_restaurants_for_selection`
  - `calendar.no_safe_box`

## 4. Money & Precision
- Authoritative currency: `KWD`.
- Precision: 3 decimal places (e.g. `12.500`).
- No device-calculated discounts or final amounts.
- `subtotal = basePrice`.
- `discount = campaignDiscount + promoDiscount` (never add coupon discount twice).
