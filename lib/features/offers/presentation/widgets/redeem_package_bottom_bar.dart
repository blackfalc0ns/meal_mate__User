import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class RedeemPackageBottomBar extends StatelessWidget {
  const RedeemPackageBottomBar({
    super.key,
    required this.finalPrice,
    required this.currency,
    required this.canPay,
    required this.isLoading,
    required this.onPay,
  });

  final double finalPrice;
  final String currency;
  final bool canPay;
  final bool isLoading;
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.md,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: color.outlineVariant.withValues(alpha: 0.35),
            width: Spacing.border,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        locale.offer_redeem_total_after_discount,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${finalPrice.toStringAsFixed(3)} $currency',
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size18,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: AppButton(
                    text: canPay
                        ? locale.payment_pay_now_button
                        : locale.offer_redeem_proceed_button,
                    onPressed: canPay && !isLoading ? onPay : null,
                    height: 44,
                    borderRadius: Spacing.radiusPill,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: color.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  locale.offer_redeem_safe_payment_notice,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
