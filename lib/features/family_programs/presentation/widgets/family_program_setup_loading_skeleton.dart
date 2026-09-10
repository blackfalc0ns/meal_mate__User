import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_grid_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyProgramSetupLoadingSkeleton extends StatelessWidget {
  const FamilyProgramSetupLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return Semantics(
      label: locale.family_setup_title,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.familySetupHorizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                // Header badge skeleton
                Center(
                  child: Container(
                    height: 28,
                    width: 140,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      border: Border.all(color: color.outlineVariant),
                    ),
                    child: const Center(
                      child: ShimmerPlaceholder.rect(
                        width: 90,
                        height: Spacing.sm,
                        borderRadius: Spacing.radiusSm,
                      ),
                    ),
                  ),
                ),
                if (!isInFamilyFlow) ...[
                  const SizedBox(height: Spacing.familyProgramProgressTopGap),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: color.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(Spacing.radiusLg),
                      border: Border.all(color: color.outlineVariant),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                        Expanded(
                          child: ShimmerPlaceholder.rect(
                            height: 2,
                            margin: EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                            ),
                          ),
                        ),
                        ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                        Expanded(
                          child: ShimmerPlaceholder.rect(
                            height: 2,
                            margin: EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                            ),
                          ),
                        ),
                        ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                        Expanded(
                          child: ShimmerPlaceholder.rect(
                            height: 2,
                            margin: EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                            ),
                          ),
                        ),
                        ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: Spacing.familyProgramMemberTopGap),

                // Member strip skeleton
                SizedBox(
                  height: Spacing.familyProgramMemberCardHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: Spacing.familyProgramMemberGap),
                    itemBuilder: (_, _) => Container(
                      width: Spacing.familyProgramMemberCardWidth,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                          Spacing.familyProgramMemberCardRadius,
                        ),
                        border: Border.all(color: color.outlineVariant),
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
                              children: [
                                ShimmerPlaceholder.rect(
                                  height: Spacing.sm,
                                  borderRadius: Spacing.radiusSm,
                                ),
                                SizedBox(height: Spacing.xs),
                                ShimmerPlaceholder.rect(
                                  height: Spacing.xss,
                                  borderRadius: Spacing.radiusSm,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.familyProgramSummaryTopGap),

                // Member summary card skeleton
                Container(
                  height: Spacing.familyProgramSummaryHeight,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(Spacing.radiusMd),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: const Row(
                    children: [
                      ShimmerPlaceholder.circle(
                        size: Spacing.familyProgramSummaryAvatarSize,
                      ),
                      SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerPlaceholder.rect(
                              width: 100,
                              height: Spacing.sm,
                              borderRadius: Spacing.radiusSm,
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: 70,
                              height: Spacing.xs,
                              borderRadius: Spacing.radiusSm,
                            ),
                          ],
                        ),
                      ),
                      ShimmerPlaceholder.rect(
                        width: 50,
                        height: 20,
                        borderRadius: Spacing.radiusPill,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.familyProgramTitleTopGap),

                // Title skeleton
                const Center(
                  child: ShimmerPlaceholder.rect(
                    width: 150,
                    height: Spacing.base,
                    borderRadius: Spacing.radiusSm,
                  ),
                ),
                const SizedBox(height: Spacing.familyProgramGridTopGap),

                // Programs Grid skeleton
                const FamilyProgramGridLoadingSkeleton(),
                const SizedBox(height: Spacing.lg),

                // Bottom actions skeleton
                const Row(
                  children: [
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyProgramPreviousButtonWidth,
                      height: Spacing.familySetupBottomButtonHeight,
                      borderRadius: Spacing.radiusPill,
                    ),
                    Spacer(),
                    ShimmerPlaceholder.rect(
                      width: Spacing.familyProgramNextButtonWidth,
                      height: Spacing.familySetupBottomButtonHeight,
                      borderRadius: Spacing.radiusPill,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
