import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class RestaurantTierContinueButton extends StatelessWidget {
  const RestaurantTierContinueButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.restaurantTierHorizontalPadding,
          vertical: Spacing.xs,
        ),
        child: SizedBox(
          height: Spacing.restaurantTierBottomButtonHeight,
          width: double.infinity,
          child: AppButton.filled(
            text: text,
            onPressed: onPressed,
            height: Spacing.restaurantTierBottomButtonHeight,
            borderRadius: Spacing.radiusPill,
            color: color.primary,
            textColor: color.onPrimary,
            fontSize: FontSize.size16,
            iconWidget: Icon(
              Icons.chevron_right_rounded,
              color: color.onPrimary,
              size: Spacing.iconMd,
              semanticLabel: locale.subscription_summary_restaurant_tier_label,
            ),
          ),
        ),
      ),
    );
  }
}
