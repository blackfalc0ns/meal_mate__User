import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class MonthlyPlanRestaurantsLoadingSkeleton extends StatelessWidget {
  const MonthlyPlanRestaurantsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Spacing.sm,
        crossAxisSpacing: Spacing.sm,
        childAspectRatio: 0.78,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return const _RestaurantCardSkeleton();
      },
    );
  }
}

class _RestaurantCardSkeleton extends StatelessWidget {
  const _RestaurantCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsetsDirectional.only(
        top: Spacing.md,
        bottom: Spacing.sm,
        start: Spacing.md,
        end: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.monthlyRestaurantCardRadius,
        ),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.monthlyRestaurantCardBorderWidth,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ShimmerPlaceholder.circle(
            size: Spacing.iconXl,
          ),
          SizedBox(height: Spacing.xs),
          ShimmerPlaceholder.rect(
            width: 54,
            height: 12,
            borderRadius: 4,
          ),
          SizedBox(height: Spacing.xs),
          ShimmerPlaceholder.rect(
            width: 38,
            height: 9,
            borderRadius: 3,
          ),
          Spacer(),
          ShimmerPlaceholder.rect(
            width: double.infinity,
            height: Spacing.monthlyRestaurantCardMetaHeight,
            borderRadius: Spacing.radiusPill,
          ),
        ],
      ),
    );
  }
}
