import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class WalletAmountText extends StatelessWidget {
  const WalletAmountText({
    super.key,
    required this.amount,
    required this.currency,
    this.amountFontSize = FontSize.size19,
    this.currencyFontSize = FontSize.size11,
    this.color,
  });

  final String amount;
  final String currency;
  final double amountFontSize;
  final double currencyFontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);
    final textColor = this.color ?? color.primary;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$amount ',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: amountFontSize,
              color: textColor,
            ),
          ),
          TextSpan(
            text: currency,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: currencyFontSize,
              color: textColor,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textDirection: Directionality.of(context),
    );
  }
}
