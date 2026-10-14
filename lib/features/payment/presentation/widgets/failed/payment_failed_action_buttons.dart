import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

/// Action buttons displayed at the bottom of the payment failed screen.
class PaymentFailedActionButtons extends StatelessWidget {
  const PaymentFailedActionButtons({
    super.key,
    required this.onRetry,
    required this.onChangePaymentMethod,
    required this.onContactSupport,
  });

  final VoidCallback onRetry;
  final VoidCallback onChangePaymentMethod;
  final VoidCallback onContactSupport;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton.filled(
            borderRadius: Spacing.radiusPill,
            text: locale.payment_failed_retry_button,
            icon: Icons.refresh_rounded,
            onPressed: onRetry,
          ),
          const SizedBox(height: Spacing.sm),
          AppButton.outlined(
            borderRadius: Spacing.radiusPill,
            text: locale.payment_failed_change_method_button,
            icon: Icons.credit_card_rounded,
            onPressed: onChangePaymentMethod,
          ),
          const SizedBox(height: Spacing.sm),
          AppButton.text(
            text: locale.payment_failed_contact_support_button,
            icon: Icons.headset_mic_rounded,
            textColor: color.primary,
            onPressed: onContactSupport,
          ),
        ],
      ),
    );
  }
}
