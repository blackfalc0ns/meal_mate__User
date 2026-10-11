import 'package:meal_meat_user/core/network/failures.dart';

class NotificationBadgeState {
  const NotificationBadgeState({
    this.unreadCount,
    this.isRefreshing = false,
    this.refreshFailure,
  });

  final int? unreadCount;
  final bool isRefreshing;
  final Failure? refreshFailure;

  bool get hasUnread => (unreadCount ?? 0) > 0;

  NotificationBadgeState copyWith({
    int? Function()? unreadCount,
    bool? isRefreshing,
    Failure? Function()? refreshFailure,
  }) {
    return NotificationBadgeState(
      unreadCount: unreadCount != null ? unreadCount() : this.unreadCount,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      refreshFailure: refreshFailure != null
          ? refreshFailure()
          : this.refreshFailure,
    );
  }
}
