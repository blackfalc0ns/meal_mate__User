import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberContentLoadingSkeleton extends StatelessWidget {
  const FamilyMemberContentLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.family_setup_title,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShimmerPlaceholder.rect(
            height: Spacing.familyProgramSummaryHeight,
            borderRadius: Spacing.radiusMd,
          ),
          SizedBox(height: Spacing.md),
          ShimmerPlaceholder.rect(
            height: Spacing.familyProgramCardHeight,
            borderRadius: Spacing.radiusMd,
          ),
          SizedBox(height: Spacing.md),
          ShimmerPlaceholder.rect(
            height: Spacing.monthlyPlanDurationHeight,
            borderRadius: Spacing.radiusMd,
          ),
        ],
      ),
    );
  }
}
