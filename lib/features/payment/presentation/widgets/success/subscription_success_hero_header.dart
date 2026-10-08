import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Hero header displaying the green success illustration, headline, and description.
class SubscriptionSuccessHeroHeader extends StatelessWidget {
  const SubscriptionSuccessHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.sm,
      ),
      child: Column(
        children: [
          Image.asset(
            Assets.subscriptionSuccessHero,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Spacing.base),
          Text(
            locale.subscription_success_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size18,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.subscription_success_subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
