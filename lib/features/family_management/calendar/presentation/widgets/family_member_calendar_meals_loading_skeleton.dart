import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberCalendarMealsLoadingSkeleton extends StatelessWidget {
  const FamilyMemberCalendarMealsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('family-calendar-meals-loading-skeleton'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 170.0,
          borderRadius: Spacing.familyMemberCalendarSelectedMealsRadius,
        ),
        SizedBox(height: Spacing.familyMemberCalendarDaySummaryTopGap),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMemberCalendarDaySummaryHeight,
          borderRadius: Spacing.familyMemberCalendarCardRadius,
        ),
        SizedBox(height: Spacing.familyMemberCalendarButtonTopGap),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 48.0,
          borderRadius: Spacing.familyDayReviewButtonRadius,
        ),
      ],
    );
  }
}
