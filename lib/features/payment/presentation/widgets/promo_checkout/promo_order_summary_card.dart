import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/payment/domain/entities/offer_checkout_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/promo_checkout/promo_order_summary_item_row.dart';

/// Card showing package, meals count, original price, discount, and final price on promo checkout.
class PromoOrderSummaryCard extends StatelessWidget {
  const PromoOrderSummaryCard({super.key, required this.args});

  final OfferCheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.md),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.offer_checkout_order_summary_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size15,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          PromoOrderSummaryItemRow(
            label: locale.offer_checkout_package_label,
            value: args.packageName,
          ),
          const SizedBox(height: Spacing.sm),
          PromoOrderSummaryItemRow(
            label: locale.offer_checkout_meals_per_day,
            value: '${args.mealsPerDay} ${locale.meals_count}',
          ),
          const SizedBox(height: Spacing.sm),
          PromoOrderSummaryItemRow(
            label: locale.offer_checkout_original_price,
            value:
                '${args.originalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
          ),
          const SizedBox(height: Spacing.sm),
          PromoOrderSummaryItemRow(
            label: locale.offer_checkout_discount_amount,
            value:
                '-${args.discountAmountKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
            valueColor: color.primary,
            isBold: true,
          ),
          const Divider(height: Spacing.xl),
          PromoOrderSummaryItemRow(
            label: locale.offer_checkout_final_total,
            value:
                '${args.finalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
            valueColor: color.primary,
            fontSize: FontSize.size17,
            isBold: true,
          ),
        ],
      ),
    );
  }
}
