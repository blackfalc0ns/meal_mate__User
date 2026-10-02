import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Single line in the order summary card with a divider between label and value.
class AppOrderSummaryPriceRow extends StatelessWidget {
  const AppOrderSummaryPriceRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size13,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: color.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: valueColor ?? color.onSurface,
          ),
        ),
      ],
    );
  }
}
