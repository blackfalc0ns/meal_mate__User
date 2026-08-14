import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionSummaryValueTile extends StatelessWidget {
  const SubscriptionSummaryValueTile({
    super.key,
    required this.width,
    required this.height,
    required this.label,
    required this.value,
    required this.labelTop,
    required this.valueTop,
  });

  final double width;
  final double height;
  final String label;
  final String value;
  final double labelTop;
  final double valueTop;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: '$label: $value',
      textDirection: locale.localeName == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        width: width,
        constraints: BoxConstraints(minHeight: height),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(
            color: color.outlineVariant,
            width: Spacing.subscriptionSummaryCardBorder,
          ),
          borderRadius: BorderRadius.circular(
            Spacing.subscriptionSummaryCardRadius,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ).copyWith(height: FontSize.size18 / FontSize.size14),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.primary,
              ).copyWith(height: FontSize.size22 / FontSize.size16),
            ),
          ],
        ),
      ),
    );
  }
}
