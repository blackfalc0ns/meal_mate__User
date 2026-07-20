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
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: color.outlineVariant,
            width: Spacing.subscriptionSummaryCardBorder,
          ),
          borderRadius: BorderRadius.circular(
            Spacing.subscriptionSummaryCardRadius,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: labelTop,
              left: 0,
              right: 0,
              height: Spacing.subscriptionSummaryLabelHeight,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style:
                    getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: Spacing.subscriptionSummaryLabelFontSize,
                      color: color.onSurface,
                    ).copyWith(
                      height:
                          Spacing.subscriptionSummaryLabelLineHeight /
                          Spacing.subscriptionSummaryLabelFontSize,
                    ),
              ),
            ),
            Positioned(
              top: valueTop,
              left: 0,
              right: 0,
              height: Spacing.subscriptionSummaryValueHeight,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style:
                    getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: Spacing.subscriptionSummaryValueFontSize,
                      color: color.primary,
                    ).copyWith(
                      height:
                          Spacing.subscriptionSummaryValueLineHeight /
                          Spacing.subscriptionSummaryValueFontSize,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
