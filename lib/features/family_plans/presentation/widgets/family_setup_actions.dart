import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilySetupActions extends StatelessWidget {
  const FamilySetupActions({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        Expanded(
          child: AppButton.outlined(
            text: locale.family_add_member_button,
            onPressed: () {},
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            color: color.primary,
            textColor: color.primary,
            fontSize: FontSize.size9,
            icon: Icons.add_rounded,
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: AppButton.filled(
            text: locale.family_next_program,
            onPressed: () => context.pushNamed(AppRoutes.familyProgramSetup),
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            textColor: color.onPrimary,
            fontSize: FontSize.size12,
            fontWeight: FontWeight.w600,
            iconWidget: Icon(
              Icons.chevron_right_rounded,
              color: color.onPrimary,
              size: Spacing.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}
