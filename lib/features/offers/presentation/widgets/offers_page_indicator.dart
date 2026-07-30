import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OffersPageIndicator extends StatelessWidget {
  const OffersPageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.offers_title,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          final selected = index == 3;
          return Container(
            width: selected
                ? Spacing.offersIndicatorActiveWidth
                : Spacing.offersIndicatorDotSize,
            height: Spacing.offersIndicatorDotSize,
            margin: const EdgeInsets.symmetric(
              horizontal: Spacing.offersIndicatorGap / 2,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? color.onTertiaryContainer
                  : color.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
          );
        }),
      ),
    );
  }
}
