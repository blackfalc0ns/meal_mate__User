import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyAllergiesLoadingSkeleton extends StatelessWidget {
  const FamilyAllergiesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: ShimmerPlaceholder.rect(
                  width: Spacing.familyAllergiesSkipWidth,
                  height: Spacing.xxl,
                  borderRadius: Spacing.xss,
                ),
              ),
              if (!isInFamilyFlow) ...[
                const SizedBox(height: Spacing.md),
                const ShimmerPlaceholder.rect(
                  height: Spacing.familyProgramStepCircleSize,
                  borderRadius: Spacing.radiusPill,
                ),
                const SizedBox(height: Spacing.lg),
              ],
              const ShimmerPlaceholder.rect(
                height: Spacing.familyProgramMemberCardHeight,
                borderRadius: Spacing.familySetupMemberCardRadius,
              ),
              const SizedBox(height: Spacing.lg),
              const ShimmerPlaceholder.rect(
                width: Spacing.familyAllergiesSkipWidth,
                height: Spacing.lg,
                borderRadius: Spacing.radiusSm,
              ),
              const SizedBox(height: Spacing.sm),
              const ShimmerPlaceholder.rect(
                width: Spacing.familyProgramNextButtonWidth,
                height: Spacing.md,
                borderRadius: Spacing.radiusSm,
              ),
              const SizedBox(height: Spacing.md),
              const ShimmerPlaceholder.rect(
                height: Spacing.addAllergyPopularHeight,
                borderRadius: Spacing.familyAllergiesCardRadius,
              ),
              const SizedBox(height: Spacing.familyAllergiesSectionGap),
              const ShimmerPlaceholder.rect(
                height: Spacing.familyAllergiesNoneHeight,
                borderRadius: Spacing.familyAllergiesNoneRadius,
              ),
              const SizedBox(height: Spacing.familyAllergiesSectionGap),
              const ShimmerPlaceholder.rect(
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
