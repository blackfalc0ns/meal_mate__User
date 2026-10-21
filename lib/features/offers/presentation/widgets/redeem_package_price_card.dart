import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

class RedeemPackagePriceCard extends StatelessWidget {
  const RedeemPackagePriceCard({super.key, required this.summary});

  final SubscriptionSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final scale = summary.moneyScale;
    final currency = summary.currencyCode.isNotEmpty
        ? summary.currencyCode
        : locale.currency;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.5),
          width: Spacing.border,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.offer_checkout_order_summary_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),

          // Base price
          _buildRow(
            label: locale.offer_checkout_original_price,
            value: '${summary.basePrice.toStringAsFixed(scale)} $currency',
            valueColor: color.onSurface,
          ),

          // Campaign discount
          if (summary.campaignDiscount > 0) ...[
            const SizedBox(height: Spacing.xs),
            _buildRow(
              label: locale.offer_checkout_discount_amount,
              value: '-${summary.campaignDiscount.toStringAsFixed(scale)} $currency',
              valueColor: color.primary,
              isBold: true,
            ),
          ],

          // Promo discount
          if (summary.promoDiscount > 0) ...[
            const SizedBox(height: Spacing.xs),
            _buildRow(
              label: locale.offer_details_code_label,
              value: '-${summary.promoDiscount.toStringAsFixed(scale)} $currency',
              valueColor: color.primary,
              isBold: true,
            ),
          ],

          // Gateway fee
          if (summary.gatewayFee > 0) ...[
            const SizedBox(height: Spacing.xs),
            _buildRow(
              label: 'رسوم الخدمة',
              value: '+${summary.gatewayFee.toStringAsFixed(scale)} $currency',
              valueColor: color.onSurfaceVariant,
            ),
          ],

          Divider(
            height: Spacing.lg,
            color: color.outlineVariant.withValues(alpha: 0.5),
          ),

          // Final Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.offer_checkout_final_total,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              Text(
                '${summary.finalPrice.toStringAsFixed(scale)} $currency',
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    required Color valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: valueColor,
          ),
        ),
        Text(
          value,
          style: isBold
              ? getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: valueColor,
                )
              : getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: valueColor,
                ),
        ),
      ],
    );
  }
}
