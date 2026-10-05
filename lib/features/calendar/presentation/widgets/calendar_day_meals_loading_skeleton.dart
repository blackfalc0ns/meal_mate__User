import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class CalendarDayMealsLoadingSkeleton extends StatelessWidget {
  const CalendarDayMealsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      key: const ValueKey('calendar-day-meals-loading-skeleton'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Status header shimmer ("تأكيد اختيار الوجبات")
        const Row(
          children: [
            ShimmerPlaceholder.circle(size: Spacing.iconMd),
            SizedBox(width: Spacing.xs),
            ShimmerPlaceholder.rect(
              width: 140,
              height: 18,
              borderRadius: Spacing.radiusXs,
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),

        // 2. Restaurant summary card shimmer
        Container(
          height: 126.0,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.calendarRestaurantSummaryRadius,
            ),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(Spacing.zero, Spacing.xs),
              ),
            ],
          ),
          child: const Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholder.circle(size: 42),
                  SizedBox(width: Spacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder.rect(
                        width: 130,
                        height: 16,
                        borderRadius: Spacing.radiusXs,
                      ),
                      SizedBox(height: Spacing.xs),
                      ShimmerPlaceholder.rect(
                        width: 70,
                        height: 12,
                        borderRadius: Spacing.radiusXs,
                      ),
                    ],
                  ),
                  Spacer(),
                  ShimmerPlaceholder.rect(
                    width: 50,
                    height: 22,
                    borderRadius: Spacing.radiusPill,
                  ),
                ],
              ),
              Spacer(),
              ShimmerPlaceholder.rect(
                width: double.infinity,
                height: 32,
                borderRadius: Spacing.radiusPill,
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),

        // 3. Daily macros card shimmer ("إجمالي القيم من هذا اليوم")
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const ShimmerPlaceholder.rect(
                width: 140,
                height: 12,
                borderRadius: Spacing.radiusXs,
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    if (i > 0) const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.xs,
                          horizontal: Spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius: BorderRadius.circular(Spacing.radiusSm),
                          border: Border.all(
                            color: color.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShimmerPlaceholder.circle(size: 10),
                                SizedBox(width: Spacing.xxs),
                                ShimmerPlaceholder.rect(
                                  width: 28,
                                  height: 8,
                                  borderRadius: 2,
                                ),
                              ],
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: 32,
                              height: 14,
                              borderRadius: 3,
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: double.infinity,
                              height: 4,
                              borderRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),

        // 4. Meal cards shimmer (2 cards)
        for (int m = 0; m < 2; m++) ...[
          if (m > 0) const SizedBox(height: Spacing.md),
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(
                color: color.primary.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerPlaceholder.rect(
                            width: 60,
                            height: 18,
                            borderRadius: Spacing.radiusPill,
                          ),
                          SizedBox(height: Spacing.xs),
                          ShimmerPlaceholder.rect(
                            width: 150,
                            height: 16,
                            borderRadius: Spacing.radiusXs,
                          ),
                          SizedBox(height: Spacing.sm),
                          Row(
                            children: [
                              ShimmerPlaceholder.rect(
                                width: 36,
                                height: 12,
                                borderRadius: 2,
                              ),
                              SizedBox(width: Spacing.xs),
                              ShimmerPlaceholder.rect(
                                width: 36,
                                height: 12,
                                borderRadius: 2,
                              ),
                              SizedBox(width: Spacing.xs),
                              ShimmerPlaceholder.rect(
                                width: 36,
                                height: 12,
                                borderRadius: 2,
                              ),
                              SizedBox(width: Spacing.xs),
                              ShimmerPlaceholder.rect(
                                width: 36,
                                height: 12,
                                borderRadius: 2,
                              ),
                            ],
                          ),
                          SizedBox(height: Spacing.sm),
                          ShimmerPlaceholder.rect(
                            width: 48,
                            height: 10,
                            borderRadius: 2,
                          ),
                          SizedBox(height: Spacing.xs),
                          Row(
                            children: [
                              ShimmerPlaceholder.rect(
                                width: 44,
                                height: 18,
                                borderRadius: Spacing.radiusPill,
                              ),
                              SizedBox(width: Spacing.xs),
                              ShimmerPlaceholder.rect(
                                width: 44,
                                height: 18,
                                borderRadius: Spacing.radiusPill,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      width: 90,
                      height: 90,
                      borderRadius: Spacing.radiusSm,
                    ),
                  ],
                ),
                SizedBox(height: Spacing.md),
                ShimmerPlaceholder.rect(
                  width: double.infinity,
                  height: 36,
                  borderRadius: Spacing.radiusPill,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
