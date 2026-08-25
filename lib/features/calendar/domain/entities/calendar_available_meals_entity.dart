import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';

class CalendarAvailableMealsEntity {
  const CalendarAvailableMealsEntity({
    required this.restaurant,
    required this.meals,
    required this.slotRequirements,
  });

  final CalendarRestaurantEntity? restaurant;
  final List<CalendarMealEntity> meals;
  final List<CalendarSlotRequirementEntity> slotRequirements;

  int get requiredMealsCount {
    return slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
  }
}

class CalendarSlotRequirementEntity {
  const CalendarSlotRequirementEntity({
    required this.slot,
    required this.slotNameAr,
    required this.slotNameEn,
    required this.count,
  });

  final String slot;
  final String slotNameAr;
  final String slotNameEn;
  final int count;

  String name(String localeName) => localeName == 'ar' ? slotNameAr : slotNameEn;
}
