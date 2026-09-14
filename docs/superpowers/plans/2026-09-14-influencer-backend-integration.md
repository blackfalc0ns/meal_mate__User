# Influencer Backend Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace all influencer fake business data with the documented backend APIs while preserving the current UI and splitting oversized screens into focused sections.

**Architecture:** One `influencer` feature contains focused contracts and managers for dashboard/links, social links, bank account, wallet/withdrawals, and analytics. Every operation follows Retrofit → remote data source → repository with `safeApiCall` → use case → event-driven ViewModel → entity-backed UI, with lazy in-memory loading.

**Tech Stack:** Flutter, Dart, Dio, Retrofit, json_serializable, Injectable/GetIt, flutter_bloc, fl_chart, share_plus, qr_flutter.

**Spec:** `docs/superpowers/specs/2026-09-14-influencer-backend-integration-design.md`

## Global Constraints

- Preserve the current UI, localization, navigation, theme, RTL/LTR behavior, and existing Core networking/error infrastructure.
- Do not create a profile screen, generic shared layer, second API client, persistent financial cache, or undocumented backend operation.
- Response DTO fields are nullable; request DTO fields follow the documented contract; UI consumes domain entities only.
- Business values come from the API. Only localized labels, assets, documented enum options, KWD compatibility fallback, and the documented 10 KWD fallback may remain client-side.
- Use `ApiResult`, `safeApiCall`, constructor injection, `doIntent`, immutable state with `copyWith`, and existing Core error widgets.
- Write a failing test before production behavior, generate code with build runner, and never edit generated files manually.

---

### Task 1: API contracts and typed domain models

**Files:**
- Create: `lib/features/influencer/data/models/response/influencer_home_response_dto.dart`
- Create: `lib/features/influencer/data/models/response/influencer_profile_response_dto.dart`
- Create: `lib/features/influencer/data/models/response/influencer_bank_account_response_dto.dart`
- Create: `lib/features/influencer/data/models/response/influencer_wallet_response_dto.dart`
- Create: `lib/features/influencer/data/models/response/influencer_withdrawal_response_dto.dart`
- Create: `lib/features/influencer/data/models/response/influencer_analytics_response_dto.dart`
- Create: `lib/features/influencer/data/models/request/influencer_bank_account_request_dto.dart`
- Create: `lib/features/influencer/data/models/request/influencer_withdrawal_request_dto.dart`
- Create: `lib/features/influencer/data/models/request/influencer_social_links_request_dto.dart`
- Create: focused entity files under `lib/features/influencer/domain/entities/`
- Create: focused mapper files under `lib/features/influencer/data/mapper/`
- Test: `test/features/influencer/data/influencer_dto_mapper_test.dart`

**Interfaces:**
- Produces nullable `fromJson` DTOs and `toEntity()` mappings for every documented response.
- Produces `InfluencerAnalyticsPeriod`, `InfluencerWithdrawalStatus`, and typed money/date entities with safe unknown handling.

- [ ] Write tests that parse every supplied JSON example, missing optional fields, unknown statuses, and request JSON for saved-bank and one-time-bank withdrawals.
- [ ] Run `flutter test test/features/influencer/data/influencer_dto_mapper_test.dart` and verify failures are caused by missing contracts.
- [ ] Implement minimal DTOs, entities, and mappers. Use `@JsonSerializable()` for response/request DTOs and no serialization annotations in entities.
- [ ] Run build runner, rerun the focused test, and verify it passes.
- [ ] Commit with `feat: add influencer API contracts`.

### Task 2: Retrofit, data sources, repositories, and use cases

**Files:**
- Modify: `lib/core/network/network_constants.dart`
- Modify: `lib/core/network/api_services.dart`
- Create: `lib/features/influencer/data/data_source/influencer_remote_data_source.dart`
- Create: `lib/features/influencer/data/data_source/influencer_remote_data_source_impl.dart`
- Create: `lib/features/influencer/domain/repo/influencer_repository.dart`
- Create: `lib/features/influencer/data/repo/influencer_repository_impl.dart`
- Create: one operation-specific file per use case under `lib/features/influencer/domain/usecase/`
- Test: `test/features/influencer/data/influencer_repository_test.dart`
- Test: `test/features/influencer/data/influencer_endpoint_contract_test.dart`

**Interfaces:**
- Produces repository methods for home, links, profile, bank get/save/delete, wallet, withdrawal create/list/detail, social update, and analytics.
- All repository methods return `Future<ApiResult<DomainType>>` and invoke `safeApiCall` around remote DTO mapping.

- [ ] Write endpoint-contract tests for exact methods, paths, path/query/body annotations and repository tests for success plus thrown-error mapping.
- [ ] Run both focused tests and verify expected failures.
- [ ] Add endpoint constants and Retrofit methods, then implement the remote data source, repository, and small injectable use cases.
- [ ] Run build runner and the focused tests until green.
- [ ] Commit with `feat: connect influencer data and domain layers`.

### Task 3: Dashboard and referral links state/UI

**Files:**
- Create: `lib/features/influencer/presentation/manager/dashboard/influencer_dashboard_event.dart`
- Create: `lib/features/influencer/presentation/manager/dashboard/influencer_dashboard_state.dart`
- Create: `lib/features/influencer/presentation/manager/dashboard/influencer_dashboard_view_model.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_dashboard_screen.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_share_links_screen.dart`
- Modify: relevant dashboard/share widgets to accept typed values and callbacks
- Create: section widgets if screen orchestration exceeds one coherent viewport block
- Test: `test/features/influencer/presentation/influencer_dashboard_view_model_test.dart`
- Test: existing influencer dashboard/share widget tests

**Interfaces:**
- `LoadInfluencerDashboardEvent({bool forceRefresh = false})` loads `/home` once per live manager unless refreshed.
- `LoadInfluencerLinksEvent({bool forceRefresh = false})` loads `/links`; copy/share actions consume state data only.

- [ ] Write failing ViewModel tests for initial load, cache skip, forced refresh, success, and failure without discarding existing data.
- [ ] Run the focused manager test and confirm RED.
- [ ] Implement manager/state/events and connect providers/builders to existing screens using `ApiErrorWidget` and existing loading/empty presentation.
- [ ] Add `share_plus` and `qr_flutter`; wire clipboard, native share, and API-driven QR data.
- [ ] Run focused and existing dashboard/share tests until green.
- [ ] Commit with `feat: connect influencer dashboard and referral links`.

### Task 4: Bank account flow

**Files:**
- Create: `lib/features/influencer/presentation/manager/bank_account/influencer_bank_account_event.dart`
- Create: `lib/features/influencer/presentation/manager/bank_account/influencer_bank_account_state.dart`
- Create: `lib/features/influencer/presentation/manager/bank_account/influencer_bank_account_view_model.dart`
- Create: `lib/features/influencer/presentation/screens/influencer_bank_account_screen.dart`
- Create: `lib/features/influencer/presentation/widgets/influencer_bank_account_content.dart`
- Create: focused configured-card, form, and IBAN field/formatter widgets
- Modify: route registration and existing bank navigation targets
- Test: `test/features/influencer/presentation/influencer_bank_account_view_model_test.dart`
- Test: `test/features/influencer/presentation/influencer_iban_input_test.dart`

**Interfaces:**
- Events load, save `InfluencerBankAccountRequestEntity`, and delete the account.
- `normalizeIban(String)` removes spaces/hyphens and uppercases; validation enforces required alphanumeric length 15–34.

- [ ] Write failing normalization/validation and ViewModel load/save/delete tests, including mapped field errors.
- [ ] Run tests and verify RED.
- [ ] Implement manager and split screen sections, using free-text bank entry and retaining form content during mutations.
- [ ] Wire navigation and refresh state after successful mutation.
- [ ] Run focused tests until green.
- [ ] Commit with `feat: add influencer bank account integration`.

### Task 5: Wallet and withdrawal flows

**Files:**
- Create: `lib/features/influencer/presentation/manager/wallet/influencer_wallet_event.dart`
- Create: `lib/features/influencer/presentation/manager/wallet/influencer_wallet_state.dart`
- Create: `lib/features/influencer/presentation/manager/wallet/influencer_wallet_view_model.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_wallet_screen.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_withdraw_screen.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_withdraw_review_screen.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_withdraw_history_screen.dart`
- Create: focused wallet/withdrawal content and section widgets as needed
- Test: `test/features/influencer/presentation/influencer_wallet_view_model_test.dart`
- Test: existing wallet/withdrawal screen tests

**Interfaces:**
- Events load wallet/history/detail, select history status, and submit `InfluencerWithdrawalRequestEntity`.
- State separately tracks initial loading, refresh, submit loading, history loading, selected filter, failures, and cached entities.

- [ ] Write failing tests for lazy wallet load, filters, saved/one-time bank submission, duplicate-submit guard, pending-withdrawal disablement, and post-success refresh.
- [ ] Run focused tests and confirm RED.
- [ ] Implement manager/events/state and connect typed values to the existing wallet and withdrawal screens.
- [ ] Split oversized screens into balance, destination, amount, actions, filters, list, and review sections; widgets receive data/callbacks only.
- [ ] Preserve content on action errors and route known error codes to the correct inline feedback.
- [ ] Run focused and existing screen tests until green.
- [ ] Commit with `feat: connect influencer wallet and withdrawals`.

### Task 6: Social links flow

**Files:**
- Create: `lib/features/influencer/presentation/manager/social_links/influencer_social_links_event.dart`
- Create: `lib/features/influencer/presentation/manager/social_links/influencer_social_links_state.dart`
- Create: `lib/features/influencer/presentation/manager/social_links/influencer_social_links_view_model.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_social_connections_screen.dart`
- Create: focused identity, channels-form, and quick-actions section widgets
- Test: `test/features/influencer/presentation/influencer_social_links_view_model_test.dart`

**Interfaces:**
- Loads `/me` once and updates all six optional social fields through an entity/request mapper.
- Does not introduce a profile screen; identity is display-only on the existing social surface.

- [ ] Write failing tests for load, normalized submission, mutation loading, success, and preserved-content failure.
- [ ] Run focused tests and verify RED.
- [ ] Implement manager and convert the existing read-only surface to the documented editable six-channel form without redesigning its identity.
- [ ] Add section widgets if the screen grows beyond orchestration responsibility.
- [ ] Run focused and navigation tests until green.
- [ ] Commit with `feat: connect influencer social links`.

### Task 7: Analytics flow

**Files:**
- Create: `lib/features/influencer/presentation/manager/analytics/influencer_analytics_event.dart`
- Create: `lib/features/influencer/presentation/manager/analytics/influencer_analytics_state.dart`
- Create: `lib/features/influencer/presentation/manager/analytics/influencer_analytics_view_model.dart`
- Modify: `lib/features/influencer/presentation/screens/influencer_statistics_screen.dart`
- Modify: analytics chart, summary, metric, and top-program widgets
- Create: focused analytics content/section widgets if needed
- Test: `test/features/influencer/presentation/influencer_analytics_view_model_test.dart`
- Test: existing influencer analytics widget tests

**Interfaces:**
- Loads `30d` initially and reloads for `7d`, `30d`, `90d`, or `all` while preserving old content during a period refresh.
- Chart consumes dated click/order points from entities; top programs consume API results rather than localized sample values.

- [ ] Write failing tests for default period, period change, stale response protection, empty results, and refresh failure with existing content.
- [ ] Run focused tests and confirm RED.
- [ ] Implement manager and map entity dates/counts into existing `fl_chart` widgets with tooltips.
- [ ] Remove unsupported fake comparison metrics from data binding unless optional backend comparison fields are present.
- [ ] Run focused and existing chart/widget tests until green.
- [ ] Commit with `feat: connect influencer analytics`.

### Task 8: Remove fake business data and verify the complete feature

**Files:**
- Delete: `lib/features/influencer/data/influencer_fake_data_source.dart` after `rg` confirms no usage
- Refactor/delete obsolete portions of `lib/features/influencer/domain/entities/influencer_dashboard_entity.dart`
- Modify: influencer localization entries only to remove business-value usage, retaining labels
- Update: affected tests

**Interfaces:**
- No influencer screen reads localized sample values or fake source business data.
- All routes remain compatible with their existing callers.

- [ ] Add/adjust a contract test that fails if `InfluencerFakeDataSource` or known localized fake value getters are referenced by influencer screens.
- [ ] Run it and confirm RED while references remain.
- [ ] Remove remaining fake references and obsolete model fields; retain design assets and translated labels.
- [ ] Run `dart run build_runner build --delete-conflicting-outputs` and `dart format` on changed Dart files.
- [ ] Run all influencer tests, then `flutter test`, then `flutter analyze`; fix only failures introduced by this work.
- [ ] Commit with `refactor: remove influencer fake business data`.
