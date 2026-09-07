import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyAllergiesLoadingSkeleton extends StatelessWidget {
  const FamilyAllergiesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.family_allergies_title,
      child: ColoredBox(
        color: color.surface,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familySetupHorizontalPadding,
            vertical: Spacing.md,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ShimmerPlaceholder.rect(
                  width: Spacing.familyAllergiesSkipWidth,
                  height: Spacing.xxl,
                  borderRadius: Spacing.xss,
                ),
              ),
              SizedBox(height: Spacing.md),
              ShimmerPlaceholder.rect(
                height: Spacing.familyProgramStepCircleSize,
                borderRadius: Spacing.radiusPill,
              ),
              SizedBox(height: Spacing.lg),
              ShimmerPlaceholder.rect(
                height: Spacing.familyProgramMemberCardHeight,
                borderRadius: Spacing.familySetupMemberCardRadius,
              ),
              SizedBox(height: Spacing.lg),
              ShimmerPlaceholder.rect(
                width: Spacing.familyAllergiesSkipWidth,
                height: Spacing.lg,
                borderRadius: Spacing.radiusSm,
              ),
              SizedBox(height: Spacing.sm),
              ShimmerPlaceholder.rect(
                width: Spacing.familyProgramNextButtonWidth,
                height: Spacing.md,
                borderRadius: Spacing.radiusSm,
              ),
              SizedBox(height: Spacing.md),
              ShimmerPlaceholder.rect(
                height: Spacing.addAllergyPopularHeight,
                borderRadius: Spacing.familyAllergiesCardRadius,
              ),
              SizedBox(height: Spacing.familyAllergiesSectionGap),
              ShimmerPlaceholder.rect(
                height: Spacing.familyAllergiesNoneHeight,
                borderRadius: Spacing.familyAllergiesNoneRadius,
              ),
              SizedBox(height: Spacing.familyAllergiesSectionGap),
              ShimmerPlaceholder.rect(
                height: Spacing.addAllergySummaryHeight,
                borderRadius: Spacing.familyAllergiesCardRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
