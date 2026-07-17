import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsHeaderImage extends StatelessWidget {
  const MealDetailsHeaderImage({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final textDirection = locale.localeName == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Semantics(
      label: label,
      image: true,
      child: Directionality(
        textDirection: textDirection,
        child: SizedBox(
          height: Spacing.xxxl * 4 + Spacing.xxl,
          width: double.infinity,
          child: ColoredBox(
            color: color.surfaceContainerHighest,
            child: Image.asset(Assets.mealDetailsHero, fit: BoxFit.fitWidth),
          ),
        ),
      ),
    );
  }
}
