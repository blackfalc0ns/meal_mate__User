import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';

class FamilyDayMealIcon extends StatelessWidget {
  const FamilyDayMealIcon({super.key, required this.type});

  final FamilyDayMealIconType type;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final icon = switch (type) {
      FamilyDayMealIconType.breakfast => Icons.wb_sunny_rounded,
      FamilyDayMealIconType.lunch => Icons.wb_sunny_rounded,
      FamilyDayMealIconType.dinner => Icons.nightlight_round,
      FamilyDayMealIconType.snack => Icons.eco_rounded,
    };
    final iconColor = switch (type) {
      FamilyDayMealIconType.breakfast => color.primary,
      FamilyDayMealIconType.lunch => color.secondary,
      FamilyDayMealIconType.dinner => color.inversePrimary,
      FamilyDayMealIconType.snack => color.primary,
    };

    return Icon(
      icon,
      semanticLabel: locale.localeName,
      size: Spacing.familyDayMealIconSize,
      color: iconColor,
    );
  }
}
