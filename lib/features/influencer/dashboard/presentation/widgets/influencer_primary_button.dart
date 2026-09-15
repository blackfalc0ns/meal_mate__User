import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class InfluencerPrimaryButton extends StatelessWidget {
  const InfluencerPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AppButton(
      text: label,
      onPressed: onPressed,
      isLoading: isLoading,
      variant: filled ? AppButtonVariant.filled : AppButtonVariant.outlined,
      height: Spacing.buttonSmallHeight,
      borderRadius: Spacing.radiusPill,
      color: color.primary,
      textColor: filled ? color.onPrimary : color.primary,
      fontSize: FontSize.size12,
      fontWeight: FontWeightManger.bold,
      isExpanded: true,
    );
  }
}
