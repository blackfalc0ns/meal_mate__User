import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberCalendarLoadingSkeleton extends StatelessWidget {
  const FamilyMemberCalendarLoadingSkeleton({
    super.key,
    this.includeMemberSelector = true,
  });

  final bool includeMemberSelector;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('family-calendar-loading-skeleton'),
      children: [
        if (includeMemberSelector) ...[
          SizedBox(
            height: Spacing.familyDayMemberSelectorHeight,
            child: Row(
              children: const [
                ShimmerPlaceholder.rect(
                  width: Spacing.familyDayMemberSelectorWidth,
                  height: Spacing.familyDayMemberSelectorHeight,
                  borderRadius: Spacing.familyDayMemberSelectorRadius,
                ),
                SizedBox(width: Spacing.familyDayMemberSelectorGap),
                ShimmerPlaceholder.rect(
                  width: Spacing.familyDayMemberSelectorWidth,
                  height: Spacing.familyDayMemberSelectorHeight,
                  borderRadius: Spacing.familyDayMemberSelectorRadius,
                ),
                SizedBox(width: Spacing.familyDayMemberSelectorGap),
                ShimmerPlaceholder.rect(
                  width: Spacing.familyDayMemberSelectorWidth,
                  height: Spacing.familyDayMemberSelectorHeight,
                  borderRadius: Spacing.familyDayMemberSelectorRadius,
                ),
                SizedBox(width: Spacing.familyDayMemberSelectorGap),
                ShimmerPlaceholder.rect(
                  width: Spacing.familyDayMemberSelectorWidth,
                  height: Spacing.familyDayMemberSelectorHeight,
                  borderRadius: Spacing.familyDayMemberSelectorRadius,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.familyMemberCalendarMonthTopGap),
        ],
        // Month header row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerPlaceholder.circle(
                size: Spacing.familyMemberCalendarMonthHeight,
              ),
              ShimmerPlaceholder.rect(
                width: 140,
                height: 28,
                borderRadius: Spacing.radiusSm,
              ),
              ShimmerPlaceholder.circle(
                size: Spacing.familyMemberCalendarMonthHeight,
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        // Calendar card
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 260.0,
          borderRadius: Spacing.familyMemberCalendarCardRadius,
        ),
        const SizedBox(height: Spacing.familyMemberCalendarSelectedMealsTopGap),
        // Selected meals card
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 170.0,
          borderRadius: Spacing.familyMemberCalendarSelectedMealsRadius,
        ),
        const SizedBox(height: Spacing.familyMemberCalendarDaySummaryTopGap),
        // Day summary card
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMemberCalendarDaySummaryHeight,
          borderRadius: Spacing.familyMemberCalendarCardRadius,
        ),
        const SizedBox(height: Spacing.familyMemberCalendarButtonTopGap),
        // Action button
        const ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 48.0,
          borderRadius: Spacing.familyDayReviewButtonRadius,
        ),
      ],
    );
  }
}
