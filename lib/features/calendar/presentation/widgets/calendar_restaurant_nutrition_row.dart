import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_nutrition_item.dart';

class CalendarRestaurantNutritionRow extends StatelessWidget {
  const CalendarRestaurantNutritionRow({super.key, required this.totals});

  final CalendarNutritionTotalsEntity totals;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        CalendarRestaurantNutritionItem(
          icon: Icons.fitness_center_rounded,
          label: locale.calendar_protein,
          value: totals.proteinG,
          iconColor: color.primary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.grass_rounded,
          label: locale.calendar_carbs,
          value: totals.carbsG,
          iconColor: color.primary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.water_drop_rounded,
          label: locale.calendar_fat,
          value: totals.fatG,
          iconColor: color.secondary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.local_fire_department_rounded,
          label: locale.calendar_calories,
          value: totals.calories,
          iconColor: color.secondary,
        ),
      ],
    );
  }
}
