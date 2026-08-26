import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';

class CalendarDayEntity {
  const CalendarDayEntity({
    this.id = '',
    this.status = '',
    this.restaurantId,
    this.restaurant,
    this.meals = const [],
    this.selectedMealIds = const [],
    this.nutritionTotals = const CalendarNutritionTotalsEntity(),
    this.slotRequirements = const [],
    this.isLocked = false,
    this.editDeadlineUtc,
    required this.dayNumber,
    required this.weekday,
    this.date,
    this.isSelected = false,
    this.isMuted = false,
    this.hasMeals = true,
  });

  final String id;
  final String status;
  final String? restaurantId;
  final CalendarRestaurantEntity? restaurant;
  final List<CalendarMealEntity> meals;
  final List<String> selectedMealIds;
  final CalendarNutritionTotalsEntity nutritionTotals;
  final List<CalendarSlotRequirementEntity> slotRequirements;
  final bool isLocked;
  final DateTime? editDeadlineUtc;
  final int dayNumber;
  final String weekday;
  final DateTime? date;
  final bool isSelected;
  final bool isMuted;
  final bool hasMeals;

  bool get hasSelectedMeals {
    return selectedMealIds.isNotEmpty || meals.any((meal) => meal.selected);
  }

  bool get isRestaurantClosed {
    final normalizedStatus = status.toLowerCase();
    return isLocked ||
        normalizedStatus == 'senttorestaurant' ||
        normalizedStatus == 'sent_to_restaurant' ||
        normalizedStatus == 'locked' ||
        normalizedStatus == 'completed' ||
        normalizedStatus == 'cancelled';
  }

  bool get isEditable {
    if (date == null || isLocked) return false;
    final normalizedStatus = status.toLowerCase();
    if (normalizedStatus == 'senttorestaurant' ||
        normalizedStatus == 'sent_to_restaurant' ||
        normalizedStatus == 'locked' ||
        normalizedStatus == 'completed' ||
        normalizedStatus == 'cancelled') {
      return false;
    }

    final deadline =
        editDeadlineUtc ?? date!.subtract(const Duration(hours: 72));
    if (DateTime.now().toUtc().isAfter(deadline.toUtc())) {
      return false;
    }

    return normalizedStatus.isEmpty ||
        normalizedStatus == 'open' ||
        normalizedStatus == 'customerselected' ||
        normalizedStatus == 'customer_selected';
  }

  CalendarDayEntity copyWith({
    bool? isSelected,
    bool? isMuted,
    bool? hasMeals,
    CalendarNutritionTotalsEntity? nutritionTotals,
  }) {
    return CalendarDayEntity(
      id: id,
      status: status,
      restaurantId: restaurantId,
      restaurant: restaurant,
      meals: meals,
      selectedMealIds: selectedMealIds,
      nutritionTotals: nutritionTotals ?? this.nutritionTotals,
      slotRequirements: slotRequirements,
      isLocked: isLocked,
      editDeadlineUtc: editDeadlineUtc,
      dayNumber: dayNumber,
      weekday: weekday,
      date: date,
      isSelected: isSelected ?? this.isSelected,
      isMuted: isMuted ?? this.isMuted,
      hasMeals: hasMeals ?? this.hasMeals,
    );
  }
}
