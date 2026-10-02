import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Banner notifying the user that payment has been confirmed and subscription is active.
class SubscriptionPaymentConfirmedBanner extends StatelessWidget {
  const SubscriptionPaymentConfirmedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.primary.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Spacing.avatarSm,
            height: Spacing.avatarSm,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.primary,
            ),
            child: Icon(
              Icons.check_rounded,
              size: Spacing.iconSm,
              color: color.onPrimary,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.subscription_success_payment_confirmed_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  locale.subscription_success_payment_confirmed_desc,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
