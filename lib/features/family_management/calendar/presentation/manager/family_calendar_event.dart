import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
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

class LoadFamilyRestaurantsEvent extends FamilyCalendarEvent {
  const LoadFamilyRestaurantsEvent({this.query, required this.localeName});

  final String? query;
  final String localeName;
}

class SelectFamilyRestaurantEvent extends FamilyCalendarEvent {
  const SelectFamilyRestaurantEvent({
    required this.restaurant,
    required this.localeName,
  });

  final CalendarRestaurantOptionEntity restaurant;
  final String localeName;
}

class LoadFamilyAvailableMealsEvent extends FamilyCalendarEvent {
  const LoadFamilyAvailableMealsEvent({
    required this.localeName,
    this.slot,
    this.page,
  });

  final String localeName;
  final String? slot;
  final int? page;
}

class SelectFamilyMealCategoryEvent extends FamilyCalendarEvent {
  const SelectFamilyMealCategoryEvent({
    required this.index,
    required this.localeName,
  });

  final int index;
  final String localeName;
}

class SelectMealForSlotEvent extends FamilyCalendarEvent {
  const SelectMealForSlotEvent({
    required this.meal,
    required this.slot,
  });

  final CalendarMealEntity meal;
  final String slot;
}

class SaveFamilyDayMealsEvent extends FamilyCalendarEvent {
  const SaveFamilyDayMealsEvent({required this.localeName});

  final String localeName;
}
