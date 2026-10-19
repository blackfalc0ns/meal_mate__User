import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyDaySelectedStatus extends StatelessWidget {
  const FamilyDaySelectedStatus({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          locale: Locale(locale.localeName),
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size13,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Icon(
          Icons.check_circle_outline_rounded,
          size: Spacing.familyDaySelectedIconSize,
          color: color.primary,
        ),
      ],
    );
  }
}
