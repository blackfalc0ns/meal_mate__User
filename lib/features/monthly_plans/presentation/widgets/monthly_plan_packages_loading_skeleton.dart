import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_card_skeleton.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class MonthlyPlanPackagesLoadingSkeleton extends StatelessWidget {
  const MonthlyPlanPackagesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerPlaceholder.rect(
              width: Spacing.iconMd,
              height: Spacing.iconMd,
              borderRadius: Spacing.radiusXs,
            ),
            SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholder.rect(
                    width: Spacing.xxxl * 3.5,
                    height: Spacing.base,
                    borderRadius: Spacing.radiusPill,
                  ),
                  SizedBox(height: Spacing.xs),
                  ShimmerPlaceholder.rect(
                    width: Spacing.xxxl * 5.0,
                    height: Spacing.xss + Spacing.xs,
                    borderRadius: Spacing.radiusPill,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.lg),
        for (var index = 0; index < 3; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == 2 ? Spacing.zero : Spacing.monthlyPlanPackageGap,
            ),
            child: RestaurantPackageTierCardSkeleton(
              width: double.infinity,
              height: Spacing.monthlyPlanPackageSideHeight,
              index: index,
            ),
          ),
      ],
    );
  }
}
