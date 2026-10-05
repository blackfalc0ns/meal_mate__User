# Address Preview Coverage Pagination Contract

**Date:** 2026-10-05
**Source:** Backend change note supplied by the user in this conversation. Backend changes were reported as implemented, uncommitted, and pending deployment. This document does not assert that the hosted API has been deployed or tested.
**Client requirements:** Prepare a complete Gemini implementation plan; use `rules/rules_backend.md`, the existing `lib/core/errors` infrastructure, and shimmer for coverage data loading.

## Backend contract

Pagination applies to `servingRestaurants` inside the existing coverage response. The response remains a coverage object; it does not become an `items` envelope.

| Endpoint constant in `lib/core/network/network_constants.dart` | Method | Pagination location |
| --- | --- | --- |
| `customerAddressPreviewCoverage` | POST | JSON body |
| `customerExistingAddressPreviewCoverage` | GET | Query string |
| `familyMemberAddressPreview` | POST | JSON body |
| `familyMemberExistingAddressPreview` | GET | Query string |

Customer paths are `/api/v1/customers/me/addresses/preview-coverage` and `/api/v1/customers/me/addresses/{addressId}/preview-coverage`.
Family paths are `/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/preview-coverage` and `/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/{addressId}/preview-coverage`.

- Neither `page` nor `pageSize` supplied: legacy unpaged response with `pagination: null`.
- Either supplied: pagination enabled; omitted page defaults to 1 and omitted pageSize defaults to 20 on the server.
- Paged response contains `pagination: {totalCount, page, pageSize, totalPages, hasNextPage, hasPreviousPage}`.
- Page beyond the last page: HTTP success, empty `servingRestaurants`, and pagination metadata. Do not turn it into a client failure.
- `address.page_overflow` is an integer overflow guard, not the result of requesting an ordinary page past the end.
- Ordering is server-owned: `TradeNameAr`, then `Id`. Do not sort or reverse client results.
- The backend reuses `CustomerPaginationMetaDto` from ProgramsSubscriptions.Flow. That backend class name does not require creating a client dependency on a subscription feature.
- Existing coverage flags, subscription constraints, notices, and explicit confirmation semantics remain authoritative.

Illustrative paged response fragment (other coverage fields remain present):

```json
{
  "servingRestaurants": [],
  "pagination": {
    "totalCount": 41,
    "page": 4,
    "pageSize": 20,
    "totalPages": 3,
    "hasNextPage": false,
    "hasPreviousPage": true
  }
}
```

## Client behavior to implement

1. Explicitly request first page 1, size 20 in existing preview UI flows, using `AppConstants.firstPage` and `AppConstants.defaultPageSize`.
2. Keep optional nullable pagination parameters through the domain/data APIs so callers can still request legacy behavior and can send either parameter alone.
3. Load subsequent pages when the horizontal restaurant list approaches its end; append unique restaurant IDs in server order.
4. Use metadata as the continuation authority. Null/absent pagination means show the returned list and stop. Do not infer continuation from list length or silently fetch every page.
5. Retain results and confirmation eligibility during pagination loading/failure. Pagination must not save an address or call set-default.
6. Show existing core shimmer primitives for first preview loading and incremental loading. Keep existing save/submission feedback separate.
7. Use `Failure`, `ApiResult`, `safeApiCall`, `ApiErrorWidget`, and `ErrorMessagePresenter` from the existing infrastructure. Keep first-page and incremental failures separate.
8. Ignore responses from superseded previews, cleared previews, confirmed actions, previous family members, and disposed ViewModels.
9. Open one modal per preview session; page appends must update the open modal, not open another one. Preserve modal dismissal and family inline stage behavior.
10. Preserve design, localization, RTL/LTR behavior, architecture, and existing unrelated working-tree changes.

## UI evidence and verification boundary

The existing coverage bottom sheet has a horizontal list with height 115, restaurant card width 104, and logo size 38. These are observed existing code dimensions, not newly verified Figma measurements. Derive loading skeletons from that existing card structure; do not introduce a redesign or claim Figma inspection/pixel-perfect validation. If a new design decision becomes necessary, follow `rules/ui_rules.md` before implementing it.

## Acceptance criteria

- All four endpoints carry pagination in the correct location and parse both response contracts.
- Customer add/edit/default and family preview flows support incremental restaurant loading.
- Repeated scroll events issue one in-flight request; retry uses the same failed page; changing context discards stale results.
- Empty final/out-of-range pages preserve accumulated restaurants and coverage fields.
- Initial and incremental data loading use shimmer; save behavior remains intact.
- Errors use the existing core system and are localized; no raw transport error/code is introduced as visible copy.
- Tests cover serialization, transport, mapper, state, races, modal lifecycle, shimmer, retry, and RTL/LTR.
- Gemini reports actual formatter/analyzer/test results and separately reports whether a deployed backend smoke test was possible.
