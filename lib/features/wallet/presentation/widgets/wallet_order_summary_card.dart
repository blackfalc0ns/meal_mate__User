import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletOrderSummaryCard extends StatelessWidget {
  const WalletOrderSummaryCard({
    super.key,
    required this.amount,
    required this.currency,
    required this.cardDigits,
  });

  final String amount;
  final String currency;
  final String cardDigits;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final rows = [
      (
        locale.wallet_summary_receiving_card,
        '•••• $cardDigits',
        color.onSurface,
      ),
      (locale.wallet_summary_amount, '$amount $currency', color.primary),
      (locale.wallet_summary_fees, locale.wallet_summary_free, color.primary),
      (
        locale.wallet_summary_expected_receipt,
        locale.wallet_summary_expected_receipt_value,
        color.primary,
      ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.walletInfoRadius),
      ),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++)
            Column(
              children: [
                SizedBox(
                  height: Spacing.buttonSmallHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                    ),
                    child: Row(
                      children: [
                        Text(
                          rows[index].$2,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: rows[index].$3,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          rows[index].$1,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (index != rows.length - 1)
                  Divider(height: Spacing.border, color: color.outlineVariant),
              ],
            ),
        ],
      ),
    );
  }
}
