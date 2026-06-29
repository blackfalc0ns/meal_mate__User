import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

/// ─────────────────────────────────────────────────────────────
/// Sticky footer at the bottom of the payment screen.
/// Shows the total, a collapsible breakdown toggle,
/// the pay button and the "secure payment" label.
/// ─────────────────────────────────────────────────────────────
class PaymentFooter extends StatelessWidget {
  const PaymentFooter({
    super.key,
    required this.totalAmount,
    required this.onPayNow,
    this.isLoading = false,
  });

  final double totalAmount;
  final VoidCallback onPayNow;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Container(
      padding: EdgeInsets.only(
        top: Spacing.base,
        left: Spacing.base,
        right: Spacing.base,
        bottom: MediaQuery.of(context).padding.bottom + Spacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Total row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Collapse toggle
              Row(
                children: [
                  const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.payment_total_includes_tax,
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              // Amount + label
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.payment_total_label,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${totalAmount.toStringAsFixed(3)} ${l10n.currency}',
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size22,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // ── Pay button ──
          AppButton(
            text: '🔒  ${l10n.payment_pay_now_button}',
            isLoading: isLoading,
            onPressed: isLoading ? null : onPayNow,
          ),
          const SizedBox(height: Spacing.sm),

          // ── Secure label ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded,
                  size: 13, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(
                l10n.payment_secure_label,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
