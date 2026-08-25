import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

class CalendarSubscriptionEntity {
  const CalendarSubscriptionEntity({
    required this.subscriptionId,
    required this.days,
  });

  final String subscriptionId;
  final List<CalendarDayEntity> days;
}
