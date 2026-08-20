import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyPaymentSetupLoadingSkeleton extends StatelessWidget {
  const FamilyPaymentSetupLoadingSkeleton({super.key});

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
                    separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
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
                const SizedBox(height: Spacing.md),

                // Title skeleton
                const ShimmerPlaceholder.rect(
                  width: 130,
                  height: Spacing.sm,
                  borderRadius: Spacing.radiusSm,
                ),
                const SizedBox(height: Spacing.md),

                // Summary card skeleton
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(Spacing.radiusMd),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          ShimmerPlaceholder.circle(size: 36),
                          SizedBox(width: Spacing.sm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerPlaceholder.rect(
                                width: 90,
                                height: Spacing.sm,
                                borderRadius: Spacing.radiusSm,
                              ),
                              SizedBox(height: Spacing.xs),
                              ShimmerPlaceholder.rect(
                                width: 50,
                                height: Spacing.xs,
                                borderRadius: Spacing.radiusSm,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      for (int i = 0; i < 4; i++) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: Spacing.xs),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerPlaceholder.rect(
                                width: 100,
                                height: Spacing.xs,
                                borderRadius: Spacing.radiusSm,
                              ),
                              ShimmerPlaceholder.rect(
                                width: 70,
                                height: Spacing.xs,
                                borderRadius: Spacing.radiusSm,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Price details card skeleton
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(Spacing.radiusMd),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: Spacing.xs),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerPlaceholder.rect(
                                width: 90,
                                height: Spacing.xs,
                                borderRadius: Spacing.radiusSm,
                              ),
                              ShimmerPlaceholder.rect(
                                width: 60,
                                height: Spacing.xs,
                                borderRadius: Spacing.radiusSm,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.xs),
                      const Divider(),
                      const SizedBox(height: Spacing.xs),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerPlaceholder.rect(
                            width: 80,
                            height: Spacing.sm,
                            borderRadius: Spacing.radiusSm,
                          ),
                          ShimmerPlaceholder.rect(
                            width: 80,
                            height: Spacing.sm,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Payment methods skeleton
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(Spacing.radiusMd),
                          border: Border.all(color: color.outlineVariant),
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(Spacing.radiusMd),
                          border: Border.all(color: color.outlineVariant),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),

                // Actions skeleton
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
