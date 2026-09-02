import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

sealed class CalendarEvent {
  const CalendarEvent();
}

class LoadCalendarEvent extends CalendarEvent {
  const LoadCalendarEvent({this.subscriptionId, required this.localeName});

  final String? subscriptionId;
  final String localeName;
}

class SelectCalendarDayEvent extends CalendarEvent {
  const SelectCalendarDayEvent({required this.day, required this.localeName});

  final CalendarDayEntity day;
  final String localeName;
}

class LoadCalendarRestaurantsEvent extends CalendarEvent {
  const LoadCalendarRestaurantsEvent({required this.localeName, this.query});

  final String localeName;
  final String? query;
}

class SelectCalendarRestaurantEvent extends CalendarEvent {
  const SelectCalendarRestaurantEvent({
    required this.restaurant,
    required this.localeName,
  });

  final CalendarRestaurantOptionEntity restaurant;
  final String localeName;
}

class LoadCalendarAvailableMealsEvent extends CalendarEvent {
  const LoadCalendarAvailableMealsEvent({required this.localeName});

  final String localeName;
}

class ToggleCalendarMealEvent extends CalendarEvent {
  const ToggleCalendarMealEvent(this.mealId);

  final String mealId;
}

class SaveCalendarDayMealsEvent extends CalendarEvent {
  const SaveCalendarDayMealsEvent({required this.localeName});

  final String localeName;
}

class AutoSelectCalendarDayEvent extends CalendarEvent {
  const AutoSelectCalendarDayEvent({required this.localeName});

  final String localeName;
}
