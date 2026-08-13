import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_amount_text.dart';

class WalletRefundHeroCard extends StatelessWidget {
  const WalletRefundHeroCard({
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

    return Container(
      height: Spacing.walletRefundHeroHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
      decoration: BoxDecoration(
        color: color.tertiaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(Spacing.walletInfoRadius),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.primaryContainer.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: Spacing.walletIconBubbleSize + Spacing.xl,
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: color.primary,
                size: Spacing.iconXl,
              ),
            ),
          ),
          const SizedBox(width: Spacing.xl),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  locale.wallet_refund_available_balance,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.primary,
                  ),
                ),
                WalletAmountText(
                  amount: amount,
                  currency: currency,
                  amountFontSize: FontSize.size40,
                  currencyFontSize: FontSize.size20,
                ),
                Text(
                  locale.wallet_refund_hero_subtitle,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
