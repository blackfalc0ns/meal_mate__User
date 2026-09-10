import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberCalendarLoadingSkeleton extends StatelessWidget {
  const FamilyMemberCalendarLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('family-calendar-loading-skeleton'),
      children: [
        SizedBox(
          height: Spacing.familyMemberCalendarStripPanelHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ShimmerPlaceholder.circle(size: Spacing.avatarLg),
              SizedBox(width: Spacing.xl),
              ShimmerPlaceholder.circle(size: Spacing.avatarLg),
            ],
          ),
        ),
        const SizedBox(height: Spacing.familyMemberCalendarMonthTopGap),
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMemberCalendarStripPanelHeight,
          borderRadius: Spacing.familyMemberCalendarCardRadius,
        ),
        const SizedBox(height: Spacing.familyMemberCalendarSelectedMealsTopGap),
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMemberCalendarSelectedMealsHeight,
          borderRadius: Spacing.familyMemberCalendarSelectedMealsRadius,
        ),
        const SizedBox(height: Spacing.familyMemberCalendarDaySummaryTopGap),
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMemberCalendarDaySummaryHeight,
          borderRadius: Spacing.familyMemberCalendarSelectedMealsRadius,
        ),
        const SizedBox(height: Spacing.familyMemberCalendarButtonTopGap),
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMemberCalendarButtonHeight,
          borderRadius: Spacing.familyMemberCalendarButtonRadius,
        ),
      ],
    );
  }
}
