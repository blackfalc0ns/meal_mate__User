import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/app_order_summary_price_row.dart';

class AppOrderSummaryCard extends StatelessWidget {
  const AppOrderSummaryCard({
    super.key,
    required this.planTitle,
    required this.planDuration,
    required this.mealsPerDay,
    required this.originalPrice,
    required this.discountAmount,
    required this.totalPrice,
    required this.imageAsset,
    this.imageUrl,
    this.summaryTitle,
    this.discountLabel,
    this.couponHint,
  });

  final String planTitle;
  final String planDuration;
  final String mealsPerDay;
  final String originalPrice;
  final String discountAmount;
  final String totalPrice;
  final String imageAsset;
  final String? imageUrl;
  final String? summaryTitle;
  final String? discountLabel;
  final String? couponHint;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final parsedDiscount = double.tryParse(discountAmount) ?? 0.0;
    final hasDiscount = parsedDiscount > 0.0001;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.06),
            blurRadius: Spacing.md,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summaryTitle ?? locale.payment_order_summary_title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size16,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$planTitle - ',
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size15,
                                color: color.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: planDuration,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size15,
                                color: color.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        mealsPerDay,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: Spacing.sm),

              AppCachedNetworkImage(
                imageUrl: imageUrl,
                width: 140,
                height: 110,
                fit: BoxFit.contain,
              ),
            ],
          ),
          if (hasDiscount) ...[
            const SizedBox(height: Spacing.md),
            AppOrderSummaryPriceRow(
              label: locale.payment_base_price_label,
              value: '$originalPrice ${locale.currency}',
              valueColor: color.onSurfaceVariant,
            ),
            const SizedBox(height: Spacing.xs),
            AppOrderSummaryPriceRow(
              label: _discountText(locale.payment_discount_label),
              value: '-$discountAmount ${locale.currency}',
              valueColor: color.primary,
            ),
          ],
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Text(
                hasDiscount
                    ? locale.payment_total_after_discount
                    : locale.subscription_summary_total_price_label,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: color.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                '$totalPrice ${locale.currency}',
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.primary,
                ),
              ),
            ],
          ),
          if (couponHint != null && couponHint!.trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            Container(
              height: Spacing.buttonSmallHeight,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              decoration: BoxDecoration(
                color: color.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Spacing.sm),
                border: Border.all(color: color.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sell_outlined,
                    color: color.primary,
                    size: Spacing.iconSm + Spacing.xs,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      couponHint!,
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _discountText(String fallbackLabel) {
    if (discountLabel == null || discountLabel!.trim().isEmpty) {
      return fallbackLabel;
    }

    final baseLabel = fallbackLabel.contains('(')
        ? fallbackLabel.substring(0, fallbackLabel.indexOf('(')).trim()
        : fallbackLabel;
    return '$baseLabel ($discountLabel)';
  }
}
