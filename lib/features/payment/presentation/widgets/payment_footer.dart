import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.payment_total_label,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      l10n.payment_total_includes_tax,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${totalAmount.toStringAsFixed(3)} ${l10n.currency}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size20,
                    color: AppColors.primaryVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          CustomAppButton(
            text: l10n.payment_pay_now_button,
            height: 40,
            isLoading: isLoading,
            onPressed: isLoading ? null : onPayNow,
            iconWidget: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.white,
              size: 15,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 11,
                color: AppColors.textHint,
              ),
              const SizedBox(width: 3),
              Text(
                l10n.payment_secure_label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
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
