import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_order_summary_card.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';

/// Encapsulates the subscription summary card section in PaymentScreen.
class PaymentOrderSummarySection extends StatelessWidget {
  const PaymentOrderSummarySection({super.key, required this.paymentArgs});

  final PaymentArgs paymentArgs;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final localeName = locale.localeName;
    final summary = paymentArgs.summary;

    final discountAmount =
        summary.campaignDiscount + summary.promoDiscount + summary.walletCredit;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: AppOrderSummaryCard(
        planTitle: summary.bundleName(localeName),
        planDuration: '${summary.durationDays} ${locale.subscription_day}',
        mealsPerDay: summary.programName(localeName),
        originalPrice: summary.finalPrice.toStringAsFixed(3),
        discountAmount: discountAmount.toStringAsFixed(3),
        totalPrice: summary.finalPrice.toStringAsFixed(3),
        imageAsset: Assets.monthlyPlanHero,
        imageUrl: summary.imageUrl,
        couponHint: locale.payment_coupon_hint,
      ),
    );
  }
}
