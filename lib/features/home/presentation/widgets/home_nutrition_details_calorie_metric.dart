import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeNutritionDetailsCalorieMetric extends StatelessWidget {
  const HomeNutritionDetailsCalorieMetric({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nutrition_details_calorie_unit,
      child: Column(
        children: [
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onPrimary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            value,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size18,
              color: color.onPrimary,
            ),
          ),
          Text(
            unit,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
