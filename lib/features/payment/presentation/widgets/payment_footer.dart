import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';

class PaymentFooter extends StatelessWidget {
  const PaymentFooter({
    super.key,
    required this.totalAmount,
    this.onPayNow,
    this.isLoading = false,
  });

  final double totalAmount;
  final VoidCallback? onPayNow;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.sm),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: color.onSurface,
                ),
                const SizedBox(width: Spacing.xs),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.payment_total_label,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.payment_total_includes_tax,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${totalAmount.toStringAsFixed(3)} ${locale.currency}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size20,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          CustomAppButton(
            text: locale.payment_pay_now_button,
            height: Spacing.xxxl,
            isLoading: isLoading,
            onPressed: isLoading ? null : onPayNow,
            iconWidget: Icon(
              Icons.lock_outline_rounded,
              color: color.onPrimary,
              size: 15,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 11,
                color: color.onSurfaceVariant,
              ),
              const SizedBox(width: Spacing.xxs),
              Text(
                locale.payment_secure_label,
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
    );
  }
}
