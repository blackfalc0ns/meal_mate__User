import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_card_skeleton.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class MonthlyPlanPackagesLoadingSkeleton extends StatelessWidget {
  const MonthlyPlanPackagesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : Spacing.monthlyPlanPackagesWidth;
        final cardWidth = width < Spacing.monthlyPlanPackagesWidth
            ? width
            : Spacing.monthlyPlanPackagesWidth;

        return Center(
          child: SizedBox(
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: Spacing.iconMd,
                      height: Spacing.iconMd,
                      borderRadius: Spacing.radiusXs,
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: Spacing.xxxl * 3.5,
                      height: Spacing.xl,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                const ShimmerPlaceholder.rect(
                  width: Spacing.xxxl * 5.5,
                  height: Spacing.md,
                  borderRadius: Spacing.radiusPill,
                ),
                const SizedBox(height: Spacing.lg),
                for (var index = 0; index < 3; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 2
                          ? Spacing.zero
                          : Spacing.monthlyPlanPackageGap,
                    ),
                    child: RestaurantPackageTierCardSkeleton(
                      width: cardWidth,
                      height: Spacing.monthlyPlanPackageSideHeight,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
