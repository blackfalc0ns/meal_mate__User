import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

class SubscriptionBillingUncompletedSubscriptionCard extends StatelessWidget {
  const SubscriptionBillingUncompletedSubscriptionCard({
    required this.subscription,
    required this.isLoading,
    required this.onDelete,
    required this.onResume,
    super.key,
  });

  final SubscriptionBillingUncompletedSubscriptionEntity subscription;
  final bool isLoading;
  final VoidCallback onDelete;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final programName = isRtl
        ? subscription.programNameAr
        : subscription.programNameEn;
    final bundleName = isRtl
        ? subscription.bundleNameAr
        : subscription.bundleNameEn;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: color.secondaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Icon(
                  Icons.pending_actions_rounded,
                  size: Spacing.iconMd,
                  color: color.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      programName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      bundleName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${locale.billing_uncompleted_duration}: '
                  '${subscription.durationDays} '
                  '${locale.billing_uncompleted_days}',
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '${subscription.amount.toStringAsFixed(2)} '
                '${subscription.currencyCode}',
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Icon(
                subscription.isHoldActive
                    ? Icons.timer_outlined
                    : Icons.timer_off_outlined,
                size: Spacing.iconSm,
                color: subscription.isHoldActive ? color.tertiary : color.error,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  subscription.isHoldActive
                      ? locale.billing_uncompleted_hold_active
                      : locale.billing_uncompleted_hold_expired,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  text: locale.billing_uncompleted_delete,
                  onPressed: subscription.actions.canDelete && !isLoading
                      ? onDelete
                      : null,
                  height: Spacing.buttonSmallHeight,
                  borderRadius: Spacing.radiusPill,
                  color: color.error,
                  textColor: color.error,
                  fontSize: FontSize.size11,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: AppButton(
                  text: locale.billing_uncompleted_resume,
                  onPressed: subscription.actions.canResume && !isLoading
                      ? onResume
                      : null,
                  isLoading: isLoading,
                  height: Spacing.buttonSmallHeight,
                  borderRadius: Spacing.radiusPill,
                  color: color.primary,
                  textColor: color.onPrimary,
                  fontSize: FontSize.size11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
