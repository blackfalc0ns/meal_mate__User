# Calendar Delivery Integration Implementation Plan

**Goal:** Add the delivery card to the selected Calendar day and add the Figma delivery details/success flow using the provided REST and SignalR contract.

**Architecture:** Extend the existing Calendar clean architecture. REST DTOs map to delivery domain entities, a shared delivery repository feeds both the selected-day card and the details screen, and one authenticated SignalR connection invalidates the visible snapshots. The UI remains driven by the existing Calendar ViewModels and localization/theme systems.

**Design references:**
- Figma node `3405:7839` — delivery card inside a Calendar day.
- Figma node `1836:15786` — delivery details/success states.
- Backend guide supplied by the user: delivery widget, details endpoint, and `customer-delivery-changed` SignalR event.

## Global constraints

- Keep all work inside `lib/features/calendar` plus the existing shared network, DI, routing, and localization files that must be extended.
- Reuse the existing Dio, Retrofit, ApiResult, safeApiCall, Injectable, ViewModel, theme, spacing, and localization infrastructure.
- Never expose DTOs to widgets or domain code.
- Use `subscriptionDayId` as the navigation key; never use `orderId` or `tripStopId` as the sole key.
- Use `Accept-Language` and `X-Bilingual: true` through the existing interceptors.
- Do not invent missing timestamps, ETA, driver data, colors, spacing, or copy.

## Task 1: Inspect and lock the existing Calendar integration points

**Files:** existing Calendar screen, selected-day section, overview state/ViewModel, routing, theme, localization.

- Verify the exact Figma nodes and record their measured layout, assets, colors, typography, and interaction labels.
- Identify the selected-day date source and the existing loading/error/empty-state composition.
- Identify the existing app route registration and the project’s preferred navigation coordinator pattern.
- Confirm available theme colors, styles, spacing constants, icons, and localization keys before creating anything.

## Task 2: Add delivery network contracts

**Create:** `calendar/data/models/response/customer_delivery_response_dto.dart` and generated output.

**Modify:** `lib/core/network/network_constants.dart`, `lib/core/network/api_services.dart`.

- Add `GET /api/v1/customer/delivery-widget` with optional `serviceDate` and `subscriptionId` queries.
- Add `GET /api/v1/customer/subscription-days/{subscriptionDayId}/delivery-details`.
- Model nullable response fields for the widget envelope, details envelope, delivery item, driver, vehicle, and location.
- Run `dart run build_runner build --delete-conflicting-outputs` and do not hand-edit generated files.

## Task 3: Add domain entities and mapping

**Create:** delivery entities under `calendar/domain/entities` and a mapper under `calendar/data/mapper`.

- Map DTOs to domain-safe entities without JSON annotations.
- Preserve nullable business values such as ETA, driver, avatar, rating, location, and timestamps.
- Add helpers for terminal status, completed timeline stages, localized status/name/vehicle labels, and whether the tracking CTA is allowed.
- Ensure `Delivered` uses `deliveredAtUtc`; never substitute `readyAtUtc`.

## Task 4: Add data source, repository, and use cases

**Modify:** existing Calendar remote data source and repository contracts/implementations.

**Create:** `get_customer_delivery_widget_usecase.dart` and `get_customer_delivery_details_usecase.dart`.

- Add remote methods for the two endpoints.
- Use `safeApiCall` in the repository implementation.
- Return domain entities through `ApiResult`.
- Keep widget and details reads backed by the same repository/cache source.

## Task 5: Extend Calendar state and loading flow

**Modify:** Calendar overview state/ViewModel/events as required by existing patterns.

- When a day is selected, format the selected date as `yyyy-MM-dd` and request the delivery widget for that date.
- Store all returned items; never use only the first item.
- Keep independent loading/error state for meals and delivery so one cannot hide the other.
- Treat HTTP 200 with `items: []` as a normal empty delivery result.
- On resume/reconnect, refetch the selected day’s delivery snapshot.

## Task 6: Build the delivery card inside Calendar

**Create:** focused widgets under `calendar/presentation/widgets` (one custom widget per file).

- Insert the delivery card into the selected-day content at the exact Figma position.
- Render one card per delivery item.
- Render status, driver, avatar, rating, ETA, timeline, order code, vehicle/delivery metadata, and CTA only when the corresponding entity values exist.
- Show `تتبع الطلب` only for `OutForDelivery` when tracking is available.
- Hide ETA/location/tracking for terminal states and show the success state for `Delivered`.
- Use existing colors, styles, spacing, assets, and localization; use directional layout APIs.

## Task 7: Add the delivery details screen

**Create:** `calendar/presentation/screens/calendar_delivery_details_screen.dart` and its focused child widgets.

**Modify:** existing routes/navigation coordinator only.

- Register a local app route carrying `subscriptionDayId`.
- On screen open, call the details use case and render loading, loaded, empty/not-found, offline, 401, 403, and 5xx states.
- Match Figma node `1836:15786` for in-progress and delivered states.
- Show the timeline from actual timestamps/status evidence.
- For `Delivered`, show success and actual delivery time; do not show ETA or live tracking.
- Keep the back/home actions local; do not navigate to an API URL.

## Task 8: Add shared SignalR invalidation

**Create/modify:** the project’s existing realtime/service location and Calendar lifecycle owner.

- Connect to `<API_ORIGIN>/hubs/customer-delivery` with the authenticated token factory.
- Listen to `customer-delivery-changed` with payload `eventId`, `subscriptionDayId`, `occurredAtUtc`, and `schemaVersion`.
- Ignore unsupported schema versions and duplicate event IDs.
- Treat the event as invalidation only, then refetch REST snapshots for matching visible resources.
- Avoid a new connection per card or screen.
- Stop connection/timers and clear snapshots on logout.

## Task 9: Add localization and accessibility

**Modify:** all configured localization files and the new widgets/screens.

- Add labels for delivery states, timeline stages, stale/offline messages, empty state, retry, details, tracking, and rating actions.
- Use inherited `Directionality`; do not branch on language code.
- Add semantic labels to status, ETA, driver, order number, timeline, and action buttons.
- Preserve keyboard/focus order and readable status announcements.

## Task 10: Tests and verification

**Create:** DTO/mapper/repository/ViewModel/widget tests following existing test patterns.

- Test nullable parsing and nested objects.
- Test every delivery status and timeline rule.
- Test `items: []`, multiple items, missing ETA, missing driver, and terminal states.
- Test details before assignment, during delivery, and after delivery.
- Test SignalR invalidation, duplicate events, reconnect, resume, logout, and stale snapshots.
- Test Arabic and English rendering with RTL/LTR.
- Run:

```text
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
```

- Compare the two requested Figma nodes at representative loading, in-progress, and delivered states before reporting completion.

