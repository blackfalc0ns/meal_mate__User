import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/offer_checkout_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/activation/activation_summary_item_row.dart';

/// Card showing package, pricing, and discount details on the activation success screen.
class ActivationOrderSummaryCard extends StatelessWidget {
  const ActivationOrderSummaryCard({super.key, required this.checkout});

  final OfferCheckoutArgs checkout;

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
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: color.primary, size: 24),
              const SizedBox(width: Spacing.sm),
              Text(
                locale.offer_activation_order_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          ActivationSummaryItemRow(
            label: locale.offer_checkout_package_label,
            value: checkout.packageName,
          ),
          const SizedBox(height: Spacing.sm),
          ActivationSummaryItemRow(
            label: locale.offer_checkout_original_price,
            value:
                '${checkout.originalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
          ),
          const SizedBox(height: Spacing.sm),
          ActivationSummaryItemRow(
            label: locale.offer_checkout_discount_amount,
            value:
                '-${checkout.discountAmountKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
            valueColor: color.primary,
            isBold: true,
          ),
          const Divider(height: Spacing.xl),
          ActivationSummaryItemRow(
            label: locale.offer_activation_paid_total,
            value:
                '${checkout.finalPriceKwd.toStringAsFixed(3)} ${locale.currency_kwd}',
            valueColor: color.primary,
            fontSize: FontSize.size17,
            isBold: true,
          ),
        ],
      ),
    );
  }
}
