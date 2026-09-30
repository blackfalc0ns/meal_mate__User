import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionCustomDurationSkeleton extends StatelessWidget {
  const SubscriptionCustomDurationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: Spacing.monthlyPlanDurationCustomGroupWidth,
      ),
      child: Column(
        children: [
          const ShimmerPlaceholder.rect(
            width: Spacing.monthlyPlanCustomDurationWidth,
            height: Spacing.md,
            borderRadius: Spacing.radiusPill,
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ShimmerPlaceholder.circle(
                size: Spacing.monthlyPlanDurationControlWidth,
              ),
              const SizedBox(width: Spacing.xxs),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Spacing.monthlyPlanCustomDurationWidth,
                  ),
                  child: const SizedBox(
                    height: Spacing.monthlyPlanDurationCustomInputHeight,
                    width: double.infinity,
                    child: ShimmerPlaceholder.rect(
                      height: Spacing.monthlyPlanDurationCustomInputHeight,
                      borderRadius: Spacing.monthlyPlanDurationOptionRadius,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xxs),
              const ShimmerPlaceholder.circle(
                size: Spacing.monthlyPlanDurationControlWidth,
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          const ShimmerPlaceholder.rect(
            width: Spacing.monthlyPlanDurationCustomGroupWidth,
            height: Spacing.sm,
            borderRadius: Spacing.radiusPill,
          ),
        ],
      ),
    );
  }
}
