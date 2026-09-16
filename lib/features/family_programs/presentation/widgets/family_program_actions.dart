import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyProgramActions extends StatelessWidget {
  const FamilyProgramActions({
    super.key,
    this.nextText,
    this.nextIcon,
    this.onNextPressed,
  });

  final String? nextText;
  final IconData? nextIcon;
  final VoidCallback? onNextPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: AppButton.outlined(
            iconBeforeText: true,
            text: locale.family_previous_program,
            onPressed: () => Navigator.maybePop(context),
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            color: color.primary,
            textColor: color.primary,
            fontSize: FontSize.size11,
            iconWidget: Icon(
              Icons.arrow_back_ios_rounded,
              color: color.primary,
              size: Spacing.iconMd,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          flex: 1,
          child: AppButton.filled(
            iconBeforeText: false,
            text: nextText ?? locale.family_next_payment,
            onPressed: onNextPressed,
            height: Spacing.familySetupBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            textColor: color.onPrimary,
            fontSize: FontSize.size11,
            iconWidget: Icon(
              nextIcon ?? Icons.credit_card_rounded,
              color: color.onPrimary,
              size: Spacing.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}
