import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyDayReviewButton extends StatelessWidget {
  const FamilyDayReviewButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AppButton.filled(
      text: label,
      onPressed: onPressed,
      height: Spacing.familyDayReviewButtonHeight,
      borderRadius: Spacing.familyDayReviewButtonRadius,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.tertiary, color.primary],
      ),
      textColor: color.onPrimary,
      fontSize: FontSize.size15,
      fontWeight: FontWeightManger.semiBold,
      padding: EdgeInsets.zero,
      locale: Locale(locale.localeName),
    );
  }
}
