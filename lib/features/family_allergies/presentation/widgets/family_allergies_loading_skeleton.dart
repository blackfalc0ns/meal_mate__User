import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_header.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isInFamilyFlow) const FamilyAllergiesHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.familySetupHorizontalPadding,
              ),
              child: SizedBox(
                height: Spacing.familyProgramMemberCardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: Spacing.familyProgramMemberGap),
                  itemBuilder: (_, _) => Container(
                    width: Spacing.familyProgramMemberCardWidth,
                    height: Spacing.familyProgramMemberCardHeight,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                    decoration: BoxDecoration(
                      color: color.surface,
                      border: Border.all(
                        color: color.outlineVariant,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        Spacing.familyProgramMemberCardRadius,
                      ),
                    ),
                    child: const Row(
                      children: [
                        ShimmerPlaceholder.circle(
                          size: Spacing.familyProgramMemberAvatarSize,
                        ),
                        SizedBox(width: Spacing.xs),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerPlaceholder.rect(
                                width: 44,
                                height: Spacing.xs,
                                borderRadius: Spacing.xss,
                              ),
                              SizedBox(height: Spacing.xs),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShimmerPlaceholder.circle(
                                    size: Spacing.iconSm,
                                  ),
                                  SizedBox(width: Spacing.xs),
                                  ShimmerPlaceholder.rect(
                                    width: 28,
                                    height: Spacing.xss,
                                    borderRadius: Spacing.xss,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.familySetupHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ShimmerPlaceholder.rect(
                      width: 140,
                      height: Spacing.md,
                      borderRadius: Spacing.xss,
                    ),
                    const SizedBox(height: Spacing.xxs),
                    const ShimmerPlaceholder.rect(
                      width: 220,
                      height: Spacing.sm,
                      borderRadius: Spacing.xss,
                    ),
                    const SizedBox(height: Spacing.md),
                    // Section 1: Popular allergies card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: Spacing.md,
                        horizontal: Spacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius: BorderRadius.circular(
                          Spacing.familyAllergiesCardRadius,
                        ),
                        border: Border.all(color: color.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: color.shadow.withValues(alpha: 0.06),
                            blurRadius: Spacing.radiusLg,
                            offset: const Offset(Spacing.zero, Spacing.xs),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const ShimmerPlaceholder.rect(
                            width: 120,
                            height: Spacing.sm,
                            borderRadius: Spacing.xss,
                          ),
                          const SizedBox(height: Spacing.sm),
                          Container(
                            height: Spacing.familyAllergiesSearchHeight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.md,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Spacing.familyAllergiesSearchRadius,
                              ),
                              border: Border.all(color: color.outlineVariant),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: ShimmerPlaceholder.rect(
                                      width: 100,
                                      height: Spacing.xs,
                                      borderRadius: Spacing.xss,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.search_rounded,
                                  size: Spacing.iconMd,
                                  color: color.outlineVariant,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 8,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent:
                                  Spacing.familyAllergiesChoiceHeight,
                              crossAxisSpacing:
                                  Spacing.familyAllergiesChoiceColumnGap,
                              mainAxisSpacing:
                                  Spacing.familyAllergiesChoiceGap,
                            ),
                            itemBuilder: (_, _) => Container(
                              decoration: BoxDecoration(
                                color: color.surface,
                                borderRadius: BorderRadius.circular(
                                  Spacing.familyAllergiesChoiceRadius,
                                ),
                                border: Border.all(color: color.outlineVariant),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                              ),
                              alignment: Alignment.center,
                              child: const ShimmerPlaceholder.rect(
                                height: Spacing.xs,
                                borderRadius: Spacing.xss,
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ShimmerPlaceholder.rect(
                                  width: 64,
                                  height: Spacing.xs,
                                  borderRadius: Spacing.xss,
                                ),
                                const SizedBox(width: Spacing.xs),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: Spacing.iconSm,
                                  color: color.outlineVariant,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.familyAllergiesSectionGap),
                    // Section 2: Rejected ingredients card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: Spacing.md,
                        horizontal: Spacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius: BorderRadius.circular(
                          Spacing.familyAllergiesCardRadius,
                        ),
                        border: Border.all(color: color.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: color.shadow.withValues(alpha: 0.06),
                            blurRadius: Spacing.radiusLg,
                            offset: const Offset(Spacing.zero, Spacing.xs),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const ShimmerPlaceholder.rect(
                            width: 110,
                            height: Spacing.sm,
                            borderRadius: Spacing.xss,
                          ),
                          const SizedBox(height: Spacing.sm),
                          Container(
                            height: Spacing.familyAllergiesSearchHeight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.md,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Spacing.familyAllergiesSearchRadius,
                              ),
                              border: Border.all(color: color.outlineVariant),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: ShimmerPlaceholder.rect(
                                      width: 90,
                                      height: Spacing.xs,
                                      borderRadius: Spacing.xss,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.search_rounded,
                                  size: Spacing.iconMd,
                                  color: color.outlineVariant,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent:
                                  Spacing.familyAllergiesChoiceHeight,
                              crossAxisSpacing:
                                  Spacing.familyAllergiesChoiceColumnGap,
                              mainAxisSpacing:
                                  Spacing.familyAllergiesChoiceGap,
                            ),
                            itemBuilder: (_, _) => Container(
                              decoration: BoxDecoration(
                                color: color.surface,
                                borderRadius: BorderRadius.circular(
                                  Spacing.familyAllergiesChoiceRadius,
                                ),
                                border: Border.all(color: color.outlineVariant),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                              ),
                              alignment: Alignment.center,
                              child: const ShimmerPlaceholder.rect(
                                height: Spacing.xs,
                                borderRadius: Spacing.xss,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.only(
                start: Spacing.familySetupHorizontalPadding,
                end: Spacing.familySetupHorizontalPadding,
                top: Spacing.sm,
                bottom: Spacing.md,
              ),
              child: ShimmerPlaceholder.rect(
                height: Spacing.familySetupBottomButtonHeight,
                borderRadius: Spacing.radiusPill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
