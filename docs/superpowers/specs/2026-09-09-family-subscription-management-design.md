# Family Subscription Management Design

## Goal

Connect the existing family subscription management screens to the documented backend contracts without redesigning the UI or duplicating the existing calendar subsystem.

## Architecture

Family home, member list, member details, access, and permissions live in `features/subscription_settings` and follow the project's feature-based clean architecture. Response DTOs remain nullable, mappers produce domain entities, repositories wrap remote calls with `safeApiCall`, and injectable view models expose entities and failures to the existing screens.

Calendar, day details, restaurants, and meals reuse `features/calendar`. Family navigation passes the selected member's `memberSubscriptionId` as `subscriptionId`; no family-specific calendar network stack is introduced.

## Contracts

- Home: `GET /api/v1/customer/family/home`.
- Members: `GET /api/v1/customer/family/members`; search is local; add-member opens the checkout flow.
- Member details: `GET /api/v1/customer/family/members/{memberId}`; renewal uses the server-provided path.
- Access: GET/PUT `/api/v1/customer/family/members/{memberId}/access`; generated passwords are shown once and never persisted or logged.
- Permissions: GET/PUT `/api/v1/customer/family/members/{memberId}/permissions`; render `groups`, but PUT all eight root booleans.
- Calendar/day/restaurants/meals use the existing subscription endpoints and `memberSubscriptionId`.
- Meal selection does not call complete or auto-select. The review contract is not guessed because `10-review-confirm.md` was not supplied.

## Error handling

Backend business codes are localized centrally through the existing error presenter/mapping flow. They are not added as HTTP-level `ApiErrorType` values and are not hardcoded in screens.

## UI constraints

Existing screens, widgets, routes, theme tokens, spacing, localization, and RTL/LTR behavior are preserved. Fake sources are removed from a screen only after its backend-backed state replaces every required use.

## Verification

Use test-first contract, mapper, view-model, navigation, and error-localization tests. Regenerate Retrofit/JSON/Injectable outputs, format changed Dart files, run focused tests, then run `flutter analyze` and the relevant suite.
