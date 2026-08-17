import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class RestaurantTierUpgradeActions extends StatelessWidget {
  const RestaurantTierUpgradeActions({
    super.key,
    required this.confirmLabel,
    required this.backLabel,
    required this.onConfirm,
    required this.onBack,
  });

  final String confirmLabel;
  final String backLabel;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        AppButton.filled(
          text: confirmLabel,
          onPressed: onConfirm,
          height: Spacing.restaurantTierBottomButtonHeight + Spacing.xs,
          borderRadius: Spacing.radiusPill,
          color: color.primary,
          textColor: color.onPrimary,
          fontSize: FontSize.size18,
          iconWidget: Icon(
            Icons.offline_bolt_rounded,
            color: color.onPrimary,
            size: Spacing.iconMd,
            semanticLabel: locale.subscription_summary_restaurant_tier_label,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppButton.outlined(
          text: backLabel,
          onPressed: onBack,
          height: Spacing.restaurantTierBottomButtonHeight + Spacing.xs,
          borderRadius: Spacing.radiusPill,
          color: color.primary,
          textColor: color.primary,
          fontSize: FontSize.size18,
        ),
      ],
    );
  }
}
