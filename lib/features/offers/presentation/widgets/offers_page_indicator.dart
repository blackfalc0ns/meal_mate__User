import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OffersPageIndicator extends StatelessWidget {
  const OffersPageIndicator({
    super.key,
    this.itemCount = 4,
    this.activeIndex = 0,
  });

  final int itemCount;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (itemCount <= 1) return const SizedBox.shrink();

    return Semantics(
      label: locale.nav_offers,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          final selected = index == activeIndex;
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
                  ? color.primary
                  : color.outlineVariant.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
          );
        }),
      ),
    );
  }
}
