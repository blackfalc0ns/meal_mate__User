import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyProgramSetupLoadingSkeleton extends StatelessWidget {
  const FamilyProgramSetupLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

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
                const SizedBox(height: Spacing.familyProgramProgressTopGap),

                // Stepper skeleton
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
                          margin: EdgeInsets.symmetric(horizontal: Spacing.xs),
                        ),
                      ),
                      ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                      Expanded(
                        child: ShimmerPlaceholder.rect(
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: Spacing.xs),
                        ),
                      ),
                      ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                      Expanded(
                        child: ShimmerPlaceholder.rect(
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: Spacing.xs),
                        ),
                      ),
                      ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.familyProgramMemberTopGap),

                // Member strip skeleton
                SizedBox(
                  height: 74,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: Spacing.sm),
                    itemBuilder: (_, _) => Container(
                      width: 64,
                      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                      decoration: BoxDecoration(
                        color: color.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(Spacing.radiusMd),
                        border: Border.all(color: color.outlineVariant),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerPlaceholder.circle(size: 32),
                          SizedBox(height: Spacing.xs),
                          ShimmerPlaceholder.rect(
                            width: 44,
                            height: 8,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.familyProgramSummaryTopGap),

                // Member summary card skeleton
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(Spacing.radiusMd),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: const Row(
                    children: [
                      ShimmerPlaceholder.circle(size: 40),
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Spacing.sm,
                    mainAxisSpacing: Spacing.sm,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 4,
                  itemBuilder: (_, _) => Container(
                    padding: const EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: color.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(Spacing.radiusMd),
                      border: Border.all(color: color.outlineVariant),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ShimmerPlaceholder.rect(
                            width: double.infinity,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ),
                        SizedBox(height: Spacing.sm),
                        ShimmerPlaceholder.rect(
                          width: 80,
                          height: Spacing.sm,
                          borderRadius: Spacing.radiusSm,
                        ),
                        SizedBox(height: Spacing.xs),
                        ShimmerPlaceholder.rect(
                          width: double.infinity,
                          height: 8,
                          borderRadius: Spacing.radiusSm,
                        ),
                      ],
                    ),
                  ),
                ),
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
