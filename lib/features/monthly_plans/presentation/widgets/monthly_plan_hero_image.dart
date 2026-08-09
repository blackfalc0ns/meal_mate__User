import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanHeroImage extends StatelessWidget {
  const MonthlyPlanHeroImage({super.key, required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Positioned(
      left: -Spacing.monthlyPlanHeroImageLeft,
      top: -Spacing.monthlyPlanHeroImageTop,
      width: Spacing.monthlyPlanHeroImageWidth,
      height: Spacing.monthlyPlanHeroImageHeight,
      child: Semantics(
        image: true,
        label: locale.nav_subscription,
        child: ColoredBox(
          color: color.surface,
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
