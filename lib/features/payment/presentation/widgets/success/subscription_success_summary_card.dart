import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_summary_item_row.dart';

/// Card containing the 6 key details of the confirmed subscription.
class SubscriptionSuccessSummaryCard extends StatelessWidget {
  const SubscriptionSuccessSummaryCard({super.key, required this.args});

  final PaymentSuccessArgs args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final packageName = args.packageName ?? '';
    final duration =
        args.durationLabel ??
        (args.durationDays != null
            ? '${args.durationDays} ${locale.health_goals_days}'
            : '');
    final restaurantTier = args.restaurantTier ?? '';
    final paymentDate = args.paymentDate ?? '';
    final startDate = args.startDate ?? '';
    final endDate = args.endDate ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.base,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.subscription_success_summary_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          SubscriptionSuccessSummaryItemRow(
            label: locale.subscription_success_package_label,
            value: packageName,
          ),
          SubscriptionSuccessSummaryItemRow(
            label: locale.subscription_success_duration_label,
            value: duration,
          ),
          SubscriptionSuccessSummaryItemRow(
            label: locale.subscription_success_tier_label,
            value: restaurantTier,
          ),
          SubscriptionSuccessSummaryItemRow(
            label: locale.subscription_success_payment_date_label,
            value: paymentDate,
          ),
          SubscriptionSuccessSummaryItemRow(
            label: locale.subscription_success_start_date_label,
            value: startDate,
          ),
          SubscriptionSuccessSummaryItemRow(
            label: locale.subscription_success_end_date_label,
            value: endDate,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
