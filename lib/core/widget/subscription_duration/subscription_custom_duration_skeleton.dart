import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionCustomDurationSkeleton extends StatelessWidget {
  const SubscriptionCustomDurationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: Spacing.monthlyPlanDurationCustomGroupWidth,
      child: Column(
        children: [
          ShimmerPlaceholder.rect(
            width: Spacing.monthlyPlanCustomDurationWidth,
            height: Spacing.md,
            borderRadius: Spacing.radiusPill,
          ),
          SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder.circle(
                size: Spacing.monthlyPlanDurationControlWidth,
              ),
              ShimmerPlaceholder.rect(
                width: Spacing.monthlyPlanCustomDurationWidth,
                height: Spacing.monthlyPlanDurationCustomInputHeight,
                borderRadius: Spacing.monthlyPlanDurationOptionRadius,
              ),
              ShimmerPlaceholder.circle(
                size: Spacing.monthlyPlanDurationControlWidth,
              ),
            ],
          ),
          SizedBox(height: Spacing.xs),
          ShimmerPlaceholder.rect(
            width: Spacing.monthlyPlanDurationCustomGroupWidth,
            height: Spacing.sm,
            borderRadius: Spacing.radiusPill,
          ),
        ],
      ),
    );
  }
}
