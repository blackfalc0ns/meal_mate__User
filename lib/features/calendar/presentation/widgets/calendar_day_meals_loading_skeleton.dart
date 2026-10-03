import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class CalendarDayMealsLoadingSkeleton extends StatelessWidget {
  const CalendarDayMealsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('calendar-day-meals-loading-skeleton'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header shimmer
        Row(
          children: [
            ShimmerPlaceholder.circle(size: Spacing.iconMd),
            SizedBox(width: Spacing.xs),
            ShimmerPlaceholder.rect(
              width: 170,
              height: 20,
              borderRadius: Spacing.radiusXs,
            ),
          ],
        ),
        SizedBox(height: Spacing.md),

        // Restaurant summary card shimmer
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.calendarRestaurantSummaryHeight,
          borderRadius: Spacing.calendarRestaurantSummaryRadius,
        ),
        SizedBox(height: Spacing.xl),

        // First meal card shimmer
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 140.0,
          borderRadius: 15.0,
        ),
        SizedBox(height: Spacing.md),

        // Second meal card shimmer
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 140.0,
          borderRadius: 15.0,
        ),
        SizedBox(height: Spacing.lg),

        // Confirm button shimmer
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.buttonHeight,
          borderRadius: Spacing.buttonRadius,
        ),
      ],
    );
  }
}
