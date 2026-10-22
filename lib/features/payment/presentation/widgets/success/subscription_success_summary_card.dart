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

    final conf = args.confirmation;
    final packageName =
        (args.packageName != null && args.packageName!.isNotEmpty)
            ? args.packageName!
            : (conf != null ? conf.bundleName(locale.localeName) : '');
    final durationDays = args.durationDays ?? conf?.durationDays;
    final duration =
        args.durationLabel ??
        (durationDays != null
            ? '$durationDays ${locale.health_goals_days}'
            : '');
    final restaurantTier =
        (args.restaurantTier != null && args.restaurantTier!.isNotEmpty)
            ? args.restaurantTier!
            : (conf != null ? conf.tierName(locale.localeName) : '');
    final paymentDate =
        (args.paymentDate != null && args.paymentDate!.isNotEmpty)
            ? args.paymentDate!
            : (conf?.paymentDate ?? '');
    final startDate =
        (args.startDate != null && args.startDate!.isNotEmpty)
            ? args.startDate!
            : (conf?.startDate ?? '');
    final endDate =
        (args.endDate != null && args.endDate!.isNotEmpty)
            ? args.endDate!
            : (conf?.endDate ?? '');

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
            icon: Icons.inventory_2_outlined,
            label: locale.subscription_success_package_label,
            value: packageName,
          ),
          SubscriptionSuccessSummaryItemRow(
            icon: Icons.calendar_today_outlined,
            label: locale.subscription_success_duration_label,
            value: duration,
          ),
          SubscriptionSuccessSummaryItemRow(
            icon: Icons.military_tech_outlined,
            label: locale.subscription_success_tier_label,
            value: restaurantTier,
          ),
          SubscriptionSuccessSummaryItemRow(
            icon: Icons.calendar_month_outlined,
            label: locale.subscription_success_payment_date_label,
            value: paymentDate,
          ),
          SubscriptionSuccessSummaryItemRow(
            icon: Icons.event_available_outlined,
            label: locale.subscription_success_start_date_label,
            value: startDate,
          ),
          SubscriptionSuccessSummaryItemRow(
            icon: Icons.event_outlined,
            label: locale.subscription_success_end_date_label,
            value: endDate,
            showDivider: args.confirmation != null,
          ),
          if (args.confirmation != null && args.confirmation!.appliedDiscount > 0)
            SubscriptionSuccessSummaryItemRow(
              icon: Icons.discount_outlined,
              label: locale.subscription_success_applied_discount_label,
              value:
                  '-${args.confirmation!.appliedDiscount.toStringAsFixed(3)} ${args.confirmation!.currency}',
            ),
          if (args.confirmation != null)
            SubscriptionSuccessSummaryItemRow(
              icon: Icons.receipt_long_outlined,
              label: locale.subscription_success_paid_amount_label,
              value:
                  '${args.confirmation!.paidAmount.toStringAsFixed(3)} ${args.confirmation!.currency}',
              showDivider: false,
            ),
        ],
      ),
    );
  }
}
