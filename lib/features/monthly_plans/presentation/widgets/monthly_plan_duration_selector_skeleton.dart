import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class MonthlyPlanDurationSelectorSkeleton extends StatelessWidget {
  const MonthlyPlanDurationSelectorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedDirectional(
          top: Spacing.monthlyPlanDurationHeaderTop,
          start: Spacing.monthlyPlanDurationHeaderEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ShimmerPlaceholder.circle(size: Spacing.lg),
              SizedBox(width: Spacing.xs),
              ShimmerPlaceholder.rect(
                width: Spacing.xxxl,
                height: Spacing.md,
                borderRadius: Spacing.radiusPill,
              ),
            ],
          ),
        ),
        for (var index = 0; index < 3; index++)
          Positioned(
            left: _durationStart(index),
            top: Spacing.monthlyPlanDurationOptionTop,
            width: Spacing.monthlyPlanDurationOptionWidth,
            child: Column(
              children: const [
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
          ),
        Positioned(
          top: Spacing.monthlyPlanDurationFridayTop,
          left: 0,
          right: 0,
          child: const Center(
            child: ShimmerPlaceholder.rect(
              width: Spacing.xxxl * 1.5,
              height: Spacing.md,
              borderRadius: Spacing.radiusPill,
            ),
          ),
        ),
      ],
    );
  }

  static double _durationStart(int index) {
    return switch (index) {
      0 => Spacing.monthlyPlanDurationMonthOptionLeft,
      1 => Spacing.monthlyPlanDurationHalfMonthOptionLeft,
      _ => Spacing.monthlyPlanDurationWeekOptionLeft,
    };
  }
}
