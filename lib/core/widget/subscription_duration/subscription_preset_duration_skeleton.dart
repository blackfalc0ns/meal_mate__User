import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionPresetDurationSkeleton extends StatelessWidget {
  const SubscriptionPresetDurationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final placeholderColor = color.surfaceContainerHighest;

    return SizedBox(
      width: Spacing.monthlyPlanDurationOptionWidth,
      child: Column(
        children: [
          ShimmerWidget(
            baseColor: placeholderColor,
            highlightColor: color.surface,
            child: Container(
              width: Spacing.monthlyPlanDurationOptionWidth,
              height: Spacing.md,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Container(
            width: Spacing.monthlyPlanDurationOptionWidth,
            height: Spacing.monthlyPlanDurationOptionHeight,
            decoration: BoxDecoration(
              color: color.surface,
              border: Border.all(color: color.outlineVariant),
              borderRadius: BorderRadius.circular(
                Spacing.monthlyPlanDurationOptionRadius,
              ),
            ),
            child: ShimmerWidget(
              baseColor: placeholderColor,
              highlightColor: color.surface,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PositionedDirectional(
                    top: Spacing.xxs,
                    start: Spacing.xxs,
                    child: Container(
                      width: Spacing.monthlyPlanDurationStatusIconSize,
                      height: Spacing.monthlyPlanDurationStatusIconSize,
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 14,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(Spacing.radiusXs),
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Container(
                        width: 22,
                        height: 9,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(Spacing.radiusXs),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
