# Family Subscription Flow Endpoint & Method Audit

## Overview
This audit inspects all API endpoints, Retrofit declarations, remote data sources, repositories, and use cases in the Family Subscription Flow (`meal_mate__User`).

## Endpoint Audit & Classification Matrix

| Endpoint / Method | Remote Data Source | Repository | Use Case / Caller | Classification | Status & Verification |
|---|---|---|---|---|---|
| `GET /api/v1/customer/family-subscription-flow/packages` | `FamilyPackagesRemoteDataSource` | `FamilyPackagesRepository` | `GetFamilyPackagesUseCase` -> `FamilyPackagesViewModel` | `through-remote-source` | Active; verified in `family_packages` |
| `GET /api/v1/customer/family-subscription-flow/current` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `GetFamilyFlowCurrentUseCase` -> coordinator & setup VM | `through-remote-source` | Active; verified in coordinator tests |
| `GET /api/v1/customer/family-subscription-flow/metadata` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `GetFamilyFlowMetadataUseCase` | `through-remote-source` | Active contract; metadata schema validated |
| `GET /api/v1/customer/family-subscription-flow/relationships` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `GetFamilyRelationshipsUseCase` -> `FamilyAddMemberDialog` | `through-remote-source` | Active; populates relationship dropdown |
| `GET /api/v1/customer/family-subscription-flow/members/lookup` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `LookupFamilyMemberUseCase` -> `FamilySubscriptionSetupViewModel` | `through-remote-source` | Active; phone lookup with debouncing/guard |
| `POST /api/v1/customer/family-subscription-flow/members` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `AddFamilyMemberUseCase` -> `FamilySubscriptionSetupViewModel` | `through-remote-source` | Active; adds member with relationship & role |
| `PUT /api/v1/customer/family-subscription-flow/members/{memberId}` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `UpdateFamilyMemberUseCase` -> `FamilySubscriptionSetupViewModel` | `through-remote-source` | Active; updates member details & subscribeNow |
| `DELETE /api/v1/customer/family-subscription-flow/members/{memberId}` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `DeleteFamilyMemberUseCase` -> `FamilySubscriptionSetupViewModel` | `through-remote-source` | Active; removes member with manager protection |
| `POST /api/v1/customer/family-subscription-flow/abandon-draft` | `FamilySubscriptionSetupRemoteDataSource` | `FamilySubscriptionSetupRepository` | `AbandonFamilyDraftUseCase` -> `FamilySubscriptionSetupViewModel` | `through-remote-source` | Active; explicit draft abandon & cache clear |
| `GET /api/v1/customer/family-subscription-flow/programs` | `FamilyProgramsRemoteDataSource` | `FamilyProgramsRepository` | `GetFamilyProgramsUseCase` -> `FamilyProgramsViewModel` | `through-remote-source` | Active; loads programs for family packages |
| `GET /api/v1/customer/family-subscription-flow/programs/{programId}/bundles` | `FamilyProgramsRemoteDataSource` | `FamilyProgramsRepository` | `GetFamilyProgramBundlesUseCase` -> `FamilyPackageDaysViewModel` | `through-remote-source` | Active; loads bundles for selected program |
| `PATCH /api/v1/customer/family-subscription-flow/members/{memberId}/plan` | `FamilyPackageDaysRemoteDataSource` | `FamilyPackageDaysRepository` | `SaveFamilyMemberPlanUseCase` -> `FamilyPackageDaysViewModel` | `through-remote-source` | Active; saves program, bundle, tier, days |
| `GET /api/v1/customer/family-subscription-flow/members/{memberId}/addresses` | `FamilyAddressesRemoteDataSource` | `FamilyAddressesRepository` | `GetFamilyMemberAddressesUseCase` -> `FamilyAddressesViewModel` | `through-remote-source` | Active; fetches member addresses |
| `POST /api/v1/customer/family-subscription-flow/members/{memberId}/addresses` | `FamilyAddressesRemoteDataSource` | `FamilyAddressesRepository` | `AddFamilyMemberAddressUseCase` -> `FamilyAddressesViewModel` | `through-remote-source` | Active; assigns address to family member |
| `GET /api/v1/customer/family-subscription-flow/allergies` | `FamilyAllergiesRemoteDataSource` | `FamilyAllergiesRepository` | `GetFamilyAllergiesCatalogUseCase` -> `FamilyAllergiesViewModel` | `through-remote-source` | Active; allergen catalog |
| `PUT /api/v1/customer/family-subscription-flow/members/{memberId}/allergies` | `FamilyAllergiesRemoteDataSource` | `FamilyAllergiesRepository` | `SaveFamilyMemberAllergiesUseCase` -> `FamilyAllergiesViewModel` | `through-remote-source` | Active; saves allergies with NONE fallback |
| `PUT /api/v1/customer/family-subscription-flow/members/{memberId}/disliked-ingredients` | `FamilyAllergiesRemoteDataSource` | `FamilyAllergiesRepository` | `SaveFamilyMemberDislikedIngredientsUseCase` -> `FamilyAllergiesViewModel` | `through-remote-source` | Active; saves disliked ingredients |
| `PUT /api/v1/customer/family-subscription-flow/members/{memberId}/checkout-selection` | `FamilyCheckoutRemoteDataSource` | `FamilyCheckoutRepository` | `SelectFamilyMemberCheckoutUseCase` -> `FamilyCheckoutViewModel` | `through-remote-source` | Active; toggle member participation |
| `PUT /api/v1/customer/family-subscription-flow/members/{memberId}/start-date` | `FamilyCheckoutRemoteDataSource` | `FamilyCheckoutRepository` | `SaveFamilyMemberStartDateUseCase` -> `FamilyCheckoutViewModel` | `through-remote-source` | Active; updates member start date |
| `GET /api/v1/customer/family-subscription-flow/summary` | `FamilyCheckoutRemoteDataSource` | `FamilyCheckoutRepository` | `GetFamilySummaryUseCase` -> `FamilyCheckoutViewModel` | `through-remote-source` | Active; invoice & quote calculation |
| `GET /api/v1/customer/family-subscription-flow/payment-methods` | `FamilyCheckoutRemoteDataSource` | `FamilyCheckoutRepository` | `GetFamilyPaymentMethodsUseCase` -> `FamilyCheckoutViewModel` | `through-remote-source` | Active; retrieves available gateways for amount |
| `POST /api/v1/customer/family-subscription-flow/checkout` | `FamilyCheckoutRemoteDataSource` | `FamilyCheckoutRepository` | `CheckoutFamilySubscriptionUseCase` -> `FamilyCheckoutViewModel` | `through-remote-source` | Active; submits family checkout session |
| `POST /api/v1/customer/family-subscription-flow/retry-payment` | `FamilyCheckoutRemoteDataSource` | `FamilyCheckoutRepository` | `RetryFamilySubscriptionPaymentUseCase` -> `FamilyCheckoutViewModel` | `through-remote-source` | Active; retries payment without new batch |
| `POST /api/v1/customer/family-subscription-flow/renewals/{renewalRequestId}/checkout` | `FamilyCheckoutRemoteDataSource` | `FamilyCheckoutRepository` | `SubmitFamilyRenewalCheckoutUseCase` | `renewal-only` | Active renewal contract; tested in contract suite |
| `GET /api/v1/customer/subscriptions/calendar/restaurants` | `FamilyPackageDaysRemoteDataSource` | `FamilyPackageDaysRepository` | `GetSubscriptionTierRestaurantsUseCase` | `through-remote-source` | Active; browse tier restaurants |
| `GET /api/v1/customer/regions` / country regions | `AddressesRemoteDataSource` | `AddressesRepository` | `GetCountryRegionsUseCase` | `through-remote-source` | Active address dependency |

## Audit Conclusions
1. **Zero Endpoint Deletions:** No declared Retrofit endpoints or API constants were deleted. Every method corresponds to an active or renewal contract verified by unit/contract tests.
2. **Backward Compatibility:** All payload structures preserve nullable fields and server contract versions (e.g. `clientContractVersion = 1`).
3. **Idempotency & Versioning:** `batchId`, `batchVersion`, and idempotent keys are tracked for checkout, retry, and renewal flows without duplicate batch generation.
