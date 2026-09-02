import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
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
          animationAsset: Assets.muscleAnimation,
          label: locale.calendar_protein,
          value: totals.proteinG,
          percentage: totals.proteinPercentage?.round(),
          iconColor: color.primary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.grass_rounded,
          animationAsset: Assets.wheatAnimation,
          label: locale.calendar_carbs,
          value: totals.carbsG,
          percentage: totals.carbsPercentage?.round(),
          iconColor: color.primary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.water_drop_rounded,
          animationAsset: Assets.dropletAnimation,
          label: locale.calendar_fat,
          value: totals.fatG,
          percentage: totals.fatPercentage?.round(),
          iconColor: color.secondary,
        ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryNutritionGap),
        CalendarRestaurantNutritionItem(
          icon: Icons.local_fire_department_rounded,
          animationAsset: Assets.fireAnimation,
          label: locale.calendar_calories,
          value: totals.calories,
          iconColor: color.secondary,
        ),
      ],
    );
  }
}
