import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

sealed class FamilyMealSelectionEvent {
  const FamilyMealSelectionEvent();
}

class SelectMealSelectionMemberEvent extends FamilyMealSelectionEvent {
  const SelectMealSelectionMemberEvent({
    required this.index,
    required this.localeName,
  });

  final int index;
  final String localeName;
}

class LoadFamilyRestaurantsEvent extends FamilyMealSelectionEvent {
  const LoadFamilyRestaurantsEvent({this.query, required this.localeName});

  final String? query;
  final String localeName;
}

class SelectFamilyRestaurantEvent extends FamilyMealSelectionEvent {
  const SelectFamilyRestaurantEvent({
    required this.restaurant,
    required this.localeName,
  });

  final CalendarRestaurantOptionEntity restaurant;
  final String localeName;
}

class LoadFamilyAvailableMealsEvent extends FamilyMealSelectionEvent {
  const LoadFamilyAvailableMealsEvent({
    required this.localeName,
    this.slot,
    this.page,
  });

  final String localeName;
  final String? slot;
  final int? page;
}

class SelectFamilyMealCategoryEvent extends FamilyMealSelectionEvent {
  const SelectFamilyMealCategoryEvent({
    required this.index,
    required this.localeName,
  });

  final int index;
  final String localeName;
}

class SelectMealForSlotEvent extends FamilyMealSelectionEvent {
  const SelectMealForSlotEvent({required this.meal, required this.slot});

  final CalendarMealEntity meal;
  final String slot;
}

class SaveFamilyDayMealsEvent extends FamilyMealSelectionEvent {
  const SaveFamilyDayMealsEvent({required this.localeName});

  final String localeName;
}

class ConfirmFamilyDayMealsEvent extends FamilyMealSelectionEvent {
  const ConfirmFamilyDayMealsEvent({required this.localeName});

  final String localeName;
}

class AutoSelectFamilyDayMealsEvent extends FamilyMealSelectionEvent {
  const AutoSelectFamilyDayMealsEvent({required this.localeName});

  final String localeName;
}
