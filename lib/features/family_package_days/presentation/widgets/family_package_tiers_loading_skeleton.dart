import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_card_skeleton.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyPackageTiersLoadingSkeleton extends StatelessWidget {
  const FamilyPackageTiersLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.calendar_browse_restaurants,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              ShimmerPlaceholder.circle(size: Spacing.iconMd),
              SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder.rect(
                      width: 140,
                      height: Spacing.sm,
                      borderRadius: Spacing.radiusSm,
                    ),
                    SizedBox(height: Spacing.xs),
                    ShimmerPlaceholder.rect(
                      width: 200,
                      height: Spacing.xs,
                      borderRadius: Spacing.radiusSm,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(
                bottom: Spacing.monthlyPlanPackageGap,
              ),
              child: RestaurantPackageTierCardSkeleton(
                width: double.infinity,
                height: Spacing.monthlyPlanPackageSideHeight,
                index: i,
              ),
            ),
        ],
      ),
    );
  }
}
