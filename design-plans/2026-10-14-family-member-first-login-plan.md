# Family Member First Login - Implementation Plan

## Goal

Integrate the family-member first-login contract into the existing Flutter app while preserving the current feature-based Clean Architecture, the regular customer sign-in UI, the existing family-member access screen, and shared networking, DI, error handling, and logging infrastructure.

## Non-negotiable rules

- Follow `rules/rules_backend.md` and the existing project architecture.
- Reuse the existing `ApiServices`, injected `Dio`, `ApiResult`, `safeApiCall`, Injectable, and error handling.
- Do not create a second Dio client, Retrofit service, logger, or DI mechanism.
- DTOs stay in the data layer; UI and domain use entities.
- Response DTO fields are defensive/nullable; required request fields remain required.
- Do not hardcode the configured OTP value in the client.
- Do not manually edit generated `.g.dart`, Retrofit, or `di.config.dart` files.
- User-facing text comes from localization; existing UI components and theme tokens are reused.

## API contract to implement

### Login

`POST /api/v1/auth/customers/login` keeps the current request. A pending family member returns `nextStep: family_verify_otp`, null tokens, `loginChallengeToken`, and `loginChallengeExpiresAtUtc`. The client must not persist tokens or mark the session authenticated.

### Verify OTP

`POST /api/v1/auth/customers/family-first-login/verify-otp`

```json
{"loginChallengeToken":"<token>","otpCode":"123456"}
```

Success returns `nextStep: family_set_password` plus a new one-time challenge token and expiry.

### Set password

`POST /api/v1/auth/customers/family-first-login/set-password`

```json
{"loginChallengeToken":"<token>","newPassword":"<password>"}
```

Success returns the normal authenticated customer response with access and refresh tokens.

### Family context

`GET /api/v1/customer/family/me` returns an array of contexts containing `groupId`, `isManager`, nullable `memberId`, `memberSubscriptionId`, and capability decisions (`action`, `allowed`, `reasonCode`, `requiredPermission`). An ordinary customer receives `[]`.

### Member access

Existing `PUT /api/v1/customer/family/members/{memberId}/access` gains optional `generateTemporaryPassword`. Send it only when the manager explicitly requests a reset. `generatedPassword` is displayed once, never persisted, and never logged.

## Phase 1: Auth data and domain contracts

Modify:

- `lib/features/auth/data/models/response/login_response_dto.dart`
- `lib/features/auth/data/mapper/login_mapper.dart`
- `lib/features/auth/domain/entities/login_entity.dart`
- `lib/features/auth/domain/repo/auth_repository.dart`
- `lib/features/auth/data/repo/auth_repository_impl.dart`

Create:

- `lib/features/auth/data/models/request/family_first_login_verify_otp_request_dto.dart`
- `lib/features/auth/data/models/request/family_first_login_set_password_request_dto.dart`
- `lib/features/auth/data/models/response/family_first_login_verify_otp_response_dto.dart`
- `lib/features/auth/domain/entities/family_first_login_verify_otp_request_entity.dart`
- `lib/features/auth/domain/entities/family_first_login_set_password_request_entity.dart`
- `lib/features/auth/domain/entities/family_first_login_step_entity.dart`

`LoginEntity` must represent both authenticated and pending responses. Mapping must distinguish null tokens plus a family `nextStep` from successful login and must not manufacture tokens. Challenge values remain transient state only.

## Phase 2: Retrofit and remote data source

Modify `lib/core/network/api_services.dart` with the exact backend endpoints for OTP verification, password setup, and family context. Do not guess a response envelope; confirm it with the backend first.

Modify:

- `lib/features/auth/data/data_source/auth_remote_data_source.dart`
- `lib/features/auth/data/data_source/auth_remote_data_source_impl.dart`
- `lib/features/auth/data/repo/auth_repository_impl.dart`

Create:

- `lib/features/auth/domain/usecase/verify_family_first_login_otp_usecase.dart`
- `lib/features/auth/domain/usecase/set_family_first_login_password_usecase.dart`

The data source only calls `ApiServices`. The repository uses `safeApiCall` and maps DTOs to entities. Use cases depend on repository contracts, never directly on data sources or Retrofit.

## Phase 3: Existing login flow integration

Modify:

- `lib/features/auth/presentation/manager/login_event.dart`
- `lib/features/auth/presentation/manager/login_state.dart`
- `lib/features/auth/presentation/manager/login_view_model.dart`
- `lib/features/auth/presentation/screens/auth_flow_screen.dart`
- `lib/features/auth/presentation/widgets/auth_otp_page.dart`
- `lib/features/auth/presentation/widgets/auth_new_password_page.dart`
- `lib/features/auth/presentation/widgets/auth_otp_purpose.dart`

Use the existing OTP and new-password widgets. Add explicit events/states for submitting login, verifying family OTP, setting the password, authenticated success, challenge expiry, membership invalidation, wrong-code failure, and delivery failure.

Required sequence:

1. Submit the existing customer login request.
2. On `family_verify_otp`, keep the user unauthenticated and show OTP.
3. Verify OTP; replace the old challenge with the returned challenge.
4. On `family_set_password`, show new-password UI.
5. Set password; persist tokens only after the authenticated response.
6. Continue through the existing customer authenticated flow.
7. On expiry or account/family invalidation, clear transient challenge state and require a fresh login.

The UI must not claim that a phone message was delivered; delivery failure comes from the backend error result.

## Phase 4: Family member access and temporary password

Modify:

- `lib/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart`
- `lib/features/family_management/member/data/models/response/family_member_access_response_dto.dart`
- `lib/features/family_management/member/data/mapper/family_member_mapper.dart`
- `lib/features/family_management/member/domain/entities/family_member_access_entity.dart`
- `lib/features/family_management/member/presentation/manager/family_member_event.dart`
- `lib/features/family_management/member/presentation/manager/family_member_state.dart`
- `lib/features/family_management/member/presentation/manager/family_member_view_model.dart`
- `lib/features/family_management/member/presentation/screens/family_member_access_screen.dart`

Send `hasSeparateAccount: true` when enabling access. Send `generateTemporaryPassword: true` only for an explicit reset action. Existing accounts keep their password otherwise. Hold `generatedPassword` in transient state, show it once, clear it after dismissal/navigation, and never write it to storage, analytics, crash reports, or logs. Backend rejection of manager-account provisioning is displayed as an error.

## Phase 5: Family context feature

Create `lib/features/family_context/` using the standard structure:

```text
data/data_source/family_context_remote_data_source.dart
data/data_source/family_context_remote_data_source_impl.dart
data/mapper/family_context_mapper.dart
data/models/response/family_context_response_dto.dart
data/repo/family_context_repository_impl.dart
domain/entities/family_context_entity.dart
domain/entities/family_capability_entity.dart
domain/repo/family_context_repository.dart
domain/usecase/get_my_family_contexts_usecase.dart
presentation/manager/family_context_view_model.dart
presentation/manager/family_context_event.dart
presentation/manager/family_context_state.dart
```

Load contexts after authenticated login. Manager contexts use existing manager screens. Member contexts expose only allowed actions. Empty contexts use ordinary customer navigation. Per-member authorization must continue to use `/members/{memberId}/capabilities`; family context capabilities are not role grants.

## Phase 6: Sensitive logging

Inspect the existing logger/interceptors under `lib/core/network/` and `lib/core/`. Add centralized, case-insensitive redaction for `password`, `newPassword`, `otpCode`, `loginChallengeToken`, `generatedPassword`, `accessToken`, and `refreshToken` in request, response, and error logging. Do not add feature-level print statements.

## Phase 7: Localization and DI

Add localization keys through the existing localization system for OTP instructions, password setup, expired challenge, wrong/exhausted OTP, invalid family state, delivery failure, generated password, and private-delivery reminder. Do not hardcode strings in widgets.

Annotate new data sources, repositories, use cases, and ViewModels with the existing Injectable conventions. Then run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Phase 8: Tests

Add or extend tests for:

- Normal login remains unchanged.
- Pending login has no tokens and routes to OTP.
- OTP success rotates the challenge and routes to password setup.
- Password setup returns authenticated tokens.
- Expired, reused, wrong, and exhausted challenges fail safely.
- Disabled, removed, paused, or inactive-group members cannot continue.
- Delivery failure is never shown as successful delivery.
- Access linking sends the correct flags.
- Temporary password reset is explicit, displayed once, and cleared.
- Empty, manager, member, and nullable family contexts map correctly.
- Logs redact all sensitive values.

## Backend contract checks before coding

Confirm exact response envelopes, error codes, capability action/reason values, location of `generatedPassword`, whether `/family/me` is callable immediately after setup, the signal for `requiresPasswordSetup`, and phone normalization behavior.

## Verification

Run:

```bash
dart format lib test
dart analyze
flutter test
dart run build_runner build --delete-conflicting-outputs
dart analyze
flutter test
```

Review the final diff and ensure only auth, family member access, family context, networking, localization, and related tests/generated outputs changed.

## Completion criteria

- A pending family member completes login through login → OTP → new password.
- No token is persisted before password setup succeeds.
- Manager access linking and explicit temporary-password reset work.
- Sensitive values are redacted everywhere in client logs.
- Family context drives navigation and capability visibility.
- Existing customer, recovery, and manager flows remain intact.
- Formatting, analyzer, generated code, and relevant tests pass.
