import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyDayMealsLoadingSkeleton extends StatelessWidget {
  const FamilyDayMealsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('family-day-meals-loading-skeleton'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyDayMealCardHeight,
          borderRadius: Spacing.familyDayMealCardRadius,
        ),
        SizedBox(height: Spacing.familyDayMealListGap),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyDayMealCardHeight,
          borderRadius: Spacing.familyDayMealCardRadius,
        ),
        SizedBox(height: Spacing.familyDayMealListGap),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyDayMealCardHeight,
          borderRadius: Spacing.familyDayMealCardRadius,
        ),
        SizedBox(height: Spacing.familyDayReviewButtonTopGap),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyDayReviewButtonHeight,
          borderRadius: Spacing.familyDayReviewButtonRadius,
        ),
        SizedBox(height: Spacing.familyDaySelectedTopGap),
        Center(
          child: ShimmerPlaceholder.rect(
            width: 150.0,
            height: 16.0,
            borderRadius: Spacing.radiusXs,
          ),
        ),
      ],
    );
  }
}
