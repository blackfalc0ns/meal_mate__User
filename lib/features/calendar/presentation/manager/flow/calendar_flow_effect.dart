import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

abstract class CalendarFlowEffect {
  final int id;

  const CalendarFlowEffect({required this.id});
}

class OpenRestaurantPickerEffect extends CalendarFlowEffect {
  final DateTime date;
  final String subscriptionId;

  const OpenRestaurantPickerEffect({
    required super.id,
    required this.date,
    required this.subscriptionId,
  });
}

class OpenMealPickerEffect extends CalendarFlowEffect {
  final DateTime date;
  final String subscriptionId;
  final String restaurantId;
  final CalendarRestaurantOptionEntity? restaurant;

  const OpenMealPickerEffect({
    required super.id,
    required this.date,
    required this.subscriptionId,
    required this.restaurantId,
    this.restaurant,
  });
}

class CloseMealPickerEffect extends CalendarFlowEffect {
  const CloseMealPickerEffect({required super.id});
}

class MealsSavedEffect extends CalendarFlowEffect {
  final CalendarDayEntity day;

  const MealsSavedEffect({required super.id, required this.day});
}

class MealsConfirmedEffect extends CalendarFlowEffect {
  final CalendarDayEntity day;

  const MealsConfirmedEffect({required super.id, required this.day});
}

class CalendarFailureEffect extends CalendarFlowEffect {
  final Failure failure;

  const CalendarFailureEffect({required super.id, required this.failure});
}
