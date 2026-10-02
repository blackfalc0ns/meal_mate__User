import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionCustomDurationSkeleton extends StatelessWidget {
  const SubscriptionCustomDurationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final placeholderColor = color.surfaceContainerHighest;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: Spacing.monthlyPlanDurationCustomGroupWidth,
      ),
      child: Column(
        children: [
          ShimmerWidget(
            baseColor: placeholderColor,
            highlightColor: color.surface,
            child: Container(
              width: Spacing.monthlyPlanCustomDurationWidth,
              height: Spacing.md,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerWidget(
                baseColor: placeholderColor,
                highlightColor: color.surface,
                child: Container(
                  width: Spacing.monthlyPlanDurationControlWidth,
                  height: Spacing.monthlyPlanDurationControlWidth,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xxs),
              Container(
                height: Spacing.monthlyPlanDurationCustomInputHeight,
                width: Spacing.monthlyPlanCustomDurationWidth,
                decoration: BoxDecoration(
                  color: color.surface,
                  border: Border.all(color: color.outlineVariant),
                  borderRadius: BorderRadius.circular(
                    Spacing.monthlyPlanDurationOptionRadius,
                  ),
                ),
                child: Center(
                  child: ShimmerWidget(
                    baseColor: placeholderColor,
                    highlightColor: color.surface,
                    child: Container(
                      width: 22,
                      height: 16,
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        borderRadius: BorderRadius.circular(Spacing.radiusXs),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xxs),
              ShimmerWidget(
                baseColor: placeholderColor,
                highlightColor: color.surface,
                child: Container(
                  width: Spacing.monthlyPlanDurationControlWidth,
                  height: Spacing.monthlyPlanDurationControlWidth,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          ShimmerWidget(
            baseColor: placeholderColor,
            highlightColor: color.surface,
            child: Container(
              width: Spacing.monthlyPlanDurationCustomGroupWidth,
              height: Spacing.sm,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
