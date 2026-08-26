import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';

class CalendarAvailableMealsEntity {
  const CalendarAvailableMealsEntity({
    required this.restaurant,
    required this.meals,
    required this.slotRequirements,
    this.coreIngredients = const [],
  });

  final CalendarRestaurantEntity? restaurant;
  final List<CalendarMealEntity> meals;
  final List<CalendarSlotRequirementEntity> slotRequirements;
  final List<CalendarCoreIngredientEntity> coreIngredients;

  int get requiredMealsCount {
    return slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
  }
}

class CalendarCoreIngredientEntity {
  const CalendarCoreIngredientEntity({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.isLocal,
    required this.originCountryCode,
    required this.originCountryName,
    required this.flagEmoji,
  });

  final String id;
  final String name;
  final String? iconUrl;
  final bool isLocal;
  final String originCountryCode;
  final String originCountryName;
  final String? flagEmoji;
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

  String name(String localeName) =>
      localeName == 'ar' ? slotNameAr : slotNameEn;
}
