import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

class CalendarSubscriptionEntity {
  const CalendarSubscriptionEntity({
    required this.subscriptionId,
    required this.days,
    this.hasUnreadNotifications,
    this.unreadNotificationsCount,
  });

  final String subscriptionId;
  final List<CalendarDayEntity> days;
  final bool? hasUnreadNotifications;
  final int? unreadNotificationsCount;

  bool get hasUnread =>
      unreadNotificationsCount != null
          ? unreadNotificationsCount! > 0
          : (hasUnreadNotifications ?? false);
}
