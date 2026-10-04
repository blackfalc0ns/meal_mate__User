import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

sealed class CalendarOverviewEvent {
  const CalendarOverviewEvent();
}

class LoadCalendarEvent extends CalendarOverviewEvent {
  const LoadCalendarEvent({
    this.subscriptionId,
    required this.localeName,
    this.retryWithCurrentOnNotFound = true,
  });

  final String? subscriptionId;
  final String localeName;
  final bool retryWithCurrentOnNotFound;
}

class SelectCalendarDayEvent extends CalendarOverviewEvent {
  const SelectCalendarDayEvent({
    required this.day,
    required this.localeName,
  });

  final CalendarDayEntity day;
  final String localeName;
}

class ReplaceCalendarDayEvent extends CalendarOverviewEvent {
  const ReplaceCalendarDayEvent(this.day);

  final CalendarDayEntity day;
}
