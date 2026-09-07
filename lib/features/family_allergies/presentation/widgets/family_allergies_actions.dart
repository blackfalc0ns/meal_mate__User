import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyAllergiesActions extends StatelessWidget {
  const FamilyAllergiesActions({
    super.key,
    required this.nextText,
    required this.isLoading,
    required this.onNext,
    required this.onSkip,
  });

  final String nextText;
  final bool isLoading;
  final VoidCallback? onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        SizedBox(
          width: Spacing.familyAllergiesSkipWidth,
          child: AppButton.outlined(
            text: locale.skip,
            height: Spacing.familyAllergiesActionsHeight,
            borderRadius: Spacing.familyAllergiesActionsRadius,
            color: color.primary,
            fontSize: FontSize.size12,
            onPressed: isLoading ? null : onSkip,
          ),
        ),
        const SizedBox(width: Spacing.familyAllergiesActionsGap),
        Expanded(
          child: AppButton.filled(
            text: nextText,
            height: Spacing.familyAllergiesActionsHeight,
            borderRadius: Spacing.familyAllergiesActionsRadius,
            color: color.primary,
            fontSize: FontSize.size12,
            isLoading: isLoading,
            onPressed: onNext,
          ),
        ),
      ],
    );
  }
}
