import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_notification_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_view_model.dart';
import 'package:meal_meat_user/features/notifications/presentation/screens/notifications_screen.dart';

class _FakeGetCalendarUseCase implements GetCalendarUseCase {
  int callCount = 0;

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> call({
    required String subscriptionId,
    required String localeName,
  }) async {
    callCount++;
    return ApiSuccessResult(
      data: CalendarSubscriptionEntity(
        subscriptionId: subscriptionId,
        days: const [],
        unreadNotificationsCount: 7,
      ),
    );
  }
}

class _FakeGetNotificationsUseCase implements GetNotificationsUseCase {
  int callCount = 0;

  @override
  Future<ApiResult<NotificationsPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) async {
    callCount++;
    return ApiSuccessResult(
      data: NotificationsPageEntity(
        items: const [],
        page: page,
        pageSize: pageSize,
        totalCount: 0,
        totalPages: 1,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );
  }
}

class _FakeMarkReadUseCase implements MarkNotificationReadUseCase {
  @override
  Future<ApiResult<void>> call(String id) async => ApiSuccessResult(data: null);
}

class _FakeMarkAllReadUseCase implements MarkAllNotificationsReadUseCase {
  @override
  Future<ApiResult<void>> call() async => ApiSuccessResult(data: null);
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    locale: const Locale('en'),
    home: child,
  );
}

void main() {
  group('Notifications Resume Lifecycle Refresh', () {
    testWidgets('NotificationsScreen refreshes on AppLifecycleState.resumed', (
      tester,
    ) async {
      final fakeGetNotifications = _FakeGetNotificationsUseCase();
      final fakeCalendar = _FakeGetCalendarUseCase();
      final badgeViewModel = NotificationBadgeViewModel(fakeCalendar);
      final viewModel = NotificationsViewModel(
        fakeGetNotifications,
        _FakeMarkReadUseCase(),
        _FakeMarkAllReadUseCase(),
        badgeViewModel,
      );

      await tester.pumpWidget(_wrap(NotificationsScreen(viewModel: viewModel)));
      await tester.pumpAndSettle();

      expect(fakeGetNotifications.callCount, 1);

      // Simulate AppLifecycleState.resumed
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(fakeGetNotifications.callCount, 2);
    });

    test(
      'NotificationBadgeViewModel refreshCount updates count when invoked on resumed',
      () async {
        final fakeCalendar = _FakeGetCalendarUseCase();
        final badgeViewModel = NotificationBadgeViewModel(fakeCalendar);

        await badgeViewModel.refreshCount(
          subscriptionId: 'sub-active',
          localeName: 'en',
        );

        expect(fakeCalendar.callCount, 1);
        expect(badgeViewModel.state.unreadCount, 7);
      },
    );
  });
}
