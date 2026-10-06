import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_notification_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_view_model.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';

class _FakeGetNotificationsUseCase implements GetNotificationsUseCase {
  ApiResult<NotificationsPageEntity>? nextResult;
  int callCount = 0;
  int? lastPage;
  int? lastPageSize;

  @override
  Future<ApiResult<NotificationsPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) async {
    callCount++;
    lastPage = page;
    lastPageSize = pageSize;
    return nextResult ??
        ApiSuccessResult(
          data: NotificationsPageEntity(
            items: [
              NotificationItemEntity(
                id: 'n1',
                titleEn: 'Notification 1',
                isRead: false,
              ),
            ],
            page: page,
            pageSize: pageSize,
            totalCount: 1,
            totalPages: 1,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        );
  }
}

class _FakeMarkNotificationReadUseCase implements MarkNotificationReadUseCase {
  ApiResult<void>? nextResult;
  int callCount = 0;
  String? lastId;

  @override
  Future<ApiResult<void>> call(String id) async {
    callCount++;
    lastId = id;
    return nextResult ?? ApiSuccessResult(data: null);
  }
}

class _FakeMarkAllNotificationsReadUseCase
    implements MarkAllNotificationsReadUseCase {
  ApiResult<void>? nextResult;
  int callCount = 0;

  @override
  Future<ApiResult<void>> call() async {
    callCount++;
    return nextResult ?? ApiSuccessResult(data: null);
  }
}

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
        unreadNotificationsCount: 5,
      ),
    );
  }
}

void main() {
  group('NotificationsViewModel', () {
    late _FakeGetNotificationsUseCase fakeGetNotifications;
    late _FakeMarkNotificationReadUseCase fakeMarkRead;
    late _FakeMarkAllNotificationsReadUseCase fakeMarkAllRead;
    late NotificationBadgeViewModel badgeViewModel;
    late NotificationsViewModel viewModel;

    setUp(() {
      fakeGetNotifications = _FakeGetNotificationsUseCase();
      fakeMarkRead = _FakeMarkNotificationReadUseCase();
      fakeMarkAllRead = _FakeMarkAllNotificationsReadUseCase();
      badgeViewModel = NotificationBadgeViewModel(_FakeGetCalendarUseCase());
      final v = badgeViewModel.beginCalendarCountRequest();
      badgeViewModel.acceptCalendarCount(5, requestVersion: v);

      viewModel = NotificationsViewModel(
        fakeGetNotifications,
        fakeMarkRead,
        fakeMarkAllRead,
        badgeViewModel,
      );
    });

    test('initial load updates state with items and pagination metadata', () async {
      await viewModel.load(page: 1, pageSize: 20);

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.rawItems.length, 1);
      expect(viewModel.state.rawItems.first.id, 'n1');
      expect(viewModel.state.page, 1);
      expect(viewModel.state.totalCount, 1);
      expect(viewModel.state.initialFailure, isNull);
    });

    test('initial load on failure sets initialFailure and clears isLoading', () async {
      fakeGetNotifications.nextResult = ApiErrorResult(
        failure: Failure(errorMessage: 'Error', code: 'server_error'),
      );

      await viewModel.load(page: 1, pageSize: 20);

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.rawItems, isEmpty);
      expect(viewModel.state.initialFailure?.code, 'server_error');
    });

    test('refresh retains existing items and updates on success', () async {
      await viewModel.load();

      fakeGetNotifications.nextResult = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [
            NotificationItemEntity(id: 'n2', titleEn: 'Refreshed 2'),
          ],
          page: 1,
          pageSize: 20,
          totalCount: 1,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );

      await viewModel.refresh();

      expect(viewModel.state.isRefreshing, isFalse);
      expect(viewModel.state.rawItems.length, 1);
      expect(viewModel.state.rawItems.first.id, 'n2');
    });

    test('loadMore appends unique items, guards against redundant calls, and updates page', () async {
      fakeGetNotifications.nextResult = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [
            NotificationItemEntity(id: 'n1', titleEn: 'Item 1'),
          ],
          page: 1,
          pageSize: 1,
          totalCount: 2,
          totalPages: 2,
          hasNextPage: true,
          hasPreviousPage: false,
        ),
      );
      await viewModel.load();

      fakeGetNotifications.nextResult = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [
            NotificationItemEntity(id: 'n1', titleEn: 'Item 1 duplicate'),
            NotificationItemEntity(id: 'n2', titleEn: 'Item 2'),
          ],
          page: 2,
          pageSize: 1,
          totalCount: 2,
          totalPages: 2,
          hasNextPage: false,
          hasPreviousPage: true,
        ),
      );

      await viewModel.loadMore();

      expect(viewModel.state.rawItems.length, 2);
      expect(viewModel.state.rawItems[0].id, 'n1');
      expect(viewModel.state.rawItems[1].id, 'n2');
      expect(viewModel.state.page, 2);
      expect(viewModel.state.hasNextPage, isFalse);

      // Redundant loadMore when hasNextPage is false must do nothing
      final callCount = fakeGetNotifications.callCount;
      await viewModel.loadMore();
      expect(fakeGetNotifications.callCount, callCount);
    });

    test('loadMore failure preserves existing rows and sets loadMoreFailure', () async {
      fakeGetNotifications.nextResult = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [NotificationItemEntity(id: 'n1', titleEn: 'Item 1')],
          page: 1,
          pageSize: 1,
          totalCount: 2,
          totalPages: 2,
          hasNextPage: true,
          hasPreviousPage: false,
        ),
      );
      await viewModel.load();

      fakeGetNotifications.nextResult = ApiErrorResult(
        failure: Failure(errorMessage: 'Network error', code: 'net_err'),
      );

      await viewModel.loadMore();

      expect(viewModel.state.rawItems.length, 1);
      expect(viewModel.state.loadMoreFailure?.code, 'net_err');
      expect(viewModel.state.isLoadingMore, isFalse);
    });

    test('markRead on unread item calls API, updates item, decrements badge, and executes callback', () async {
      await viewModel.load();
      expect(viewModel.state.rawItems.first.isRead, isFalse);
      expect(badgeViewModel.state.unreadCount, 5);

      bool navigated = false;
      await viewModel.markRead('n1', onSuccess: () {
        navigated = true;
      });

      expect(fakeMarkRead.callCount, 1);
      expect(fakeMarkRead.lastId, 'n1');
      expect(viewModel.state.rawItems.first.isRead, isTrue);
      expect(badgeViewModel.state.unreadCount, 4);
      expect(navigated, isTrue);
    });

    test('markRead on already read item executes callback immediately without API call', () async {
      fakeGetNotifications.nextResult = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [
            NotificationItemEntity(id: 'n1', titleEn: 'Already read', isRead: true),
          ],
          page: 1,
          pageSize: 20,
          totalCount: 1,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );
      await viewModel.load();

      bool navigated = false;
      await viewModel.markRead('n1', onSuccess: () {
        navigated = true;
      });

      expect(fakeMarkRead.callCount, 0);
      expect(navigated, isTrue);
    });

    test('markRead failure keeps item unread, does not execute callback, sets actionFailure', () async {
      await viewModel.load();
      fakeMarkRead.nextResult = ApiErrorResult(
        failure: Failure(errorMessage: 'Failed to mark read', code: 'put_err'),
      );

      bool navigated = false;
      await viewModel.markRead('n1', onSuccess: () {
        navigated = true;
      });

      expect(viewModel.state.rawItems.first.isRead, isFalse);
      expect(navigated, isFalse);
      expect(viewModel.state.actionFailure?.code, 'put_err');
      expect(badgeViewModel.state.unreadCount, 5);
    });

    test('markAllRead calls API, marks all loaded items read, and resets badge count to 0', () async {
      fakeGetNotifications.nextResult = ApiSuccessResult(
        data: NotificationsPageEntity(
          items: [
            NotificationItemEntity(id: 'n1', titleEn: 'Item 1', isRead: false),
            NotificationItemEntity(id: 'n2', titleEn: 'Item 2', isRead: false),
          ],
          page: 1,
          pageSize: 20,
          totalCount: 2,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );
      await viewModel.load();

      await viewModel.markAllRead();

      expect(fakeMarkAllRead.callCount, 1);
      expect(viewModel.state.rawItems.every((item) => item.isRead), isTrue);
      expect(badgeViewModel.state.unreadCount, 0);
    });
  });
}
