# Influencer Backend Integration Design

## Scope

Connect the existing influencer experience to the documented backend APIs without redesigning it or introducing business data in the client. The feature remains under `lib/features/influencer`, split internally by responsibility when files become too large:

- Dashboard and referral sharing
- Social links
- Bank account
- Wallet and withdrawals
- Analytics

There is no new influencer profile screen. `GET /influencer-partner/me` supplies identity data needed by the existing social-connections surface.

## Architecture

Each responsibility follows the project's existing flow:

```text
UI -> Event -> ViewModel -> UseCase -> Repository
   -> RemoteDataSource -> ApiServices -> Backend
```

Responses return through nullable response DTOs, mappers, domain entities, `ApiResult`, state, and UI. Retrofit uses the existing `ApiServices` and `Dio`; repositories use `safeApiCall`; dependencies use constructor injection and Injectable.

The existing monolithic fake entity is replaced by focused typed entities. Money remains numeric, dates become `DateTime`, and server statuses are mapped defensively. Presentation owns localized labels, number/date formatting, colors, and assets.

## Feature Organization

Keep one top-level influencer feature. Add focused data, domain, and presentation files using responsibility-specific names. Do not add a generic `shared` directory preemptively. Reusable influencer widgets remain in the existing influencer widgets directory unless real duplication warrants a later extraction.

Large screens are split into content/section widgets. A screen owns routing and state wiring; sections own coherent visual regions such as balance, bank destination, amount form, history filters, analytics summary, chart, and top programs. Sections receive entities and callbacks and do not access repositories or services.

## API Operations

Implement the documented operations:

```text
GET    /api/v1/influencer-partner/me
GET    /api/v1/influencer-partner/me/home
GET    /api/v1/influencer-partner/me/links
GET    /api/v1/influencer-partner/me/bank-account
PUT    /api/v1/influencer-partner/me/bank-account
DELETE /api/v1/influencer-partner/me/bank-account
GET    /api/v1/influencer-partner/me/wallet
POST   /api/v1/influencer-partner/me/withdrawals
GET    /api/v1/influencer-partner/me/withdrawals
GET    /api/v1/influencer-partner/me/withdrawals/{id}
PUT    /api/v1/influencer-partner/me/social-links
GET    /api/v1/influencer-partner/me/analytics?period={period}
```

Do not invent undocumented list-banks, cancel-withdrawal, activities-pagination, or terms endpoints. Bank input remains free text until a banks API is provided.

## Forward Compatibility

Response DTO fields are nullable. Optional support is included for anticipated non-breaking backend additions such as `currencyCode`, withdrawal policy, avatar URL, program ID, analytics granularity, and comparison values. Current documented responses continue to map safely.

Until the backend supplies currency, presentation may use the product's currently documented KWD fallback. This is an explicit compatibility fallback, not stored fake account data. Withdrawal minimum uses backend policy when supplied and the documented 10 KWD contract only while that field is absent.

Unknown enum values map to an `unknown` domain value rather than causing parsing failures. Missing optional display data is handled as absent, not fabricated.

## Loading and Request Strategy

Use lazy loading with in-memory state for the influencer session:

- Dashboard loads `/home` when the influencer area opens.
- Social links load `/me` on first entry.
- Wallet loads `/wallet` on first entry.
- Withdrawal history loads on first entry and again for filter or pagination changes supported by the current API.
- Withdrawal details load by ID.
- Bank account loads on first entry.
- Analytics loads `30d` initially and reloads when the period changes.

Returning to an already loaded surface renders its current state without an automatic duplicate request. Explicit refresh reloads it. Successful financial or bank mutations refresh/invalidate affected data so balances and destinations cannot remain stale.

## Mutation Behavior

Bank save and delete keep the form/content visible during action loading. IBAN is normalized to uppercase alphanumeric text without spaces or hyphens before submission. Client validation mirrors the documented length and required-field rules; backend validation remains authoritative.

Withdrawal submission supports the saved-bank and one-time-bank request shapes. Submission is guarded against repeated taps. When backend idempotency support becomes available, its key can be added at the data boundary. On success, refresh wallet state and withdrawal history.

Social link fields are optional and are normalized consistently at the form boundary. The implementation will not guess undocumented destructive semantics for clearing values; it sends the values represented by the current contract and can be adjusted when the backend defines null-versus-empty behavior.

## Sharing and QR

Discount codes and referral links come only from API entities. Copy uses Flutter clipboard APIs. Native sharing uses `share_plus`, and QR rendering uses `qr_flutter` with `qrCodeData`. Design assets remain local. Package additions are limited to these documented requirements.

## Errors and Empty States

Initial request failure with no usable content uses the existing `ApiErrorWidget`. Partial failures preserve available content and use `InlineApiErrorWidget` where appropriate. Successful empty collections use `EmptyStateWidget`. Retry dispatches only the failed intent.

Action errors keep forms visible. Known backend error codes are routed to the appropriate field or action message, including invalid IBAN, required bank data, insufficient balance, below-minimum withdrawal, existing pending withdrawal, and missing influencer profile. Authentication continues through existing interceptors and global handling.

## Testing

Development follows red-green-refactor. Tests cover:

- Defensive DTO parsing and DTO-to-entity mapping
- IBAN normalization and validation
- Request mapping for saved and one-time bank withdrawals
- Repository success/error paths
- ViewModel loading, success, refresh, mutation, and failure transitions
- Analytics period changes
- Critical widget states and mutation guards where practical

Generated Retrofit, JSON serialization, and Injectable output is produced only by build runner. Completion requires formatting, focused tests, the full relevant test suite, code generation, and Flutter analysis with no new errors.

## Non-Goals

- No new profile screen
- No UI redesign
- No persistent/offline financial cache
- No invented backend endpoints or fields required for current execution
- No unrelated refactoring
- No fake influencer business data after its real replacement is connected
