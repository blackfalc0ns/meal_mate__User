import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_amount_text.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.subtitle,
  });

  final String title;
  final String amount;
  final String currency;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.walletBalanceCardRadius),
      child: Container(
        height: Spacing.walletRefundHeroHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.primary, color.tertiary],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xl,
            vertical: Spacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size17,
                        color: color.onPrimary,
                      ),
                    ),
                    WalletAmountText(
                      amount: amount,
                      currency: currency,
                      amountFontSize: FontSize.size40,
                      currencyFontSize: FontSize.size20,
                      color: color.onPrimary,
                    ),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getLightStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.xl),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: color.onPrimary,
                size: Spacing.iconXl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
