import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_card_skeleton.dart';

class FamilyPackageTiersLoadingSkeleton extends StatelessWidget {
  const FamilyPackageTiersLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.calendar_browse_restaurants,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: Spacing.iconMd,
                height: Spacing.iconMd,
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: Spacing.sm,
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Container(
                      width: 200,
                      height: Spacing.xs,
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      ),
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
