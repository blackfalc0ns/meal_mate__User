import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class AppSubscriptionNextButton extends StatelessWidget {
  const AppSubscriptionNextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppButton.filled(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      borderRadius: Spacing.radiusPill,
      textColor: color.onPrimary,
      fontSize: FontSize.size12,
      iconWidget: Icon(
        isRtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
        color: color.onPrimary,
        size: Spacing.iconMd,
      ),
    );
  }
}
