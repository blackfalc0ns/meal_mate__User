# Customer Delivery Backend Alignment Implementation Plan

**Goal:** Align the customer delivery card, delivery details screen, and realtime invalidation with the official backend contract document (`/api/v1/customer/delivery-widget`, `/api/v1/customer/subscription-days/{subscriptionDayId}/delivery-details`, and `/hubs/customer-delivery`).

**Architecture:** Feature-based Clean Architecture adhering to `rules/ui_rules.md` and `rules/rules_backend.md`. Integrate `signalr_netcore` into `CustomerDeliveryRealtimeService`, add `@Headers({'X-Bilingual': 'true'})`, support multi-box delivery items, enforce exact status mapping, remove device-time fallback on delivered status, and add visible-screen reconciliation timers and app resume refetch.

**Constraints:**
- Do NOT commit changes (`متعملش كوميت لما تخلص`).
- Keep delivery cards inside Calendar screen as confirmed with the user.
- Reuse existing DI (`getIt`), theme (`context.colorScheme`), and localization (`context.localization`).

---

## Tasks

### Task 1: Add `signalr_netcore` dependency
- Modify `pubspec.yaml` to include `signalr_netcore: ^1.4.3`.
- Run `flutter pub get`.

### Task 2: Add `X-Bilingual: true` to Retrofit endpoints
- Modify `lib/core/network/api_services.dart`:
  - Add `@Headers({'X-Bilingual': 'true'})` to `getCustomerDeliveryWidget`.
  - Add `@Headers({'X-Bilingual': 'true'})` to `getCustomerSubscriptionDayDeliveryDetails`.
- Run `dart run build_runner build --delete-conflicting-outputs`.

### Task 3: Update `CustomerDeliveryStatus` enum & mapping
- Modify `lib/features/calendar/domain/entities/customer_delivery_entity.dart`:
  - Add statuses: `notStarted`, `returnedToKitchen`, `frozen`, `trackingUnavailable`.
  - Update `fromString` to parse `notstarted`, `readyforpickup`, `returnedtokitchen`, `frozen`, `tracking_unavailable`, etc.
  - Update localized labels and terminal status checks.

### Task 4: Support multiple delivery boxes (items) in Calendar
- Modify `lib/features/calendar/presentation/manager/overview/calendar_overview_state.dart`:
  - Expose `List<CustomerDeliveryItemEntity> get deliveryItems => deliveryWidget?.items ?? const [];`.
- Modify `lib/features/calendar/presentation/widgets/calendar_selected_day_section.dart`:
  - Pass `overviewData.deliveryItems` to `CalendarDayContent`.
- Modify `lib/features/calendar/presentation/widgets/calendar_day_content.dart`:
  - Render a `CalendarDeliveryCard` for each box in `deliveryItems`.

### Task 5: Delivery button label & Delivered timestamp formatting
- Modify `lib/features/calendar/presentation/widgets/calendar_delivery_track_button.dart`:
  - Set button label to `locale.calendar_delivery_details_title` («التفاصيل» / Details) with appropriate icon.
- Modify `lib/features/calendar/presentation/widgets/calendar_delivery_details_status_hero.dart`:
  - When `isDelivered` is true, check if `deliveredAtUtc` is non-null. If null, show delivered success without timestamp (never substitute `DateTime.now()`).

### Task 6: Implement SignalR Hub Connection in `CustomerDeliveryRealtimeService`
- Modify `lib/features/calendar/data/services/customer_delivery_realtime_service.dart`:
  - Connect to `<API_BASE_URL>/hubs/customer-delivery`.
  - Pass JWT token via `accessTokenFactory`.
  - Listen for `customer-delivery-changed`.
  - Deduplicate `eventId` and validate `schemaVersion == 1`.
  - Trigger `notifyDeliveryChanged(subscriptionDayId)`.
  - Handle auto-reconnect and cleanup on dispose.

### Task 7: Reconciliation Timers & Resume Refetch
- Modify `lib/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart`:
  - Start periodic polling timer based on `refreshAfterSeconds`.
- Modify `lib/features/calendar/presentation/manager/delivery/calendar_delivery_details_view_model.dart`:
  - Inject `CustomerDeliveryRealtimeService`.
  - Listen to `onDeliveryChanged` for matching `subscriptionDayId`.
  - Start periodic polling timer based on `refreshAfterSeconds`.
- Modify `lib/features/calendar/presentation/screens/calendar_screen.dart`:
  - On `AppLifecycleState.resumed`: refetch calendar and delivery widget.
- Modify `lib/features/calendar/presentation/screens/calendar_delivery_details_screen.dart`:
  - Add `WidgetsBindingObserver` to refetch on resume.

### Task 8: Verification & Quality Check
- Run `flutter analyze`.
- Run tests (`flutter test`).
- Ensure no git commits are created.
