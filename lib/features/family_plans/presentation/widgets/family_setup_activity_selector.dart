import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_activity_option.dart';

class FamilySetupActivitySelector extends StatelessWidget {
  const FamilySetupActivitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_walk_rounded,
              size: Spacing.iconSm,
              color: color.primary,
            ),

            const SizedBox(width: Spacing.xs),
            Text(
              locale.family_activity_level,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xss),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FamilySetupActivityOption(label: locale.family_activity_high),
            FamilySetupActivityOption(label: locale.family_activity_medium),
            FamilySetupActivityOption(
              label: locale.family_activity_low,
              selected: true,
            ),
          ],
        ),
      ],
    );
  }
}
