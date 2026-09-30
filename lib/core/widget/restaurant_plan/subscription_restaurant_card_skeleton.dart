import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionRestaurantCardSkeleton extends StatelessWidget {
  const SubscriptionRestaurantCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.sm,
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
          ShimmerPlaceholder.circle(size: Spacing.iconXl),
          SizedBox(height: Spacing.xs),
          ShimmerPlaceholder.rect(width: 54, height: 12, borderRadius: 4),
          SizedBox(height: Spacing.xs),
          ShimmerPlaceholder.rect(width: 38, height: 9, borderRadius: 3),
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
