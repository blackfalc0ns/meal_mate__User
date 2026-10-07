import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class SubscriptionBillingEmptySubscriptionCard extends StatelessWidget {
  const SubscriptionBillingEmptySubscriptionCard({
    super.key,
    this.hasUncompletedSubscriptions = false,
    this.onBrowseSubscriptions,
  });

  final bool hasUncompletedSubscriptions;
  final VoidCallback? onBrowseSubscriptions;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final imageAsset = hasUncompletedSubscriptions
        ? Assets.billingEmptySubscriptionBox
        : Assets.billingEmptySubscriptionKit;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.primaryContainer.withValues(alpha: 0.6),
            color.secondaryContainer,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(Spacing.profileBillingCardRadius),
        border: Border.all(color: color.surface),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imageAsset,
            height: 130,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.billing_no_active_subscription_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size17,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.billing_no_active_subscription_desc,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          SizedBox(
            width: double.infinity,
            height: Spacing.profileBillingButtonHeight + 8,
            child: AppButton(
              text: locale.billing_browse_subscriptions,
              onPressed: onBrowseSubscriptions,
              borderRadius: Spacing.radiusPill,
              color: color.primary,
              textColor: color.onPrimary,
              fontSize: FontSize.size12,
            ),
          ),
        ],
      ),
    );
  }
}
