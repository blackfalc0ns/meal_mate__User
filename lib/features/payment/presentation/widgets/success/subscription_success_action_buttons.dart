import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

/// Bottom action buttons on the payment success screen.
class SubscriptionSuccessActionButtons extends StatelessWidget {
  const SubscriptionSuccessActionButtons({
    super.key,
    required this.onStartMeals,
    required this.onViewSubscription,
  });

  final VoidCallback onStartMeals;
  final VoidCallback onViewSubscription;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton.filled(
            text: locale.subscription_success_start_meals_button,
            onPressed: onStartMeals,
          ),
          const SizedBox(height: Spacing.sm),
          AppButton.outlined(
            text: locale.subscription_success_view_subscription_button,
            iconWidget: Icon(
              Icons.receipt_long_rounded,
              size: Spacing.iconSm,
              color: color.primary,
            ),
            iconBeforeText: true,
            onPressed: onViewSubscription,
          ),
        ],
      ),
    );
  }
}
