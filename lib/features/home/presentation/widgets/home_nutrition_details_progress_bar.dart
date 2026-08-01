import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeNutritionDetailsProgressBar extends StatelessWidget {
  const HomeNutritionDetailsProgressBar({
    super.key,
    required this.percent,
    required this.progressColor,
  });

  final int percent;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final clampedProgress = (percent / 100).clamp(0, 1).toDouble();

    return Semantics(
      label: locale.home_main_nutrients,
      child: Container(
        height: Spacing.nutritionDetailsProgressHeight,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: clampedProgress,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
