import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';

class _FakeGetCalendarUseCase implements GetCalendarUseCase {
  ApiResult<CalendarSubscriptionEntity>? nextResult;

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> call({
    required String subscriptionId,
    required String localeName,
  }) async {
    return nextResult ??
        ApiSuccessResult(
          data: CalendarSubscriptionEntity(
            subscriptionId: subscriptionId,
            days: const <CalendarDayEntity>[],
            unreadNotificationsCount: 3,
            hasUnreadNotifications: true,
          ),
        );
  }
}

void main() {
  group('NotificationBadgeViewModel', () {
    late _FakeGetCalendarUseCase fakeGetCalendarUseCase;
    late NotificationBadgeViewModel viewModel;

    setUp(() {
      fakeGetCalendarUseCase = _FakeGetCalendarUseCase();
      viewModel = NotificationBadgeViewModel(fakeGetCalendarUseCase);
    });

    test('initial state has null unreadCount and hasUnread is false', () {
      expect(viewModel.state.unreadCount, isNull);
      expect(viewModel.state.hasUnread, isFalse);
      expect(viewModel.state.isRefreshing, isFalse);
    });

    test('acceptCalendarCount updates unreadCount and ignores stale versions', () {
      final v1 = viewModel.beginCalendarCountRequest();
      final v2 = viewModel.beginCalendarCountRequest();
      expect(v2, greaterThan(v1));

      // v1 is stale now
      viewModel.acceptCalendarCount(5, requestVersion: v1);
      expect(viewModel.state.unreadCount, isNull);

      // v2 is valid
      viewModel.acceptCalendarCount(5, requestVersion: v2);
      expect(viewModel.state.unreadCount, 5);
      expect(viewModel.state.hasUnread, isTrue);
    });

    test('acknowledgeRead decrements unreadCount once per notification id and clamps at 0', () {
      final v1 = viewModel.beginCalendarCountRequest();
      viewModel.acceptCalendarCount(2, requestVersion: v1);

      viewModel.acknowledgeRead('n1');
      expect(viewModel.state.unreadCount, 1);

      // Duplicate acknowledge for same id must NOT decrement again
      viewModel.acknowledgeRead('n1');
      expect(viewModel.state.unreadCount, 1);

      viewModel.acknowledgeRead('n2');
      expect(viewModel.state.unreadCount, 0);
      expect(viewModel.state.hasUnread, isFalse);

      // Clamps at 0
      viewModel.acknowledgeRead('n3');
      expect(viewModel.state.unreadCount, 0);
    });

    test('acknowledgeRead when count is unknown does NOT convert count to 0', () {
      expect(viewModel.state.unreadCount, isNull);
      viewModel.acknowledgeRead('n1');
      expect(viewModel.state.unreadCount, isNull);
    });

    test('acknowledgeReadAll sets count to 0 and invalidates older calendar responses', () {
      final v1 = viewModel.beginCalendarCountRequest();
      viewModel.acknowledgeReadAll();

      expect(viewModel.state.unreadCount, 0);
      expect(viewModel.state.hasUnread, isFalse);

      // Attempting to deliver v1 response must be ignored
      viewModel.acceptCalendarCount(7, requestVersion: v1);
      expect(viewModel.state.unreadCount, 0);
    });

    test('resetForAccountChange resets state completely and invalidates old responses', () {
      final v1 = viewModel.beginCalendarCountRequest();
      viewModel.acceptCalendarCount(5, requestVersion: v1);

      viewModel.resetForAccountChange();
      expect(viewModel.state.unreadCount, isNull);
      expect(viewModel.state.hasUnread, isFalse);

      viewModel.acceptCalendarCount(5, requestVersion: v1);
      expect(viewModel.state.unreadCount, isNull);
    });

    test('refreshCount calls GetCalendarUseCase and updates unreadCount on success', () async {
      fakeGetCalendarUseCase.nextResult = ApiSuccessResult(
        data: const CalendarSubscriptionEntity(
          subscriptionId: 'sub-1',
          days: [],
          unreadNotificationsCount: 8,
          hasUnreadNotifications: true,
        ),
      );

      await viewModel.refreshCount(
        subscriptionId: 'sub-1',
        localeName: 'en',
      );

      expect(viewModel.state.unreadCount, 8);
      expect(viewModel.state.hasUnread, isTrue);
      expect(viewModel.state.isRefreshing, isFalse);
      expect(viewModel.state.refreshFailure, isNull);
    });

    test('refreshCount on failure preserves existing count and sets refreshFailure', () async {
      final v1 = viewModel.beginCalendarCountRequest();
      viewModel.acceptCalendarCount(4, requestVersion: v1);

      fakeGetCalendarUseCase.nextResult = ApiErrorResult(
        failure: Failure(errorMessage: 'Network error', code: 'network.timeout'),
      );

      await viewModel.refreshCount(
        subscriptionId: 'sub-1',
        localeName: 'en',
      );

      expect(viewModel.state.unreadCount, 4);
      expect(viewModel.state.refreshFailure?.code, 'network.timeout');
      expect(viewModel.state.isRefreshing, isFalse);
    });
  });
}
