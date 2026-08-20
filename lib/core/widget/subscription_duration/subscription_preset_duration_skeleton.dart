import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionPresetDurationSkeleton extends StatelessWidget {
  const SubscriptionPresetDurationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: Spacing.monthlyPlanDurationOptionWidth,
      child: Column(
        children: [
          ShimmerPlaceholder.rect(
            width: Spacing.monthlyPlanDurationOptionWidth,
            height: Spacing.md,
            borderRadius: Spacing.radiusPill,
          ),
          SizedBox(height: Spacing.xs),
          ShimmerPlaceholder.rect(
            width: Spacing.monthlyPlanDurationOptionWidth,
            height: Spacing.monthlyPlanDurationOptionHeight,
            borderRadius: Spacing.monthlyPlanDurationOptionRadius,
          ),
        ],
      ),
    );
  }
}
