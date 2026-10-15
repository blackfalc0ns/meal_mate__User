# Family Management Backend Contract Alignment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align the Flutter family-management flow with the repaired backend contract, including server-derived family identity, permission catalog/updates, capability-gated actions, credential flows, detachment, subscription routes, localization, and permission explanations shown from an info dialog.

**Architecture:** Keep the existing Flutter architecture and add the contract at its current data/domain/presentation boundaries. `/family/me` is the source of actor context and effective member capabilities; `/permissions` is only the manager-facing editable catalog. UI visibility is an optimization; every write remains server-authoritative. Permission descriptions are rendered from API bilingual fields and shown on demand in an info dialog beside each permission control.

**Tech Stack:** Existing Flutter/Dart stack, existing HTTP client/auth/session layer, existing state-management pattern, existing localization system, existing widget/dialog components, and current test tooling.

**Spec:** `docs/superpowers/specs/backend_pasted_text.txt`, plus the two attached backend contracts supplied by the product/backend team.

## Global Constraints

- Read `GET /api/v1/customer/family/me` to resolve manager/member identity; never ask the user to choose a role.
- Send `Authorization: Bearer <customer access token>` on every protected request and `Accept-Language` for localized responses.
- Keep challenge tokens separate from bearer access/refresh tokens; only store access/refresh tokens after authenticated responses.
- Use `memberSubscriptionId` resolved from the selected family context instead of a global current-subscription guess.
- Treat backend `403`, `409`, `404`, and semantic `code`/`reasonCode` as authoritative outcomes.
- Permission writes send `expectedVersion` and only changed nullable patch keys; never send `groups` as the write body.
- Hide/disable unsupported permissions; do not expose non-manager-configurable permissions as editable toggles.
- Never log passwords, OTPs, bearer tokens, refresh tokens, challenge tokens, or generated credentials.
- Product copy belongs in the Arabic/English client dictionary; permission names/descriptions come from API fields with counterpart-language fallback.
- Preserve technical action keys, permission keys, IDs, and server state; do not infer permission from role strings or broad flags alone.

---

### Task 1: Map the existing implementation before changing it

**Files:**
- Inspect: existing `lib/` auth, family, permissions, calendar, subscription, localization, and shared-dialog files.
- Inspect: `docs/family_spec/03-management-access-permissions.md`, `docs/family_spec/04-calendar-restaurants-meals.md`, `docs/family_spec/05-subscription-renewal-upgrade-freeze-cancel-invoices.md`, `docs/family_spec/07-route-reference.md`, and `docs/family_spec/08-errors-and-special-json.md`.

- [x] Identify the current API client, auth interceptor, model conventions, repository/use-case boundaries, Cubit/ViewModel state types, route registration, and existing dialog/toast/error components.
- [x] Record the exact existing file paths and extension points in this plan before implementation:
  - Network & Auth: `lib/core/network/api_services.dart`, `lib/core/network/network_constants.dart`, `lib/core/services/token_interceptor.dart`, `lib/core/services/token_service.dart`, `lib/core/network/failuer_mapper.dart`.
  - Auth Feature: `lib/features/auth/data/data_source/`, `lib/features/auth/data/models/`, `lib/features/auth/domain/`, `lib/features/auth/presentation/manager/login_view_model.dart`.
  - Family Context Feature: `lib/features/family_context/data/`, `domain/`, `presentation/manager/family_context_view_model.dart`.
  - Family Management Feature: `lib/features/family_management/{overview, member, calendar, shared}/`.
  - Routing: `lib/config/routing/app_routes.dart`, `lib/config/routing/routing_generator.dart`.
  - Localization: `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ar.arb`.
  - Dialogs: `lib/core/widget/app_custom_dialog.dart`, `lib/core/widget/app_toast.dart`.
- [x] Confirm whether any older DTO still contains `changeProgram` or `changeDeliveryTime`; mark it for removal from manager catalog rendering and writes. Confirmed: `FamilyMemberPermissionsResponseDto`, `FamilyMemberPermissionsEntity`, and `UpdateFamilyMemberPermissionsRequestDto` have `changeProgram` and `changeDeliveryTime`. These are unsupported/non-configurable and marked for removal from catalog rendering and patch writes.

**Verification:** No source changes; produce an implementation map and confirm the contract can be integrated without a new architecture.

### Task 2: Implement the authentication and family-context contract

**Files:**
- Modify: existing customer auth data source/repository/models.
- Modify: existing session/token storage and auth navigation state.
- Create or modify: family context models/state at the existing family feature boundary.

**Interfaces:**
- Login result exposes `isAuthenticated`, `nextStep`, `loginChallengeToken`, and expiry without treating challenge tokens as bearer tokens.
- Family context exposes `groupId`, `isManager`, `memberId`, `memberSubscriptionId`, `isDetachedFromFamilyManagement`, `setupStatus`, `hasSeparateAccount`, `isPaused`, `requiresPasswordSetup`, `accessStatus`, and `capabilities`.

- [x] Add/align the four auth calls: customer login, family first-login OTP verification, family first-login password setup, and resend OTP.
- [x] Replace challenge tokens after verify/resend; return to normal login on expired/invalid challenge.
- [x] Store access/refresh tokens only from an authenticated response.
- [x] Load `/customer/family/me` after authentication and derive navigation from returned contexts.
- [x] Preserve paused/disabled/detached contexts in state; do not treat them as global session invalidation.
- [x] Refresh family context after access, credential, permission, and detachment mutations.

**Tests:** login challenge lifecycle, token separation, multiple contexts, null subscription IDs, pending setup, paused context visibility, and manager/member navigation.

### Task 3: Add manager home, roster, switcher, detail, and capability reads

**Files:**
- Modify: existing family manager API/repository/state files.
- Modify: manager home, roster, detail, and member-switcher screens.

- [x] Wire manager routes: `/family/home`, `/family/members`, `/family/members/{memberId}`, `/family/switcher`, and `/family/members/{memberId}/capabilities`.
- [x] Carry `groupId`, identity/visibility flags, and selected `memberId` through navigation.
- [x] Ensure sibling read rows cannot render manager controls or become editable targets.
- [x] Use the current actor policy and returned capabilities, not the target member's grants, to decide visible actions.
- [x] Distinguish setup-required, detached, paused, disabled, and paid-preparing-calendar states in UI.

**Tests:** manager roster visibility, sibling read-only behavior, selected-member subscription resolution, and empty/pending/paid-preparing states.

### Task 4: Implement the permission catalog and info dialog UX

**Files:**
- Modify: permission catalog DTO/domain models and repository.
- Modify: manager permissions screen and permission-row widget.
- Create or modify: shared permission-description dialog.
- Modify: Arabic/English localization keys for product-owned dialog labels and errors.

**Interfaces:**
- Permission item contains `key`, `labelAr`, `labelEn`, `descriptionAr`, `descriptionEn`, `value`, `isSupported`, `isManagerConfigurable`, and `requiredPermissions`.
- `localizedLabel(isArabic)` and `localizedDescription(isArabic)` select the active language and fall back to the other field when blank.
- Dialog accepts one permission item and renders the localized label, description, current value, and editability/support status.

- [x] Load `GET /api/v1/customer/family/members/{memberId}/permissions` before rendering controls.
- [x] Render the API label and description; never create a second hardcoded permission glossary in Flutter.
- [x] Place an `info_outline` icon beside each permission row; tapping it opens a modal dialog with the API description.
- [x] Keep the dialog usable in RTL/LTR and Arabic/English without restart; verify `ar -> en -> ar` while the dialog is open.
- [x] Render `isManagerConfigurable: false` as a fixed state, not a toggle.
- [x] Hide or disable `isSupported: false`; do not show obsolete `changeProgram` or `changeDeliveryTime` catalog entries from old DTOs.
- [x] Show prerequisite/read grants when supplied by `requiredPermissions` without implying that read access grants write access.

**Tests:** active-language selection, missing-field fallback, dialog open/close, RTL/LTR layout, unsupported/fixed controls, and no hardcoded backend permission descriptions.

### Task 5: Implement versioned permission updates and conflict handling

**Files:**
- Modify: permission repository/data source and update request models.
- Modify: permission state/controller and save UI.

- [x] Track the loaded permission `version` and an original-value snapshot.
- [x] Build a nullable patch containing only changed permission keys plus `expectedVersion`.
- [x] Call `PUT /api/v1/customer/family/members/{memberId}/permissions`.
- [x] On success, replace local values with the persisted response and reload `/family/me`/capabilities.
- [x] On `409 family.permissions_changed`, refresh the catalog, discard the stale patch, and show a localized conflict message; never silently overwrite.
- [x] On `403`, show the server denial and refresh context; do not claim the toggle succeeded.

**Tests:** unchanged-key omission, version mismatch, successful persistence, 403 handling, and conflict refresh.

### Task 6: Gate calendar and meal actions by granular capabilities

**Files:**
- Modify: calendar/day/restaurant/meal repositories and action controllers.
- Modify: calendar, day-detail, restaurant, and meal-selection widgets.

- [x] Use `viewCalendar`, `viewFamilyCalendars`, `selectRestaurant`, `editDailyMeals`, `editMealsAndDays`, `unitExchange`, and `confirmMeals` independently.
- [x] Preserve legacy `editDailyMeals` behavior when present; otherwise use the newer granular permissions.
- [x] Show add-to-empty-slot only for `editMealsAndDays`; show replacement only for `unitExchange`; show confirmation only for `confirmMeals` after server/day readiness checks.
- [x] Do not use `canEditDailyMeals` as the sole decision for every calendar button.
- [x] Keep day closed-date and subscription-readiness checks in addition to capability checks.
- [x] Wire calendar routes for day, restaurants, meals, restaurant selection, slot mutation, complete, confirm, and auto-select.
- [x] Treat server rejection after stale UI as expected and refresh the day/context.

**Tests:** add-only, replace-only, confirm-only, restaurant-only, read-only, closed-day, and ineligible-subscription scenarios.

### Task 7: Implement member access provisioning and credential safety

**Files:**
- Modify: manager member-access repository/models/state.
- Modify: access-provisioning and credential-result screens.

- [x] Send `PUT /family/members/{memberId}/access` with `hasSeparateAccount`, `generateTemporaryPassword`, and a unique `credentialOperationKey`.
- [x] Reuse a key only when retrying the exact same operation; never auto-generate a fresh key after replay.
- [x] Display `generatedPassword` only on the first completed response; handle replay with `passwordAlreadyIssued` and `requiresExplicitReset`.
- [x] Display the canonical linked phone from the response, not an edited member-card phone.
- [x] Offer explicit reset with a new operation key only after explaining that the old plaintext cannot be recovered.
- [x] Redact credentials and tokens from logs, analytics, and crash reporting.

**Tests:** first issuance, replay, explicit reset, linking an existing account without reset, duplicate operation keys, and phone-change verification rejection.

### Task 8: Implement detachment and post-detachment authorization

**Files:**
- Modify: detachment data source/repository/state.
- Modify: member detail/action screens and context refresh logic.

- [x] Call `POST /family/members/{memberId}/detach` only for completed active login and no blocking financial intent.
- [x] Treat detachment as idempotent and independent from access enablement.
- [x] After success, refresh contexts and grant the detached member supported own actions.
- [x] Restrict former-manager visibility to approved read-only service/roster data; block credential, grant, profile, preference, and private-address management routes.
- [x] Keep lineage IDs, subscription, days, and funded entitlement unchanged; do not implement automatic reattachment.
- [x] Keep `remove: true` and subscription freeze as separate behaviors.

**Tests:** idempotent detach, blocked financial intent, former-manager restrictions, detached owner access, and historical context coexistence.

### Task 9: Align subscription, address, finance, and account routes

**Files:**
- Modify: existing subscription/calendar/address/invoice/account repositories and route constants.
- Modify: corresponding action controllers and error presenters.

- [ ] Use resolved subscription IDs for calendar, delivery-address, invoices, freeze, renewal, upgrade, cancellation quote, and cancellation requests.
- [ ] Send address updates as `{addressId,effectiveFromDate,expectedVersion}` and preserve committed delivery snapshots.
- [ ] Keep invoice permission financially independent from plan permission.
- [ ] Keep auto-renew consent separate from billing connection; preserve truthful `billingStatus: NotConnected`.
- [ ] Use localized ProblemDetails and semantic codes/reason codes for Forbidden/Conflict/NotFound outcomes.
- [ ] Route password changes through `/customers/me/password`; do not couple it to family detachment.

**Tests:** each subscription action route, address affected/skipped day response, invoice isolation, billing-not-connected state, and localized errors.

### Task 10: Localization, state coverage, and verification

**Files:**
- Modify: localization dictionaries and language-switch handling.
- Modify: loading/empty/error/blocked states in affected screens.
- Create or modify: contract-focused unit/widget/integration tests using existing test conventions.

- [ ] Verify Arabic and English permission labels/descriptions, fallback behavior, and immediate language switching.
- [ ] Verify RTL/LTR dialogs, persisted language, token/challenge expiry, blocked actions, empty contexts, loading states, and stale-capability refresh.
- [ ] Verify Asia/Kuwait business-calendar behavior and KWD three-decimal formatting where applicable.
- [ ] Run focused tests, analyzer/formatter, and the existing project test suite.
- [ ] Confirm backend contract tests are not treated as a substitute for Flutter source-tree tests or deployed-server verification.

### Task 11: Final review and delivery

- [ ] Compare every implemented endpoint and model field against both backend contract files.
- [ ] Search for obsolete role-selection logic, hardcoded permission descriptions, broad-flag-only gating, plaintext credential logging, and old permission keys.
- [ ] Record any backend deployment/migration prerequisite that cannot be verified from the mobile repository.
- [ ] Deliver a short change summary with test commands and any remaining backend dependency.

## Acceptance Criteria

- Manager permission screen reads the catalog first, shows an info icon/dialog for every permission, and uses API-provided localized descriptions.
- Manager can edit only supported/configurable permissions; save sends a versioned changed-key patch.
- Member actions are independently gated by server capabilities and subscription/day state.
- Auth, family context, access provisioning, detachment, subscription actions, localization, and error semantics follow the repaired contract.
- No code change is made outside the mapped existing architecture without a documented reason.
