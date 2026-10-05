# Address Preview Coverage Pagination — Gemini Implementation Plan

> **For agentic workers:** Use `superpowers:executing-plans` if available and execute task-by-task with the checkboxes below. This handoff is for Gemini; keep execution sequential and review each task before continuing.

**Goal:** Support paginated `servingRestaurants` in customer and family address coverage previews, with shimmer loading, existing core errors, safe retries, and compatibility with legacy responses.

**Architecture:** Extend the existing `UI → Event → AddressesViewModel → UseCase → Repository → RemoteDataSource → ApiServices` flow. Map nullable response DTOs into domain entities, retain the coverage object, and keep pagination state in `AddressCoveragePreviewState`. Reuse Dio, Retrofit, Injectable/GetIt, `ApiResult`, `safeApiCall`, and `lib/core/errors`.

**Tech Stack:** Flutter/Dart, flutter_bloc, Dio, Retrofit, json_annotation/json_serializable, build_runner, Injectable/GetIt, flutter_test, and the existing custom shimmer widgets. No new packages.

**Spec:** `docs/superpowers/specs/2026-10-05-address-preview-coverage-pagination-contract.md`. Read this contract first and also consult `docs/superpowers/specs/2026-09-06-address-coverage-preview-design.md` for the original confirmation flow. The current contract overrides the older spec where pagination differs.

## Global constraints

- Read `AGENTS.md`, `rules/rules_backend.md`, and `rules/ui_rules.md` before implementation. The user explicitly selected `rules/rules_backend.md`; the `rules/backend_rules.md` path mentioned in AGENTS was absent when this plan was prepared. Do not create a duplicate rules file.
- Use `lib/core/errors`; preserve `Failure` in state and use its existing `exception` for core presentation. Do not introduce another error/result system.
- Use `lib/core/widget/shimmer_widget.dart` for coverage data loading. Do not add a shimmer dependency or replace unrelated loading UI.
- Keep DTOs out of Domain and UI. No JSON parsing, Dio calls, Repository calls, or direct UseCase calls in widgets.
- Response fields added in this task must be nullable. Request parameters remain optional and follow the dual contract.
- Generate `.g.dart` files using build_runner. Never edit generated files manually.
- Preserve theme, spacing, styles, localization, server order, and inherited directionality. Do not reverse the restaurant list for Arabic.
- Keep address save/update/set-default separate from preview pagination. Preserve Kuwait bounds checks, notices, conflicts, and confirmation guards.
- At preparation time, unrelated changes existed in `lib/features/calendar/domain/entities/calendar_day_entity.dart` and `lib/features/calendar/presentation/widgets/calendar_meal_card.dart`. Re-check git status; do not edit, stage, revert, or overwrite them.
- Do not change meal details, restaurant menu, subscription flow, or family member setup architecture for this task.
- Backend deployment is pending according to the user's note. Use deterministic local fixtures for tests; do not claim the hosted API has the new contract without a verified deployed response.

## Verified current code and implementation decisions

- `AddressCoveragePreviewRequestDto` already has nullable `page`/`pageSize`; its manual `toJson()` omits null pagination keys. Preserve that omission behavior.
- `CustomerAddressRequestEntity.toPreviewDto()` in `customer_address_mapper.dart` does not currently accept/pass pagination. Add named arguments here, not paging fields to the saved address entity or save DTO.
- `AddressCoveragePreviewResponseDto` and `AddressCoveragePreviewEntity` have no pagination metadata.
- Both Retrofit GET preview methods lack `@Query` parameters.
- `AddressesViewModel` handles customer preview and family POST preview through `configureFamilyMember`. `FamilyAddressesViewModel` manages family setup progression, not coverage paging; do not put pagination there.
- `AddressCoveragePreviewEntity.operator ==` omits `servingRestaurants` and most coverage fields. Pagination append must produce an observable state change; fix equality/hashCode coherently.
- Customer modal builders capture the original `preview`; they must read live state after pagination is added.
- `AddressesScreen._handleState` opens a modal whenever preview is successful; `AddressChooseLocationScreen` compares preview object identity. Both conditions can open duplicate modals on page updates.
- `FamilyAddressLocationStage` renders the coverage sheet inline. Page updates must not reset its entry flow or replay its entrance animation.
- `AppConstants.firstPage == 1` and `defaultPageSize == 20` already exist.
- No standalone reusable pagination metadata DTO/entity was found in the current implementation. Calendar and other features have feature-specific shapes. Create small address metadata types unless an equivalent shared type has been added before execution; do not couple addresses to unrelated feature DTOs.
- `safeApiCall` is defined in `lib/core/network/api_results.dart`, not a separate `safe_api_call.dart`.
- `ErrorMessagePresenter.fromFailure(context, failure)` exists. `ApiErrorWidget` accepts `exception: failure.exception` and `onRetry`.
- `InlineApiErrorWidget` currently contains hardcoded Arabic UI text. Prefer `ApiErrorWidget` in a compact content-sized container or existing localized core components; do not copy the hardcoded strings into this feature.

## Task 1: Parse and map pagination metadata without breaking legacy coverage

**Create:**

- `lib/features/addresses/data/models/response/address_coverage_pagination_response_dto.dart`
- `lib/features/addresses/domain/entities/address_coverage_pagination_entity.dart`

**Modify:**

- `lib/features/addresses/data/models/response/address_coverage_preview_response_dto.dart`
- `lib/features/addresses/domain/entities/address_coverage_preview_entity.dart`
- `lib/features/addresses/data/mapper/customer_address_mapper.dart`

**Test:** Extend `test/address_coverage_preview_test.dart`.

**Interfaces:** `AddressCoveragePreviewResponseDto.pagination` maps to nullable `AddressCoveragePreviewEntity.pagination`; no response wrapper change.

- [ ] Add a failing test for metadata parsing/mapping and legacy omission. Start with this concrete fixture:

```dart
test('coverage maps pagination and accepts an empty page', () {
  final entity = AddressCoveragePreviewResponseDto.fromJson({
    'canSetAsDefault': true,
    'servingRestaurants': <Object?>[],
    'pagination': {
      'totalCount': 41, 'page': 4, 'pageSize': 20, 'totalPages': 3,
      'hasNextPage': false, 'hasPreviousPage': true,
    },
  }).toEntity();
  expect(entity.servingRestaurants, isEmpty);
  expect(entity.pagination?.totalCount, 41);
  expect(entity.pagination?.page, 4);
  expect(entity.pagination?.pageSize, 20);
  expect(entity.pagination?.totalPages, 3);
  expect(entity.pagination?.hasNextPage, isFalse);
  expect(entity.pagination?.hasPreviousPage, isTrue);
  expect(entity.canSetAsDefault, isTrue);
});

test('missing and null pagination preserve legacy coverage', () {
  for (final json in <Map<String, dynamic>>[{}, {'pagination': null}]) {
    expect(AddressCoveragePreviewResponseDto.fromJson(json).toEntity().pagination,
        isNull);
  }
});
```

- [ ] Run `flutter test test/address_coverage_preview_test.dart`; confirm the new metadata expectations fail before implementation.
- [ ] Implement a nullable json_serializable DTO with the exact six wire names:

```dart
@JsonSerializable(createToJson: false)
class AddressCoveragePaginationResponseDto {
  const AddressCoveragePaginationResponseDto({
    this.totalCount, this.page, this.pageSize, this.totalPages,
    this.hasNextPage, this.hasPreviousPage,
  });
  final int? totalCount;
  final int? page;
  final int? pageSize;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;
  factory AddressCoveragePaginationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$AddressCoveragePaginationResponseDtoFromJson(json);
}
```

Add the json_annotation import, matching `part` directive, and `final AddressCoveragePaginationResponseDto? pagination` to the preview DTO constructor/fields.

- [ ] Implement `AddressCoveragePaginationEntity` with the same six nullable primitive fields, const constructor, value equality and consistent hashCode. Nullable fields preserve missing information; use `hasNextPage == true` as the continuation check, and require positive page/pageSize before requesting another page.
- [ ] Add `AddressCoveragePaginationResponseDtoMapper.toEntity()` in the existing mapper and pass `pagination: pagination?.toEntity()` in preview mapping. A metadata object with null fields must parse without crashes and must not cause guessed continuation.
- [ ] Add `AddressCoveragePreviewEntity.copyWith({List<ServingRestaurantEntity>? servingRestaurants, AddressCoveragePaginationEntity? pagination, bool clearPagination = false})`. Copy every existing coverage field unchanged; clearPagination distinguishes explicit null from an omitted argument.
- [ ] Update preview equality/hashCode to include all coverage fields, pagination, and restaurant content. `ServingRestaurantEntity` currently has no value equality: compare its primitive fields in a domain-only helper (ID, both names, logo, rating), or add coherent value equality to that existing entity. Do not import Flutter foundation or DTOs into Domain.
- [ ] Test that a changed restaurant list and changed metadata make previews/states unequal; equal content has equal hashCodes. Test `copyWith` preserves conflicts/notices and can clear pagination.
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`, inspect generated diffs, then rerun the focused test. Do not include unrelated generator churn in the final change.

## Task 2: Carry optional paging through all four endpoint paths

**Modify:**

- `lib/core/network/api_services.dart`
- `lib/features/addresses/data/mapper/customer_address_mapper.dart`
- `lib/features/addresses/domain/repo/addresses_repository.dart`
- `lib/features/addresses/data/repo/addresses_repository_impl.dart`
- `lib/features/addresses/data/data_source/addresses_remote_data_source.dart`
- `lib/features/addresses/data/data_source/addresses_remote_data_source_impl.dart`
- `lib/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart`
- `lib/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart`
- `lib/features/family_addresses/domain/repo/family_addresses_repository.dart`
- `lib/features/family_addresses/data/repo/family_addresses_repository_impl.dart`
- `lib/features/family_addresses/data/data_source/family_addresses_remote_data_source.dart`
- `lib/features/family_addresses/data/data_source/family_addresses_remote_data_source_impl.dart`
- `lib/features/family_addresses/domain/usecase/family_addresses_usecases.dart`

**Tests:** Extend `test/address_coverage_preview_test.dart`; create `test/address_coverage_pagination_transport_test.dart`. Update existing test doubles implementing these interfaces to accept new named arguments.

**Interfaces:** Add optional named `{int? page, int? pageSize}` to customer/family repository preview methods and their UseCase `call` methods. Keep POST datasource arguments as the existing request DTO. Add named arguments to GET datasource methods and GET Retrofit methods.

- [ ] Write failing mapper tests showing both parameters, either parameter alone, and neither parameter. Use the existing valid `CustomerAddressRequestEntity` fixture in `address_coverage_preview_test.dart`:

```dart
final pagedJson = entity.toPreviewDto(page: 2, pageSize: 20).toJson();
expect(pagedJson['page'], 2);
expect(pagedJson['pageSize'], 20);
final legacyJson = entity.toPreviewDto().toJson();
expect(legacyJson.containsKey('page'), isFalse);
expect(legacyJson.containsKey('pageSize'), isFalse);
expect(entity.toPreviewDto(page: 2).toJson().containsKey('pageSize'), isFalse);
expect(entity.toPreviewDto(pageSize: 5).toJson().containsKey('page'), isFalse);
```

- [ ] Change the mapper to `AddressCoveragePreviewRequestDto toPreviewDto({int? page, int? pageSize})` and pass both fields explicitly. Do not fill defaults in the mapper; the UI chooses explicit defaults, while lower layers preserve legacy and partial opt-in requests.
- [ ] Forward named arguments unchanged through repository and UseCase methods. Customer repository POST uses `request.toPreviewDto(page: page, pageSize: pageSize)`. Family repository POST does the same inside its existing `safeApiCall`.
- [ ] Add Retrofit GET query arguments:

```dart
@GET(EndPoints.customerExistingAddressPreviewCoverage)
Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
  @Path('addressId') String addressId, {
  @Query('page') int? page,
  @Query('pageSize') int? pageSize,
});

@GET(EndPoints.familyMemberExistingAddressPreview)
Future<AddressCoveragePreviewResponseDto> previewExistingFamilyMemberAddress(
  @Path('memberId') String memberId,
  @Path('addressId') String addressId, {
  @Query('page') int? page,
  @Query('pageSize') int? pageSize,
});
```

- [ ] Keep endpoint constants/base URL/interceptors unchanged. POST paging belongs in the DTO body, never the URL.
- [ ] Test the generated client with an in-memory Dio interceptor. Use `Dio(BaseOptions(baseUrl: 'https://coverage.test'))`, construct the existing `ApiServices(dio)`, capture `RequestOptions`, and resolve an empty valid preview response. No live endpoint/auth token required:

```dart
final captured = <RequestOptions>[];
dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
  captured.add(options);
  handler.resolve(Response<Map<String, dynamic>>(
    requestOptions: options,
    statusCode: 200,
    data: {'servingRestaurants': <Object?>[], 'pagination': null},
  ));
}));
await api.previewExistingAddressCoverage('address-1', page: 2, pageSize: 20);
expect(captured.single.method, 'GET');
expect(captured.single.queryParameters['page'], 2);
expect(captured.single.queryParameters['pageSize'], 20);
expect(captured.single.path,
    '/api/v1/customers/me/addresses/address-1/preview-coverage');
```

Repeat assertions for customer POST and family POST/GET, including body-only/query-only routing, member/address IDs, legacy omission, and partial opt-in. Assert actual outgoing requests, not source-code strings.

- [ ] Test the repository path separately with recording datasource fakes, checking resulting metadata and that a Dio failure becomes `ApiErrorResult` through existing `safeApiCall`. Update signatures of fakes across current tests; do not weaken assertions to make tests compile.
- [ ] Regenerate using build_runner and run the mapper/transport tests. Verify only required generated files changed.

## Task 3: Add coverage session state, incremental loading, retry, and race guards

**Modify:**

- `lib/features/addresses/presentation/manager/addresses_event.dart`
- `lib/features/addresses/presentation/manager/addresses_state.dart`
- `lib/features/addresses/presentation/manager/addresses_view_model.dart`

**Test:** Create `test/address_coverage_pagination_view_model_test.dart`. Reuse constructor/test-double patterns from `test/family_saved_address_prefill_test.dart` and existing address tests.

**Interfaces:**

```dart
class LoadMoreAddressCoverageRestaurantsEvent extends AddressesEvent {
  const LoadMoreAddressCoverageRestaurantsEvent();
}
class RetryAddressCoveragePreviewEvent extends AddressesEvent {
  const RetryAddressCoveragePreviewEvent();
}
```

Extend `AddressCoveragePreviewState` with `int sessionId = 0`, `bool isLoadingMore = false`, `Failure? loadMoreFailure`, and `bool reachedEnd = false`. Add `clearLoadMoreFailure` to copyWith and include every new field in equality/hashCode. Derived `canLoadMore` requires a successful preview, valid metadata, `hasNextPage == true`, and `!reachedEnd`.

- [ ] Write a failing end-to-end ViewModel test with a controlled repository fixture: first page has restaurant `a`; second page has `b`; state becomes `[a,b]`, metadata.page becomes 2, and the captured calls are `(1,20)` then `(2,20)`. Call `doIntent`, not private handlers. Wait for stream predicates/completers instead of arbitrary sleeps.
- [ ] Write a duplicate request test using a Completer for page 2; dispatch load-more twice before resolving it and assert one second-page call.
- [ ] Use a monotonically increasing `_coverageSessionId` private counter. Increment when starting a new/updated/by-ID preview, clearing coverage, invalidating family operations, changing member, or confirming a pending action. Store the sessionId in coverage state; do not reset the counter to zero when clearing state.
- [ ] At first-page request start replace coverage substate with fresh loading state containing sessionId, pending action/request/address ID. Explicitly call preview UseCases with `AppConstants.firstPage` and `AppConstants.defaultPageSize`. Preserve bounds checks and capture family context/generation before awaiting.
- [ ] Guard EVERY preview response (including errors and initial requests) with `isClosed`, captured sessionId, and captured member context. A stale error must not replace the new preview or stop the new session's loading indicator.
- [ ] Implement `_loadMoreAddressCoverageRestaurants()` and dispatch it through `doIntent`. Guards must run before emitting or calling a UseCase:

```dart
final current = state.coveragePreview;
final preview = current.preview;
final meta = preview?.pagination;
if (isClosed || current.isLoading || current.isLoadingMore ||
    state.action.isLoading || !current.canLoadMore || preview == null ||
    meta == null) return;
final page = meta.page;
final pageSize = meta.pageSize;
if (page == null || page < 1 || pageSize == null || pageSize < 1) return;
final nextPage = page + 1;
final sessionId = current.sessionId;
```

Select the same request source as the first page: pending request for add/update goes through POST; saved address ID for set-default goes through GET. The family POST source uses the captured member ID and `PreviewFamilyMemberAddressUseCase`. Existing family GET methods receive transport support in Task 2; do not invent a new family default-address user flow merely to call them.

- [ ] Set only `isLoadingMore: true` and `clearLoadMoreFailure: true`; retain `isSuccess`, preview, pending action, and first-page failure fields. Use `_requestCoveragePage(AddressCoveragePreviewState context, {required int page, required int pageSize})` returning `Future<ApiResult<AddressCoveragePreviewEntity>>` if it prevents duplicating endpoint selection; it must use existing UseCases only.
- [ ] Merge page success into the captured preview by ID, retaining first-seen server order. IDs can be empty because DTO mapping is defensive: do not collapse all empty IDs into one restaurant. Treat empty-ID entries as distinct. Use an immutable list:

```dart
final seen = <String>{
  for (final item in preview.servingRestaurants)
    if (item.id.isNotEmpty) item.id,
};
final merged = <ServingRestaurantEntity>[...preview.servingRestaurants];
for (final item in incoming.servingRestaurants) {
  if (item.id.isEmpty || seen.add(item.id)) merged.add(item);
}
final updated = preview.copyWith(
  servingRestaurants: List.unmodifiable(merged),
  pagination: incoming.pagination,
  clearPagination: incoming.pagination == null,
);
```

Keep initial coverage flags/notices/pending request; pagination is for the list, not a re-interpretation of confirmation eligibility. On success set `isLoadingMore: false`, clear load-more failure, and replace preview with `updated`.

- [ ] Stop continuation when metadata is null, hasNextPage is false, the incoming list is empty, or the response page fails to advance. Set `reachedEnd` for defensive empty/non-advancing responses even if contradictory metadata says there is another page. This prevents automatic loops; ordinary empty out-of-range pages remain successful.
- [ ] On incremental error preserve accumulated items and current successful page; set `isLoadingMore: false`, `loadMoreFailure: result.failure`. Do not advance the page. Scroll auto-loading pauses while loadMoreFailure exists; explicit retry dispatches the same load-more event and retries `meta.page + 1`.
- [ ] Implement first-page retry using retained pendingAction/pendingRequest/targetAddressId and the original source. It starts a fresh session and does not save anything. First-page failures must retain these inputs.
- [ ] Test: legacy/null metadata stops; final page stops; empty page keeps previous items; duplicate IDs deduplicate; missing IDs are preserved; page error retains old items; retry requests the same page; new preview resets page to 1; confirm and clear invalidate pending requests; same-address new preview still gets a new sessionId.
- [ ] Use Completers to test out-of-order initial responses, clear during page fetch, new address during page fetch, member switch during initial/page fetch, family operation invalidation, and completion after close. Test stale failures as well as successes.
- [ ] Keep first-page `isLoading` separate from `isLoadingMore`. Confirmation uses existing eligibility flags and is not disabled solely because more restaurant cards are loading.
- [ ] Run `flutter test test/address_coverage_pagination_view_model_test.dart` and existing family address tests before moving to UI.

## Task 4: Build horizontal pagination UI with shimmer and core errors

**Create:**

- `lib/features/addresses/presentation/widgets/address_coverage_restaurants_list.dart`
- `lib/features/addresses/presentation/widgets/address_coverage_loading_skeleton.dart`

**Modify:** `lib/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart`.
**Test:** Extend `test/address_coverage_preview_bottom_sheet_test.dart`; create `test/address_coverage_restaurants_pagination_test.dart`.

**Interfaces:** Add optional constructor properties to the existing bottom sheet so old consumers keep compiling:

```dart
final bool isLoadingMore; // default false
final bool hasMoreRestaurants; // default false
final Failure? loadMoreFailure;
final VoidCallback? onLoadMoreRestaurants;
```

The new list receives `List<ServingRestaurantEntity> restaurants` and these four values. Error retry calls onLoadMoreRestaurants; ViewModel owns retry/page logic. `AddressCoverageLoadingSkeleton` provides a `restaurantsOnly` mode for an appended placeholder card versus an initial coverage placeholder panel.

- [ ] Write a failing widget test: real restaurant cards remain visible while `isLoadingMore: true`, `ShimmerWidget` exists, and the list does not show `CustomProgressIndicator` for pagination. Keep existing submission tests unchanged: save/submission feedback is a different operation.
- [ ] Extract the existing horizontal list/card UI intact into `AddressCoverageRestaurantsList`. It owns a stable ScrollController initialized once and disposed in `dispose`. Do not put API calls inside build or itemBuilder.
- [ ] Use a controller listener for horizontal continuation. With positive valid content dimensions, trigger when `position.extentAfter <= position.viewportDimension`; guard `hasMoreRestaurants && !isLoadingMore && loadMoreFailure == null && onLoadMoreRestaurants != null`. `extentAfter` works with inherited RTL; do not compare left/right pixels manually.
- [ ] Handle a first page that fits the viewport using a single scheduled post-frame dimension check from initState/didUpdateWidget, with mounted and the same loading/failure/continuation guards. Stop the automatic chain if the ViewModel reports reachedEnd/non-advancement. Do not schedule a post-frame request from every build.
- [ ] Prevent duplicate UI callbacks by recording the last automatically requested restaurant count until data length or request lifecycle changes. ViewModel still enforces the authoritative in-flight guard. Do not auto-retry on failure.
- [ ] Preserve scroll offset on loading and append. Reset via a ValueKey tied to sessionId at the host boundary when a genuinely new preview starts, not on every page.
- [ ] Append one restaurant-sized shimmer item in the existing row only while loadingMore. Build it using `ShimmerWidget`/`ShimmerPlaceholder`, matching the existing card bounds, logo, name, and rating placeholders. Derive dimensions from the extracted existing layout; add no arbitrary colors or typography.
- [ ] Build the initial skeleton from the existing header/list/button panel structure, excluding fabricated coverage success/failure text. It is visual placeholder content, not a fake preview entity. Initial confirmation is unavailable until real coverage arrives.
- [ ] Display loadMoreFailure beneath the horizontal row without removing cards. Reuse core presentation:

```dart
if (loadMoreFailure != null)
  ApiErrorWidget(
    exception: loadMoreFailure!.exception,
    onRetry: onLoadMoreRestaurants,
  ),
```

Inspect core error widget sizing before embedding: constrain only as needed by the current sheet, preserving scrollability on small screens. Do not copy the hardcoded Arabic InlineApiErrorWidget design. Initial errors similarly use ApiErrorWidget with first-page retry. If a localized snackbar is used for an existing initial-error path, call `ErrorMessagePresenter.fromFailure(context, failure)`.

- [ ] Keep `canSetAsDefault`, `requireFamilyCoverage`, conflict handling, notice, and confirm callbacks intact. Incremental empty/error states must not replace a populated list with the no-restaurants notice.
- [ ] Test LTR and RTL drag-to-end, short-list initial fill, no continuation without metadata, one callback while loading, no auto-retry after error, explicit retry, stable scroll offset, and disabled confirmation for uncovered/family-empty coverage.
- [ ] Shimmer animations loop: use bounded `tester.pump(Duration(...))`, not pumpAndSettle while shimmer is active. Test animation absence after successful/error completion and disposal safety.
- [ ] Run `flutter test test/address_coverage_restaurants_pagination_test.dart test/address_coverage_preview_bottom_sheet_test.dart`.

## Task 5: Wire live preview state into modal and family hosts

**Modify:**

- `lib/features/addresses/presentation/screens/address_choose_location_screen.dart`
- `lib/features/addresses/presentation/screens/addresses_screen.dart`
- `lib/features/family_addresses/presentation/widgets/family_address_location_stage.dart`

**Tests:** Create `test/address_coverage_pagination_modal_test.dart`; extend related navigation/family tests where behavior changes.

**Consumes:** Task 3 sessionId/loading/error state and Events; Task 4 list/skeleton properties.

- [ ] First write a failing host regression test: open coverage once, append page 2, assert one visible modal and both page restaurants. Record modal openings with a NavigatorObserver or the existing test harness rather than counting text alone.
- [ ] Make modal opening depend on first-page loading transition for a new session, not preview object identity or `isSuccess` alone. Use a preview-specific listener condition such as:

```dart
previous.coveragePreview.sessionId != current.coveragePreview.sessionId &&
current.coveragePreview.isLoading
```

Open the panel at request start to show initial shimmer, then update that same panel on success/failure. Existing action listeners remain separate. If an older modal is still showing, close/invalidate it before opening the new session; never stack coverage modals.

- [ ] Put the active sessionId into the modal closure. Within its narrow BlocSelector/BlocBuilder, read `innerState.coveragePreview` for the live preview, first-page error/loading, and loadMore state; do not pass the originally captured preview.
- [ ] Route initial state to `AddressCoverageLoadingSkeleton`, initial failure to `ApiErrorWidget(exception: failure.exception, onRetry: RetryAddressCoveragePreviewEvent)`, and successful state to the live bottom sheet. Buttons remain absent/disabled during initial loading.
- [ ] First-page retry may create a fresh sessionId while the existing modal remains open: update the modal's active session identity rather than opening another route. Keep one host-owned `_isCoverageSheetOpen` guard and the active session token. Track the session being rendered when the modal closes so cleanup cannot clear a newer session.
- [ ] On ordinary dismiss/choose-another, dispatch ClearCoveragePreviewEvent and invalidate pending paging. On confirm, the existing handler already captures pending inputs before clearing; preserve that order. A modal `finally` block should clear only the session it owns, and only while context/ViewModel remain alive.
- [ ] Separate data loading overlays from save overlays. For coverage initial loading, show the new skeleton panel instead of the generic spinner overlay. Keep `AddressLoadingOverlay` for save/submission work; do not change map/geocode loading or unrelated skeletons.
- [ ] Wire pagination callback in every successful host:

```dart
onLoadMoreRestaurants: () => context.read<AddressesViewModel>().doIntent(
  const LoadMoreAddressCoverageRestaurantsEvent(),
),
isLoadingMore: coverage.isLoadingMore,
hasMoreRestaurants: coverage.canLoadMore,
loadMoreFailure: coverage.loadMoreFailure,
```

Use the appropriate modal context that contains BlocProvider.value. Key the restaurant list with coverage.sessionId, not the entire sheet's page metadata.

- [ ] In `FamilyAddressLocationStage`, show the coverage skeleton/error/success within the existing inline panel position. Keep the current family stage/navigation rules and `popOnConfirm: false`. Tie entry-stage changes and entrance animation to session start/success, not every preview object replacement.
- [ ] Keep reactive rebuilds limited: select `(coveragePreview, action.isLoading)` for the coverage panel; map widget rebuilding should observe locations and initial/save busy flags only, not page appends. Do not reload the map or replay the panel animation when page 2 arrives.
- [ ] Replace coverage-related raw `displayErrorMessage` snackbar output with core ErrorMessagePresenter if it remains visible. Avoid presenting the same failure both in the panel and via snackbar. Leave unrelated action/error flows outside scope unless required by the wiring.
- [ ] Verify `address.page_overflow` goes through Failure.exception/core presentation. Unknown unmapped backend codes should show the core fallback, not a raw code. An ordinary out-of-range successful page must not open an error panel. Add a focused mapping/localization test only if a new user-facing mapping is necessary; no invented server error schema.
- [ ] Test modal remains one route after shimmer → success → append → page failure → retry; dismiss during loading ignores completion; new session after dismissal opens once; confirm invokes one save/default operation; choosing another makes no persistence call; family member switch discards prior results.
- [ ] Retest `test/address_save_navigation_test.dart`, `test/address_entry_flow_controller_test.dart`, `test/family_saved_address_prefill_test.dart`, and `test/family_address_options_test.dart`.

## Task 6: Final validation and Gemini delivery

**Files:** Required source/test/generated changes from Tasks 1–5 only. Core errors, localization, and DI files are read-only unless a verified new dependency or error mapping requires a minimal change.

- [ ] Check `git diff --name-only` and `git diff --check`. Verify no unrelated calendar/menu/meal-details edits or mass generator churn.
- [ ] Run generation once after final source edits:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

If localization was actually changed, run `flutter gen-l10n`; never edit generated translations manually.

- [ ] Format only changed Dart files. In PowerShell:

```powershell
$coverageChangedDart = @(git diff --name-only -- '*.dart' | Where-Object {
  $_ -match '^lib/features/(addresses|family_addresses)/' -or
  $_ -eq 'lib/core/network/api_services.dart' -or
  $_ -match '^test/address_coverage_'
})
if ($coverageChangedDart.Count -gt 0) { dart format @coverageChangedDart }
```

Also pass each newly created untracked Dart source/test to `dart format` explicitly; git diff does not list untracked files. Do not format unrelated working-tree files.

- [ ] Run focused tests and analysis:

```powershell
flutter test test/address_coverage_preview_test.dart test/address_coverage_pagination_transport_test.dart test/address_coverage_pagination_view_model_test.dart test/address_coverage_restaurants_pagination_test.dart test/address_coverage_preview_bottom_sheet_test.dart test/address_coverage_pagination_modal_test.dart
flutter test test/address_save_navigation_test.dart test/address_entry_flow_controller_test.dart test/family_saved_address_prefill_test.dart test/family_address_options_test.dart test/family_addresses_view_model_test.dart
flutter analyze
```

Record any existing analyzer failures separately; do not claim clean analysis if it failed. Broaden testing only for justified interface effects or unresolved failures. Update required test doubles without changing unrelated production code.

- [ ] Manually inspect customer add/edit/default and family preview in Arabic and English: first-page shimmer, long horizontal list, automatic append, incremental shimmer, retry, confirmation eligibility, short viewport, modal dismissal, and family switch. Inspect existing Figma only if a design change is needed; do not claim a Figma review that was not performed.
- [ ] If the backend has been deployed and valid session/access is available, smoke-test all four endpoints with page 1/page 2, partial opt-in, legacy omission, and a page beyond totalPages. Read-only preview calls only; do not create/save/default real addresses as a smoke test. If access/deployment is unavailable, report that as unverified while keeping local tests authoritative for the client implementation.
- [ ] Review acceptance criteria against the companion contract. Confirm continuation uses backend metadata, null metadata stops, no source-side reordering, no duplicate route, same failed page retry, and stale response/error guards.
- [ ] Deliver changed-file summary, actual generation/format/analyzer/test results, manual verification performed, and remaining backend deployment dependency. Keep uncommitted work reviewable; do not automatically commit, push, or deploy.

## Definition of done

- [ ] Four endpoint transports conform to the dual contract.
- [ ] Domain/data/public methods preserve optional pagination semantics.
- [ ] Coverage metadata reaches UI state and updates equality correctly.
- [ ] First-page and incremental loading use shimmer.
- [ ] Existing results and confirmation remain usable during load-more failure/loading.
- [ ] Errors use core infrastructure with explicit retry and localized messages.
- [ ] Customer modals use live state and open once per session; family inline behavior remains correct.
- [ ] Duplicate calls, duplicate IDs, stale responses, non-advancing pages, and disposal are tested.
- [ ] Existing save/navigation/bounds/family regressions remain covered.
- [ ] No unrelated changes, new packages, or manual generated-file edits.

## Copy/paste handoff for Gemini

```text
Implement docs/superpowers/plans/2026-10-05-address-preview-coverage-pagination-gemini.md task-by-task.
Read the companion contract, AGENTS.md, rules/rules_backend.md, rules/ui_rules.md,
and the current lib/core/errors infrastructure first.
Use existing architecture, ApiResult/safeApiCall, Retrofit, DTO → Mapper → Entity,
sealed Events/doIntent, and core ShimmerWidget/ShimmerPlaceholder.
Support customer and family POST/GET preview pagination, legacy pagination:null,
horizontal incremental loading, core errors/retry, safe session invalidation,
and one live-state modal per session.
Do not change unrelated calendar/menu/meal-details work, add packages, edit
generated files manually, or commit/push/deploy automatically.
Write meaningful failing tests before implementation and report actual results.
```
