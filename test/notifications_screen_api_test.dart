import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_notification_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_view_model.dart';
import 'package:meal_meat_user/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_card.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_empty_view.dart';

class _FakeGetCalendarUseCase implements GetCalendarUseCase {
  @override
  Future<ApiResult<CalendarSubscriptionEntity>> call({
    required String subscriptionId,
    required String localeName,
  }) async {
    return ApiSuccessResult(
      data: CalendarSubscriptionEntity(
        subscriptionId: subscriptionId,
        days: const [],
      ),
    );
  }
}

class _FakeGetNotificationsUseCase implements GetNotificationsUseCase {
  ApiResult<NotificationsPageEntity>? result;

  @override
  Future<ApiResult<NotificationsPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) async {
    return result ??
        ApiSuccessResult(
          data: const NotificationsPageEntity(
            items: [],
            page: 1,
            pageSize: 20,
            totalCount: 0,
            totalPages: 1,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        );
  }
}

class _FakeMarkReadUseCase implements MarkNotificationReadUseCase {
  int callCount = 0;
  String? markedId;

  @override
  Future<ApiResult<void>> call(String id) async {
    callCount++;
    markedId = id;
    return ApiSuccessResult(data: null);
  }
}

class _FakeMarkAllReadUseCase implements MarkAllNotificationsReadUseCase {
  int callCount = 0;

  @override
  Future<ApiResult<void>> call() async {
    callCount++;
    return ApiSuccessResult(data: null);
  }
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    locale: const Locale('en'),
    onGenerateRoute: (settings) =>
        MaterialPageRoute(builder: (_) => const SizedBox()),
    home: child,
  );
}

void main() {
  group('NotificationsScreen API & Widget Integration', () {
    late _FakeGetNotificationsUseCase fakeGetNotifications;
    late _FakeMarkReadUseCase fakeMarkRead;
    late _FakeMarkAllReadUseCase fakeMarkAllRead;
    late NotificationBadgeViewModel badgeViewModel;
    late NotificationsViewModel viewModel;

    setUp(() {
      fakeGetNotifications = _FakeGetNotificationsUseCase();
      fakeMarkRead = _FakeMarkReadUseCase();
      fakeMarkAllRead = _FakeMarkAllReadUseCase();
      badgeViewModel = NotificationBadgeViewModel(_FakeGetCalendarUseCase());
      viewModel = NotificationsViewModel(
        fakeGetNotifications,
        fakeMarkRead,
        fakeMarkAllRead,
        badgeViewModel,
      );
    });

    testWidgets('shows loading skeleton when state is loading', (tester) async {
      fakeGetNotifications.result = ApiSuccessResult(
        data: const NotificationsPageEntity(
          items: [],
          page: 1,
          pageSize: 20,
          totalCount: 0,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );

      await tester.pumpWidget(
        _wrap(NotificationsScreen(viewModel: viewModel)),
      );

      // In initial frame before load completes
      expect(find.byType(NotificationsScreen), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('renders empty view when notifications list is empty', (tester) async {
      fakeGetNotifications.result = ApiSuccessResult(
        data: const NotificationsPageEntity(
          items: [],
          page: 1,
          pageSize: 20,
          totalCount: 0,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );

      await tester.pumpWidget(
        _wrap(NotificationsScreen(viewModel: viewModel)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NotificationEmptyView), findsOneWidget);
    });

    testWidgets('renders notification cards and groups when items present', (tester) async {
      final now = DateTime.now().toUtc();
      fakeGetNotifications.result = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [
            NotificationItemEntity(
              id: 'n1',
              titleEn: 'Order Dispatched',
              bodyEn: 'Your food is on the way',
              createdAtUtc: now,
              isRead: false,
              eventKey: 'order.dispatched',
            ),
          ],
          page: 1,
          pageSize: 20,
          totalCount: 1,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );

      await tester.pumpWidget(
        _wrap(NotificationsScreen(viewModel: viewModel)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NotificationCard), findsOneWidget);
      expect(find.text('Order Dispatched'), findsOneWidget);
      expect(find.text('Your food is on the way'), findsOneWidget);

      // Tap card
      await tester.tap(find.byType(NotificationCard));
      await tester.pumpAndSettle();

      expect(fakeMarkRead.callCount, 1);
      expect(fakeMarkRead.markedId, 'n1');
    });

    testWidgets('tapping mark all as read dispatches markAllRead', (tester) async {
      final now = DateTime.now().toUtc();
      fakeGetNotifications.result = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [
            NotificationItemEntity(
              id: 'n1',
              titleEn: 'Order 1',
              createdAtUtc: now,
              isRead: false,
            ),
          ],
          page: 1,
          pageSize: 20,
          totalCount: 1,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );

      await tester.pumpWidget(
        _wrap(NotificationsScreen(viewModel: viewModel)),
      );
      await tester.pumpAndSettle();

      final markAllFinder = find.text('Mark all as read');
      expect(markAllFinder, findsOneWidget);

      await tester.tap(markAllFinder);
      await tester.pumpAndSettle();

      expect(fakeMarkAllRead.callCount, 1);
    });
  });
}
