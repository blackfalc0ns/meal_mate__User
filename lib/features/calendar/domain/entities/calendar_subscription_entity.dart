import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

class CalendarSubscriptionEntity {
  const CalendarSubscriptionEntity({
    required this.subscriptionId,
    required this.days,
    this.includeFriday,
    this.operationalLeadHours,
    this.hasUnreadNotifications,
    this.unreadNotificationsCount,
  });

  final String subscriptionId;
  final List<CalendarDayEntity> days;
  final bool? includeFriday;
  final int? operationalLeadHours;
  final bool? hasUnreadNotifications;
  final int? unreadNotificationsCount;

  bool canFreezeDate(DateTime date) {
    if (includeFriday == false && date.weekday == DateTime.friday) return false;
    final day = days
        .where(
          (day) =>
              day.date?.year == date.year &&
              day.date?.month == date.month &&
              day.date?.day == date.day,
        )
        .firstOrNull;
    return day?.canFreezeDay == true;
  }

  bool canFreezeInteriorDate(DateTime date) =>
      (includeFriday == false && date.weekday == DateTime.friday) ||
      canFreezeDate(date);

  bool canFreezeRange(DateTime start, DateTime end) {
    if (end.isBefore(start) || !canFreezeDate(start) || !canFreezeDate(end)) {
      return false;
    }
    for (
      var date = start;
      !date.isAfter(end);
      date = DateTime(date.year, date.month, date.day + 1)
    ) {
      if (!canFreezeInteriorDate(date)) return false;
    }
    return true;
  }

  bool get hasUnread => unreadNotificationsCount != null
      ? unreadNotificationsCount! > 0
      : (hasUnreadNotifications ?? false);
}
