import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyProgramSummaryMetric extends StatelessWidget {
  const FamilyProgramSummaryMetric({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Spacing.iconSm, color: color.primary),
            const SizedBox(width: Spacing.xs),
            Text(
              value,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
