import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Single key-value row for the promo checkout summary card.
class PromoOrderSummaryItemRow extends StatelessWidget {
  const PromoOrderSummaryItemRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.fontSize,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final double? fontSize;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: fontSize ?? FontSize.size13,
            color: color.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: isBold
              ? getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: fontSize ?? FontSize.size13,
                  color: valueColor ?? color.onSurface,
                )
              : getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: fontSize ?? FontSize.size13,
                  color: valueColor ?? color.onSurface,
                ),
        ),
      ],
    );
  }
}
