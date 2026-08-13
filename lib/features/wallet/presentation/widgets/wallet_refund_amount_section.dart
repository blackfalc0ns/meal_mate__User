import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_amount_text.dart';

class WalletRefundAmountSection extends StatelessWidget {
  const WalletRefundAmountSection({
    super.key,
    required this.amount,
    required this.currency,
  });

  final String amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          locale.wallet_refund_amount,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size16,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Container(
          height: Spacing.walletAmountInputHeight,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
          alignment: AlignmentDirectional.centerEnd,
          decoration: BoxDecoration(
            border: Border.all(color: color.onSurfaceVariant),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
          ),
          child: WalletAmountText(
            amount: amount,
            currency: currency,
            amountFontSize: FontSize.size20,
            currencyFontSize: FontSize.size11,
            color: color.onSurface,
          ),
        ),
      ],
    );
  }
}
