import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_order_summary_card.dart';

/// Encapsulates the subscription summary card section in SubscriptionCheckoutScreen.
class PaymentOrderSummarySection extends StatelessWidget {
  const PaymentOrderSummarySection({super.key, required this.paymentArgs});

  final SubscriptionCheckoutArgs paymentArgs;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final localeName = locale.localeName;
    final summary = paymentArgs.summary;

    final discountAmount =
        summary.campaignDiscount + summary.promoDiscount + summary.walletCredit;
    final basePriceValue = summary.basePrice > 0
        ? summary.basePrice
        : summary.finalPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: AppOrderSummaryCard(
        planTitle: summary.bundleName(localeName),
        planDuration: '${summary.durationDays} ${locale.subscription_day}',
        mealsPerDay: summary.programName(localeName),
        originalPrice: basePriceValue.toStringAsFixed(3),
        discountAmount: discountAmount.toStringAsFixed(3),
        totalPrice: summary.finalPrice.toStringAsFixed(3),
        imageAsset: Assets.monthlyPlanHero,
        imageUrl: summary.imageUrl,
        couponHint: locale.payment_coupon_hint,
      ),
    );
  }
}
