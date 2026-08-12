import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_nutrition_item.dart';

class CalendarRestaurantNutritionRow extends StatelessWidget {
  const CalendarRestaurantNutritionRow({super.key, required this.meals});

  final List<CalendarMealEntity> meals;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        CalendarRestaurantNutritionItem(
          icon: Icons.fitness_center_rounded,
          label: locale.calendar_protein,
          value: _sum((meal) => meal.protein),
          iconColor: color.primary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.grass_rounded,
          label: locale.calendar_carbs,
          value: _sum((meal) => meal.carbs),
          iconColor: color.primary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.water_drop_rounded,
          label: locale.calendar_fat,
          value: _sum((meal) => meal.fat),
          iconColor: color.secondary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.local_fire_department_rounded,
          label: locale.calendar_calories,
          value: _sum((meal) => meal.calories),
          iconColor: color.secondary,
        ),
      ],
    );
  }

  int _sum(String Function(CalendarMealEntity meal) selector) {
    return meals.fold<int>(
      0,
      (total, meal) => total + _numberFrom(selector(meal)),
    );
  }

  int _numberFrom(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
}
