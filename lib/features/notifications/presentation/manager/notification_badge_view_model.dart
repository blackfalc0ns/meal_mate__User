import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_state.dart';

@lazySingleton
class NotificationBadgeViewModel extends Cubit<NotificationBadgeState> {
  NotificationBadgeViewModel(this._getCalendarUseCase)
      : super(const NotificationBadgeState());

  final GetCalendarUseCase _getCalendarUseCase;

  int _requestVersion = 0;
  final Set<String> _acknowledgedReadIds = <String>{};

  int beginCalendarCountRequest() {
    _requestVersion++;
    return _requestVersion;
  }

  void acceptCalendarCount(int count, {required int requestVersion}) {
    if (requestVersion < _requestVersion) {
      return;
    }
    _acknowledgedReadIds.clear();
    emit(state.copyWith(unreadCount: () => count));
  }

  void acknowledgeRead(String notificationId) {
    if (_acknowledgedReadIds.contains(notificationId)) {
      return;
    }
    _acknowledgedReadIds.add(notificationId);
    _requestVersion++;

    if (state.unreadCount != null) {
      final current = state.unreadCount!;
      final updated = (current - 1).clamp(0, 999999);
      emit(state.copyWith(unreadCount: () => updated));
    }
  }

  void acknowledgeReadAll() {
    _acknowledgedReadIds.clear();
    _requestVersion++;
    emit(state.copyWith(unreadCount: () => 0));
  }

  void resetForAccountChange() {
    _acknowledgedReadIds.clear();
    _requestVersion++;
    emit(const NotificationBadgeState(
      unreadCount: null,
      isRefreshing: false,
      refreshFailure: null,
    ));
  }

  Future<void> refreshCount({
    required String subscriptionId,
    required String localeName,
  }) async {
    if (state.isRefreshing) {
      return;
    }

    final capturedVersion = beginCalendarCountRequest();
    emit(state.copyWith(
      isRefreshing: true,
      refreshFailure: () => null,
    ));

    final result = await _getCalendarUseCase(
      subscriptionId: subscriptionId,
      localeName: localeName,
    );

    if (capturedVersion < _requestVersion) {
      emit(state.copyWith(isRefreshing: false));
      return;
    }

    switch (result) {
      case ApiSuccessResult(:final data):
        _acknowledgedReadIds.clear();
        final serverCount = data.unreadNotificationsCount;
        if (serverCount != null) {
          emit(state.copyWith(
            unreadCount: () => serverCount,
            isRefreshing: false,
          ));
        } else if (data.hasUnreadNotifications != null) {
          final hasUnread = data.hasUnreadNotifications!;
          if (!hasUnread) {
            emit(state.copyWith(
              unreadCount: () => 0,
              isRefreshing: false,
            ));
          } else {
            final fallbackCount = (state.unreadCount != null && state.unreadCount! > 0)
                ? state.unreadCount
                : 1;
            emit(state.copyWith(
              unreadCount: () => fallbackCount,
              isRefreshing: false,
            ));
          }
        } else {
          emit(state.copyWith(isRefreshing: false));
        }
      case ApiErrorResult(:final failure):
        emit(state.copyWith(
          isRefreshing: false,
          refreshFailure: () => failure,
        ));
    }
  }
}
