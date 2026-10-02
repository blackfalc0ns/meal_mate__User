import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Single key-value row with optional divider for the subscription summary card.
class SubscriptionSuccessSummaryItemRow extends StatelessWidget {
  const SubscriptionSuccessSummaryItemRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: color.outlineVariant,
            height: Spacing.xs,
            thickness: Spacing.hairline,
          ),
      ],
    );
  }
}
