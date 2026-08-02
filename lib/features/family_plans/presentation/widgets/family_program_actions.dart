import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyProgramActions extends StatelessWidget {
  const FamilyProgramActions({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        SizedBox(
          width: Spacing.familyProgramPreviousButtonWidth,
          child: AppButton.outlined(
            text: locale.family_previous_program,
            onPressed: () => Navigator.maybePop(context),
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            color: color.primary,
            textColor: color.primary,
            fontSize: FontSize.size10,
            iconWidget: Icon(
              Icons.arrow_back_ios_rounded,
              color: color.primary,
              size: Spacing.iconSm,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: Spacing.familyProgramNextButtonWidth,
          child: AppButton.filled(
            text: locale.family_next_payment,
            onPressed: () {},
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            textColor: color.onPrimary,
            fontSize: FontSize.size12,

            iconWidget: Icon(
              Icons.credit_card_rounded,
              color: color.onPrimary,
              size: Spacing.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}
