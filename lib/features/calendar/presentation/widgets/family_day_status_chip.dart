import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyDayStatusChip extends StatelessWidget {
  const FamilyDayStatusChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(Spacing.familyDayMealButtonRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xss,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: Spacing.iconSm, color: color.primary),
            const SizedBox(width: Spacing.sm),

            Text(
              label,
              locale: Locale(locale.localeName),
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
