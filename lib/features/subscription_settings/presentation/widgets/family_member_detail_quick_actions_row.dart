import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action.dart';

class FamilyMemberDetailQuickActionsRow extends StatelessWidget {
  const FamilyMemberDetailQuickActionsRow({super.key, required this.member});

  final FamilyMemberDetailEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        Expanded(
          child: SubscriptionBillingAction(
            iconAsset: Assets.profileBillingUpgradeTier,
            label: locale.billing_upgrade_tier,
            actionColor: color.billingUpgradeTier,
            backgroundColor: color.billingUpgradeTier.withValues(alpha: 0.08),
            onTap: member.onUpgradeTier,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: SubscriptionBillingAction(
            iconAsset: Assets.profileBillingFreeze,
            label: locale.billing_freeze,
            actionColor: color.billingFreeze,
            backgroundColor: color.billingFreeze.withValues(alpha: 0.08),
            onTap: member.onFreeze,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: SubscriptionBillingAction(
            iconAsset: Assets.profileBillingRenew,
            label: locale.billing_renew,
            actionColor: color.billingRenew,
            backgroundColor: color.billingRenew.withValues(alpha: 0.08),
            onTap: member.onRenew,
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: SubscriptionBillingAction(
            iconAsset: Assets.profileBillingCancel,
            label: locale.billing_cancel,
            actionColor: color.billingCancel,
            backgroundColor: color.billingCancel.withValues(alpha: 0.08),
            onTap: member.onCancel,
          ),
        ),
      ],
    );
  }
}
