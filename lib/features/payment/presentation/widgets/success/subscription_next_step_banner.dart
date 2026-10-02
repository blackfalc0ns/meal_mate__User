import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Banner highlighting the next action: selecting meals and picking restaurants.
class SubscriptionNextStepBanner extends StatelessWidget {
  const SubscriptionNextStepBanner({super.key});

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
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Spacing.avatarSm,
            height: Spacing.avatarSm,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: Spacing.iconSm,
              color: color.primary,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.subscription_success_next_step_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  locale.subscription_success_next_step_desc,
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
