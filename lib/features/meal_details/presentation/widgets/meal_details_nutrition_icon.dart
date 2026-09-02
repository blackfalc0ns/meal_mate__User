import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

class MealDetailsNutritionIcon extends StatelessWidget {
  const MealDetailsNutritionIcon({super.key, required this.type});

  final MealDetailsNutritionType type;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final animation = _animation;
    if (animation != null) {
      return Lottie.asset(
        width: 30,
        height: 30,
        animation,
        fit: BoxFit.contain,
        repeat: true,
      );
    }

    return Icon(
      _icon,
      size: Spacing.iconSm,
      color: color.primary,
      textDirection: locale.localeName == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
    );
  }

  String? get _animation {
    return switch (type) {
      MealDetailsNutritionType.protein => Assets.muscleAnimation,
      MealDetailsNutritionType.carbs => Assets.wheatAnimation,
      MealDetailsNutritionType.fat => Assets.dropletAnimation,
      MealDetailsNutritionType.calories => Assets.fireAnimation,
      MealDetailsNutritionType.fiber => null,
    };
  }

  IconData get _icon {
    return switch (type) {
      MealDetailsNutritionType.fiber => Icons.eco_rounded,
      MealDetailsNutritionType.protein => Icons.fitness_center_rounded,
      MealDetailsNutritionType.carbs => Icons.rice_bowl_rounded,
      MealDetailsNutritionType.fat => Icons.water_drop_rounded,
      MealDetailsNutritionType.calories => Icons.local_fire_department_rounded,
    };
  }
}
