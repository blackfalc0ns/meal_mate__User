import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';

sealed class FamilyCalendarEvent {
  const FamilyCalendarEvent();
}

class InitFamilyCalendarEvent extends FamilyCalendarEvent {
  const InitFamilyCalendarEvent({
    this.args,
    this.initialDate,
    required this.localeName,
  });

  final FamilyMemberCalendarArgs? args;
  final DateTime? initialDate;
  final String localeName;
}

class SelectFamilyMemberEvent extends FamilyCalendarEvent {
  const SelectFamilyMemberEvent({
    required this.index,
    required this.localeName,
  });

  final int index;
  final String localeName;
}

class SelectFamilyCalendarDayEvent extends FamilyCalendarEvent {
  const SelectFamilyCalendarDayEvent({
    required this.day,
    required this.localeName,
  });

  final CalendarDayEntity day;
  final String localeName;
}

class ChangeFamilyCalendarMonthEvent extends FamilyCalendarEvent {
  const ChangeFamilyCalendarMonthEvent({required this.months});

  final int months;
}

class RetryFamilyCalendarEvent extends FamilyCalendarEvent {
  const RetryFamilyCalendarEvent({required this.localeName});

  final String localeName;
}

class RetryFamilyCapabilitiesEvent extends FamilyCalendarEvent {
  const RetryFamilyCapabilitiesEvent();
}
