# Address Coverage Backend Contract — Gemini Implementation Plan

> **For agentic workers:** Use `superpowers:executing-plans`, if available, to execute task by task. Track the checkboxes. This is a scoped handoff to Gemini; inspect the current implementation before making changes.

**Goal:** Verify and complete compatibility with the backend's 2026-10-06 coverage contract, including paginated restaurant previews and nullable localized coverage notices, without rebuilding the existing feature.

**Architecture:** Preserve the existing shared `core/address` editor and customer/family adapters. Keep Retrofit → DataSource → Repository/Mapper → UseCase/operations → ViewModel → State → UI. Reuse existing pagination, core failures, language interceptor, modal, and loading widgets.

**Tech stack:** Flutter/Dart, flutter_test, flutter_bloc, Dio/Retrofit, json_serializable/build_runner, Injectable/GetIt. No new packages.

**Spec:** The backend contract is reproduced in section 1. Read this plan alongside `docs/superpowers/specs/2026-10-05-address-preview-coverage-pagination-contract.md`; the newer rules below supersede conflicting statements in that older document. The supplied backend note reports deployment and live verification; this plan does not independently verify those claims.

## Global constraints

- Read `AGENTS.md`, `rules/rules_backend.md`, and `rules/ui_rules.md`. The referenced `rules/backend_rules.md` does not exist in the inspected checkout; the existing backend rule file is `rules/rules_backend.md`.
- Preserve current design, spacing, colors, text, navigation, confirmation behavior, shimmer, and architecture. No UI redesign or localization additions are required by this contract.
- Preserve all pre-existing working-tree changes, especially the ongoing `subscription_upgrade` extraction. Do not reset, stash, format, move, or edit unrelated files.
- Do not execute the subscription upgrade or address refactor plans as part of this task.
- Existing compatibility code is valuable. Passing new contract tests can be the complete deliverable for a component; do not manufacture production changes to make the task look substantial.
- Do not manually edit generated files. Regenerate only if source annotations, DTO structure, or Retrofit declarations change; inspect collateral generated differences.
- Do not commit, push, publish, or merge without a separate request.
- Never copy test credentials or tokens into tracked documents, fixtures, logs, or screenshots.

## 1. Contract to implement and verify

### Pagination

| Operation | HTTP | Parameter location |
| --- | --- | --- |
| Customer new-address preview | POST | JSON body |
| Customer existing-address preview | GET | Query |
| Family new-address preview | POST | JSON body |
| Family existing-address preview | GET | Query |

- Neither parameter sent: full `servingRestaurants`, `pagination: null`.
- Either `page` or `pageSize` sent: paginated list. Missing page defaults to 1, missing size to 20 on the server.
- Metadata fields: `totalCount`, `page`, `pageSize`, `totalPages`, `hasNextPage`, `hasPreviousPage`.
- Ordinary page beyond the end: successful response, empty restaurant list, valid metadata. It is not a client failure.
- Server owns sorting by Arabic restaurant name then ID. Keep response order and deduplicate appended IDs; do not sort in Flutter.
- Coverage flags, resolved address fields, conflict rules, and save/default eligibility are computed independently of the current restaurant page.
- Keep lower-layer parameters optional. UI already explicitly requests page 1 and size 20 using `AppConstants`.

### Notice

- `restaurantCoverageNotice` is a localized **string or null**, not a required `{ar,en}` object.
- Server selects language using `Accept-Language`: `ar` for Arabic; `en` or omitted header for English.
- With `hasActiveSubscription: false`, notice is null. With true, server supplies the notice.
- Server's active definition includes Active, Paid, Scheduled, Frozen, CancellationPending, and Upgraded. Do not recreate this status list on the client.
- Applies to the four previews and customer/family add, update, and set-default responses.
- Render supplied nonempty text only; null is normal. Do not synthesize a subscription warning or use a force unwrap.
- Existing adapters that put a localized string into both `ar` and `en` fields are compatible. Preserve legacy object parsing and the domain model unless an actual defect is demonstrated.
- A locale change does not translate an already returned server string. Do not claim otherwise or invent client translations; use the existing request/language lifecycle.

### Family path discrepancy — must be resolved with evidence

Backend note names:

```text
/api/v1/family/members/{memberId}/addresses/preview-coverage
/api/v1/family/members/{memberId}/addresses/{addressId}/preview-coverage
```

Current constants and previous contract name:

```text
/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/preview-coverage
/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/{addressId}/preview-coverage
```

Do not blindly replace the family prefix, add retry-to-another-path fallback, or change all family endpoints. Task 2 defines the decision gate.

## 2. Current evidence and file map

Before this plan, these four suites passed: preview DTO/mapper, pagination transport, pagination ViewModel, preview bottom sheet: **24 tests total**. Run them again; the checkout is actively changing.

Already implemented:

- `lib/core/address/data/models/request/address_coverage_preview_request_dto.dart`: optional pagination and omission of null keys.
- `lib/core/address/data/models/response/address_coverage_preview_response_dto.dart`: nullable pagination; notice parser accepts null, string, and legacy object.
- `lib/core/address/data/models/response/customer_address_response_dto.dart`: shared mutation-response parser accepts null/string/object.
- `lib/core/address/data/mapper/customer_address_mapper.dart`: maps notices, pagination, and requests.
- `lib/core/address/presentation/manager/address_editor_view_model.dart`: first-page requests, incremental merging, duplicate-load guards, and stale-session protection.
- `lib/core/address/presentation/widgets/address_coverage_preview_bottom_sheet.dart`: notice is shown only when nonnull/nonempty, inside the existing covered header.
- `lib/core/services/language_interceptor.dart`: existing `Accept-Language` handling.

Files allowed only if a verified defect requires a fix:

- The files above and corresponding shared entities/state.
- `lib/core/network/network_constants.dart`, `api_services.dart`, and generated `api_services.g.dart`: only verified affected endpoints/serialization.
- Customer/family address repositories, data sources, operations, and ViewModels: only affected forwarding/response behavior.
- Existing customer/family address screens: only incorrect notice display; preserve composition and navigation.

Primary test files:

- Extend `test/address_coverage_preview_test.dart`.
- Extend `test/address_coverage_pagination_transport_test.dart`.
- Extend `test/address_coverage_preview_bottom_sheet_test.dart`.
- Reuse `test/address_coverage_pagination_view_model_test.dart` and `test/family_addresses_view_model_test.dart` for regressions.
- Create `test/address_coverage_notice_contract_test.dart` only if shared mutation parsing does not fit cleanly into existing suites.

Documentation:

- Update the older coverage spec with the new notice contract and verified family-path outcome; retain its historical deployment context.
- Mark this plan's checkboxes and record final evidence/blockers here.

## Task 1 — Establish baseline and trace consumers

- [ ] Read the rules and record `git status --short`; classify existing changes before editing.
- [ ] Search notice consumers and trace add/update/set-default responses for both customers and family. Confirm actual response DTOs rather than assuming shared parsing covers every endpoint.
- [ ] Run the baseline command below and record results.

```powershell
git status --short
rg -n 'restaurantCoverageNotice|hasActiveSubscription|Accept-Language' lib test
rg -n 'previewFamilyMemberAddress|previewExistingFamilyMemberAddress|setDefaultFamilyMemberAddress|CustomerAddressResponseDto' lib/core/network/api_services.dart lib/features/addresses lib/features/family_addresses
flutter test test/address_coverage_preview_test.dart test/address_coverage_pagination_transport_test.dart test/address_coverage_pagination_view_model_test.dart test/address_coverage_preview_bottom_sheet_test.dart
```

Deliverable: baseline and endpoint/response/consumer inventory. No broad feature rewrite.

## Task 2 — Resolve family routing and missing validation details

**Files:** `network_constants.dart`, transport tests, older coverage spec; production changes conditional on evidence.

- [ ] Check backend-provided current OpenAPI/docs or obtain an explicit backend confirmation of the two family preview routes and whether the current routes remain supported.
- [ ] If authenticated family preview testing is available, use an existing accessible member/address and preview operations only. Record method, path, status, and response shape without credentials or personal data. Do not create family members or mutate saved addresses for this check.
- [ ] A 401/403 does not prove a route is correct or incorrect. A 404 alone may mean an unavailable resource. Use schema/controller evidence or a successful request against known accessible IDs.
- [ ] If current routes are supported, retain them and record that the note uses another alias or needs correction.
- [ ] If only new routes are confirmed, update only the two preview constants, update exact-path transport assertions, and run transport tests. Regenerate bindings if needed by the actual Retrofit change.
- [ ] If evidence is unavailable, leave paths unchanged and report this part as blocked. Continue independent local contract tests; do not claim family live compatibility.
- [ ] Request/document server behavior for zero/negative page, zero/negative size, maximum size, and overflow error payload/code. Do not add invented client limits. Keep existing core failure handling until a real payload demonstrates a gap.

Deliverable: evidenced routing decision or explicit unresolved blocker. Missing validation documentation must not prevent completing the valid-request compatibility work.

## Task 3 — Add real string/null parsing contract tests

**Interfaces:** `AddressCoveragePreviewResponseDto.fromJson(Map<String,dynamic>)`, `CustomerAddressResponseDto.fromJson(Map<String,dynamic>)`, and their existing `toEntity()` extensions.

- [ ] Add table-driven tests covering the four active/pagination combinations below. Use string fixtures, not only legacy notice objects.
- [ ] Add explicit mutation DTO tests for null, Arabic string, English string, empty/whitespace string, and legacy object. Verify null remains null through mapping.
- [ ] Test `rating: null` in a serving restaurant to match the supplied example.
- [ ] Run tests before changes. If they pass, retain production code. If they fail, fix only the responsible parser/mapper and rerun.

Add this executable test inside `main()` in `address_coverage_preview_test.dart`:

```dart
test('live notice contract supports all subscription/pagination combinations', () {
  for (final active in [false, true]) {
    for (final paged in [false, true]) {
      final entity = AddressCoveragePreviewResponseDto.fromJson({
        'canSetAsDefault': true,
        'isCurrentSubscriptionRestaurantCovered': true,
        'hasActiveSubscription': active,
        'restaurantCoverageNotice': active ? 'Coverage notice' : null,
        'servingRestaurants': [
          {'id': 'r1', 'nameAr': 'مطعم', 'rating': null},
        ],
        'pagination': paged ? {
          'totalCount': 2, 'page': 1, 'pageSize': 1,
          'totalPages': 2, 'hasNextPage': true,
          'hasPreviousPage': false,
        } : null,
      }).toEntity();
      expect(entity.hasActiveSubscription, active);
      expect(entity.restaurantCoverageNotice?.text('en'),
          active ? 'Coverage notice' : null);
      expect(entity.pagination != null, paged);
      expect(entity.servingRestaurants.single.rating, isNull);
    }
  }
});
```

For the mutation parsing test, add the existing response DTO and mapper imports, then use:

```dart
test('address mutation responses preserve nullable localized notice', () {
  for (final text in <String?>[null, 'تنبيه التغطية', 'Coverage notice', '', '   ']) {
    final entity = CustomerAddressResponseDto.fromJson({
      'id': 'address-1',
      'restaurantCoverageNotice': text,
    }).toEntity();
    if (text == null || text.trim().isEmpty) {
      expect(entity.restaurantCoverageNotice, isNull);
    } else {
      expect(entity.restaurantCoverageNotice?.text('ar'), text);
      expect(entity.restaurantCoverageNotice?.text('en'), text);
    }
  }
});
```

This shared DTO test is not proof that all mutation routes return that DTO. Use the Task 1 inventory to cover any actual alternative response adapters.

## Task 4 — Verify notice rendering and conflict behavior

**Files:** existing bottom-sheet tests and verified customer/family notice consumers only.

- [ ] Reuse the existing localized `MaterialApp` test harness. Construct `AddressCoveragePreviewEntity` with the existing constructor; use `CustomerAddressCoverageNoticeEntity(ar: 'Coverage notice', en: 'Coverage notice')` for a server-localized string.
- [ ] Covered + no active subscription + null notice: expect `find.text('Coverage notice')` to find nothing, restaurants and the existing confirm action remain visible.
- [ ] Covered + active subscription + supplied string: expect the notice exactly once. Repeat Arabic and English using the existing localization delegates and supported locales.
- [ ] Active subscription + uncovered + `canSetAsDefault: false`: verify existing conflict presentation and blocked confirmation; pagination must not make confirmation available.
- [ ] Verify mutation-response null notices do not trigger warning effects, crashes, or locally generated subscription warnings in the actual consumers found in Task 1. Use existing fake-repository/ViewModel test patterns.
- [ ] Preserve the existing uncovered layout: the bottom sheet currently shows a conflict banner instead of the covered header. The backend's presence of both fields does not authorize adding a second banner or changing design.
- [ ] If a real wrong-null handling defect is found, add a failing regression first and apply the smallest correction. Do not add an active-status lookup when checking the supplied nullable notice is sufficient.

Deliverable: rendered string/null behavior and preserved conflict/confirmation semantics, without visual redesign.

## Task 5 — Verify pagination transport and lifecycle regressions

**Interfaces:** preserve existing optional `{int? page, int? pageSize}` parameters through UseCases/repositories and GET data sources; POST uses `AddressCoveragePreviewRequestDto`.

- [ ] Extend the transport suite's existing captured `RequestOptions` harness so each of the four operations covers neither parameter, both parameters, page only, and size only. POST omitted keys must be absent; GET omitted query keys must be absent. Do not inject lower-layer defaults.
- [ ] Assert exact verified request paths, including family paths from Task 2. Mock interception proves client transport only, not server routing.
- [ ] Reuse existing ViewModel tests for first page `(1,20)`, append order, unique IDs, duplicate in-flight protection, retry of the same page, null metadata stopping pagination, empty terminal pages preserving accumulated restaurants, and stale/disposed-session protection.
- [ ] Cover family member switching using existing family test fixtures; a late page response must not replace the new member's preview.
- [ ] Verify incremental fetches never save/update/set-default an address and never open a second modal; reuse existing modal and pagination suites.
- [ ] Fix only failures introduced by the real contract; do not alter first-page coverage eligibility based on the size of a partial restaurant list.

```powershell
flutter test test/address_coverage_preview_test.dart test/address_coverage_pagination_transport_test.dart test/address_coverage_pagination_view_model_test.dart test/address_coverage_preview_bottom_sheet_test.dart test/address_coverage_pagination_modal_test.dart test/address_coverage_restaurants_pagination_test.dart test/family_addresses_view_model_test.dart
```

Run the new notice test file too if created.

## Task 6 — Optional live verification, documentation, and delivery

- [ ] If authorized credentials are available, use only login and preview operations for the live smoke check. Keep tokens in process memory and output a redacted results table. Do not log full responses containing address/account data.
- [ ] For a no-subscription account, verify no parameters, both parameters, page only, size only, and an ordinary out-of-range page; verify notice null and metadata behavior.
- [ ] For an available subscribed account, verify a localized string and unchanged coverage/conflict fields; test `Accept-Language: ar` and `en` plus omitted header. If no account is available, mark subscribed live cases unverified.
- [ ] Verify family previews only with valid accessible member/address context. Do not assume customer success proves family success.
- [ ] Do not execute live add/update/set-default calls merely to verify notices. Local adapter/transport tests cover these; live mutation verification requires an explicitly disposable environment and authorization.
- [ ] Update the older coverage spec: add string/null notice contract, active definition owned by server, language behavior, mutation applicability, and verified family routing decision. Preserve unresolved validation questions as questions, not invented requirements.
- [ ] Format only changed Dart files using explicit paths. Run the focused tests and `flutter analyze`; classify pre-existing/unrelated failures using the baseline.
- [ ] Run `git diff --check`, inspect scoped diffs, and compare final status against baseline. Do not claim other agents' subscription work as this task's changes.
- [ ] Deliver changed files, test totals/results, production fixes versus tests-only changes, live checks versus mocked checks, and unresolved backend questions.

```powershell
flutter analyze
git diff --check
git status --short
```

## Acceptance checklist

- [ ] String/null parsing is covered for previews and actual mutation response adapters.
- [ ] Null notice is hidden without crash or synthesized warning; conflict and confirmation behavior is preserved.
- [ ] All four transports preserve dual contract and partial opt-in parameters.
- [ ] Existing incremental loading, errors, modal lifecycle, and session guards still pass.
- [ ] Family route compatibility is evidenced or explicitly left unresolved; no guessed migration.
- [ ] Validation limits/errors are documented only from backend evidence.
- [ ] No unrelated source/architecture/design changes, credentials, packages, or hand-edited generated code.
- [ ] Final report distinguishes locally tested compatibility from live deployment verification.

## Prompt to give Gemini

> اقرأ `docs/superpowers/plans/2026-10-06-address-coverage-backend-contract-gemini.md` كاملة وقواعد المشروع، ثم نفّذها خطوة بخطوة. المطلوب استكمال واختبار عقد تحديثات التغطية فقط؛ الـpagination ودعم string/null موجودين بالفعل، فلا تعيد كتابتهم بدون فشل مثبت. حافظ على التصميم والسلوك وكل التعديلات الموجودة، خصوصًا شغل subscription_upgrade. احسم اختلاف مسارات العائلة بدليل قبل تغيير constants؛ لو الدليل غير متاح، اتركها كما هي وكمل الاختبارات المستقلة واذكر العائق. لا تخترع حدود pagination، ولا تعمل live mutations أو تحفظ credentials. سلّم نتائج الاختبارات والتحليل والملفات المعدلة، وميّز اختبارات الـmock عن التحقق الفعلي من السيرفر.
