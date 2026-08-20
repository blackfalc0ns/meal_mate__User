import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_custom_duration_skeleton.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_preset_duration_skeleton.dart';

class SubscriptionDurationSelectorSkeleton extends StatelessWidget {
  const SubscriptionDurationSelectorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerPlaceholder.circle(size: Spacing.lg),
              SizedBox(width: Spacing.xs),
              ShimmerPlaceholder.rect(
                width: Spacing.xxxl,
                height: Spacing.md,
                borderRadius: Spacing.radiusPill,
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < 3; index++) ...[
                  if (index > 0) const SizedBox(width: Spacing.sm),
                  const SubscriptionPresetDurationSkeleton(),
                ],
                const Spacer(),
                const SubscriptionCustomDurationSkeleton(),
              ],
            ),
          ),
          const Center(
            child: ShimmerPlaceholder.rect(
              width: Spacing.xxxl * 1.5,
              height: Spacing.md,
              borderRadius: Spacing.radiusPill,
            ),
          ),
        ],
      ),
    );
  }
}
