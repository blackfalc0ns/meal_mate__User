# Family Allergies, Addresses, and Checkout Design

## Scope

Complete the family subscription flow after each selected member has a full plan:

`program -> bundle/duration/tier -> allergies -> address -> checkout -> payment WebView`

Only members in the current payment basket participate. A basket member has a complete plan and no `memberSubscriptionId`. Existing active/prepaid members and family members without a complete plan are excluded.

## Architecture

Preserve the existing feature-based clean architecture and shared networking infrastructure. Add family-specific allergy and address operations because their API owner is a linked family member, while reusing individual DTOs, domain entities, catalog use cases, map widgets, and address form widgets where their contracts are identical.

Do not change individual food-preference or address behavior. Do not create a family dietary-preference step. Rejected ingredients remain optional and do not gate navigation.

## Basket Membership

Expose one domain-safe basket predicate for a family member:

- `memberSubscriptionId` is absent.
- `programId`, `bundleId`, `selectedTier`, and a positive `durationDays` are present.

The program screen may leave members without a plan for a later purchase. The package screen and all later steps operate only on basket members. Every later request uses the selected member's actual `memberId`.

## Family Allergies

Create a `family_allergies` feature with Event/ViewModel/UseCase/Repository/RemoteDataSource layers.

- Load chips through the existing customer allergy catalog endpoint.
- Save through `PUT /api/v1/customer/family-subscription-flow/members/{memberId}/allergies`.
- Use a family request DTO containing only `code` and optional `severity`.
- Send `[{"code":"NONE"}]` when the member has no allergies; never convert it to an empty list.
- Treat the response body as `bool`; only `true` marks the member complete locally.
- Require a successful save for every basket member before continuing.
- Provide no Skip action.

The screen shows the basket-member strip, allergy chips, the no-allergy option, and the next action. Optional rejected-ingredient search may be omitted because it does not affect checkout and no linked-account family endpoint is supplied.

## Family Addresses

Create a `family_addresses` feature whose data layer adds `memberId` to the existing address operations:

- list member addresses;
- create and update an address;
- preview new and existing address coverage;
- set the default address.

Reuse `CustomerAddressRequestDto`, `CustomerAddressResponseDto`, `AddressCoveragePreviewRequestDto`, their domain entities/mappers, the location catalog, geocoding operations, and existing map/manual-entry components. The remote data source calls only the documented family endpoints for member-owned address data.

The screen iterates over basket members. A member is complete after a successful save/default selection with acceptable coverage. Uncovered preview results remain visible and block checkout. After the last member is complete, navigate to family checkout.

## Family Checkout

Extend the current family checkout contract without replacing its UI:

- Map `familyGroupId`, `familyName`, `checkoutEndpoint`, and English tier labels in addition to existing fields.
- Continue displaying `finalPrice` from the summary as the source of truth.
- Request payment methods with that exact positive `finalPrice`.
- Add `correlationId` to the checkout request and keep it stable for one payment attempt.
- Preserve manager-prepaid and new-member subtotal behavior.
- Open the returned `paymentUrl` through the existing payment WebView flow.

Map checkout blockers to the owning step:

- `family.allergies_required` -> family allergies;
- `family.member_incomplete` -> program/package completion;
- address-required or coverage blockers -> family addresses;
- `family.not_draft` -> prevent a duplicate checkout and refresh state;
- invalid amount -> keep checkout disabled and show the backend error.

On `payment.initialization_failed`, show the mapped error and reload the summary. Do not turn an active family back into a draft.

## State and Navigation

Each step owns its loading, per-member completion, selected-member index, and failure state. Navigation is enabled only after the required server mutation succeeds. Optimistic selections may be displayed, but cannot unlock the next step until confirmed.

Correct family status semantics everywhere:

- `1`: Draft
- `2`: CheckoutPending
- `3`: Active

## Error Handling

Use `safeApiCall`, `ApiResult`, the existing Dio instance, and the central problem-details mapper. Preserve backend error codes so the UI can route actionable failures. Add localized messages only for codes that do not already have a user-facing mapping.

## Testing

Use test-first development for:

- basket-member eligibility;
- family allergy request serialization, including `NONE` and severity;
- all family address endpoint paths and member IDs;
- reuse of map and manual address request serialization;
- summary additions and checkout `correlationId` serialization;
- blocker-to-route mapping;
- per-member completion and navigation gates;
- Active status value `3` in every affected ViewModel.

Regenerate JSON, Retrofit, localization, and injectable outputs. Run focused family tests, `flutter analyze`, and the full test suite; report unrelated pre-existing failures separately.

## Out of Scope

- Family dietary-preference screens.
- Required rejected-ingredient completion.
- Changes to backend price calculations.
- New payment verification semantics beyond the existing individual payment flow.
