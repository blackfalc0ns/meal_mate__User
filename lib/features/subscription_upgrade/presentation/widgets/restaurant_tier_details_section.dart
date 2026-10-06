import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_detail_row.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_section_card.dart';

class RestaurantTierDetailsSection extends StatelessWidget {
  const RestaurantTierDetailsSection({
    super.key,
    required this.selectedOption,
    this.summary,
  });

  final SubscriptionUpgradeOptionEntity selectedOption;
  final SubscriptionUpgradeSummaryEntity? summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final rawCurrency = selectedOption.currencyCode.isNotEmpty
        ? selectedOption.currencyCode
        : 'KWD';
    final currencyText =
        (rawCurrency.isEmpty || rawCurrency.toUpperCase() == 'KWD')
            ? locale.currency
            : rawCurrency;

    final currentCredit = summary?.currentRemainingCredit ??
        selectedOption.currentRemainingCredit;
    final targetPrice = summary?.targetRemainingPrice ??
        selectedOption.targetRemainingPrice;
    final priceDiff = summary?.priceDifference ??
        selectedOption.priceDifference;

    return RestaurantTierSectionCard(
      title: locale.restaurant_tier_details_title,
      icon: Icons.receipt_long_rounded,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: color.outlineVariant),
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            child: Column(
              children: [
                RestaurantTierDetailRow(
                  label: locale.restaurant_tier_detail_current_credit,
                  value: '${currentCredit.toStringAsFixed(2)} $currencyText',
                ),
                RestaurantTierDetailRow(
                  label: locale.restaurant_tier_detail_target_price,
                  value: '${targetPrice.toStringAsFixed(2)} $currencyText',
                ),
                if (selectedOption.gatewayRecovery > 0)
                  RestaurantTierDetailRow(
                    label: locale.restaurant_tier_detail_gateway_recovery,
                    value:
                        '${selectedOption.gatewayRecovery.toStringAsFixed(2)} $currencyText',
                  ),
                Divider(color: color.outlineVariant),
                RestaurantTierDetailRow(
                  label: locale.restaurant_tier_total_amount_due,
                  value: '${priceDiff.toStringAsFixed(2)} $currencyText',
                  isStrong: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.priority_high_rounded,
                color: color.onSurfaceVariant,
                size: Spacing.iconSm,
                semanticLabel: locale.restaurant_tier_instant_apply_note,
              ),
              const SizedBox(width: Spacing.xs),
              Flexible(
                child: Text(
                  locale.restaurant_tier_instant_apply_note,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                  semanticsLabel:
                      locale.subscription_summary_restaurant_tier_label,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
