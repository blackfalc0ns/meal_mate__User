import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_nutrition_item.dart';

enum NutritionOrder {
  caloriesProteinCarbsFat,
  caloriesCarbsProteinFat,
}

class AppNutritionRow extends StatelessWidget {
  const AppNutritionRow({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.caloriesLabel,
    this.proteinLabel,
    this.carbsLabel,
    this.fatLabel,
    this.order = NutritionOrder.caloriesProteinCarbsFat,
    this.textDirection = TextDirection.rtl,
    this.height = 46.0,
  });

  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  final String? caloriesLabel;
  final String? proteinLabel;
  final String? carbsLabel;
  final String? fatLabel;
  final NutritionOrder order;
  final TextDirection? textDirection;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final caloriesItem = AppNutritionItem(
      icon: Icons.local_fire_department_rounded,
      animationAsset: Assets.fireAnimation,
      value: calories,
      label: caloriesLabel ?? locale.calendar_calories,
    );

    final proteinItem = AppNutritionItem(
      icon: Icons.fitness_center_rounded,
      animationAsset: Assets.muscleAnimation,
      value: protein,
      label: proteinLabel ?? locale.calendar_protein,
    );

    final carbsItem = AppNutritionItem(
      icon: Icons.rice_bowl_rounded,
      animationAsset: Assets.wheatAnimation,
      value: carbs,
      label: carbsLabel ?? locale.calendar_carbs,
    );

    final fatItem = AppNutritionItem(
      icon: Icons.water_drop_rounded,
      animationAsset: Assets.dropletAnimation,
      value: fat,
      label: fatLabel ?? locale.calendar_fat,
    );

    final items = switch (order) {
      NutritionOrder.caloriesProteinCarbsFat => [
          caloriesItem,
          proteinItem,
          carbsItem,
          fatItem,
        ],
      NutritionOrder.caloriesCarbsProteinFat => [
          caloriesItem,
          carbsItem,
          proteinItem,
          fatItem,
        ],
    };

    return SizedBox(
      height: height,
      child: Row(
        textDirection: textDirection,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Expanded(child: items[index]),
            if (index != items.length - 1)
              Container(
                width: 0.5,
                height: 32,
                color: color.onSurface.withValues(alpha: 0.20),
              ),
          ],
        ],
      ),
    );
  }
}
