import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilySummaryLoadingSkeleton extends StatelessWidget {
  const FamilySummaryLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return Semantics(
          label: locale.family_setup_title,
          child: Column(
            children: [
              if (!isInFamilyFlow)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.familySetupHorizontalPadding,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: 28,
                          width: 140,
                          decoration: BoxDecoration(
                            color: color.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusPill,
                            ),
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
                      const SizedBox(
                        height: Spacing.familyProgramProgressTopGap,
                      ),
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
                      const SizedBox(height: Spacing.familyProgramMemberTopGap),
                    ],
                  ),
                ),
              Expanded(
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.familySetupHorizontalPadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          if (isInFamilyFlow)
                            const SizedBox(
                              height: Spacing.familyProgramMemberTopGap,
                            ),

                          // Member strip skeleton (horizontal cards like Figma)
                          SizedBox(
                            height: 52,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: Spacing.sm),
                              itemBuilder: (_, _) => Container(
                                width: 110,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.sm,
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: color.surface,
                                  borderRadius: BorderRadius.circular(
                                    Spacing.radiusLg,
                                  ),
                                  border: Border.all(
                                    color: color.outlineVariant,
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    ShimmerPlaceholder.circle(size: 36),
                                    SizedBox(width: Spacing.xs),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ShimmerPlaceholder.rect(
                                          width: 44,
                                          height: 10,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                        SizedBox(height: Spacing.xxs),
                                        ShimmerPlaceholder.rect(
                                          width: 32,
                                          height: 8,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.md),

                          // Section title skeleton: "3. الدفع وتأكيد الاشتراك"
                          const ShimmerPlaceholder.rect(
                            width: 140,
                            height: 14,
                            borderRadius: Spacing.radiusSm,
                          ),
                          const SizedBox(height: Spacing.md),

                          // Summary card skeleton
                          Container(
                            padding: const EdgeInsets.all(Spacing.base),
                            decoration: BoxDecoration(
                              color: color.surface,
                              borderRadius: BorderRadius.circular(
                                Spacing.familySetupMemberCardRadius,
                              ),
                              border: Border.all(color: color.outlineVariant),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    ShimmerPlaceholder.circle(
                                      size: Spacing
                                          .familyProgramSummaryAvatarSize,
                                    ),
                                    SizedBox(width: Spacing.md),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShimmerPlaceholder.rect(
                                          width: 60,
                                          height: 12,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                        SizedBox(height: Spacing.xs),
                                        ShimmerPlaceholder.rect(
                                          width: 70,
                                          height: 10,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    ShimmerPlaceholder.rect(
                                      width: 75,
                                      height: 12,
                                      borderRadius: Spacing.radiusSm,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Spacing.base),
                                for (int i = 0; i < 5; i++) ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Spacing.xs,
                                    ),
                                    child: Row(
                                      children: [
                                        ShimmerPlaceholder.circle(size: 16),
                                        SizedBox(width: Spacing.xs),
                                        ShimmerPlaceholder.rect(
                                          width: 70,
                                          height: 10,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                        Spacer(),
                                        ShimmerPlaceholder.rect(
                                          width: 80,
                                          height: 10,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: Spacing.md),

                          // Participating restaurants card skeleton
                          Container(
                            padding: const EdgeInsets.all(Spacing.base),
                            decoration: BoxDecoration(
                              color: color.surface,
                              borderRadius: BorderRadius.circular(
                                Spacing.familySetupMemberCardRadius,
                              ),
                              border: Border.all(color: color.outlineVariant),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: Spacing.avatarSm,
                                      height: Spacing.avatarSm,
                                      decoration: BoxDecoration(
                                        color: color.primaryContainer,
                                        borderRadius: BorderRadius.circular(
                                          Spacing.radiusSm,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: Spacing.sm),
                                    const ShimmerPlaceholder.rect(
                                      width: 110,
                                      height: 12,
                                      borderRadius: Spacing.radiusSm,
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.sm,
                                        vertical: Spacing.xxs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.primaryContainer,
                                        borderRadius: BorderRadius.circular(
                                          Spacing.radiusPill,
                                        ),
                                      ),
                                      child: const ShimmerPlaceholder.rect(
                                        width: 44,
                                        height: 10,
                                        borderRadius: Spacing.radiusPill,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Spacing.base),
                                Row(
                                  children: [
                                    for (int i = 0; i < 4; i++) ...[
                                      if (i > 0)
                                        const SizedBox(width: Spacing.sm),
                                      Container(
                                        width: Spacing.avatarMd,
                                        height: Spacing.avatarMd,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: color.outlineVariant,
                                          ),
                                        ),
                                        child: const ShimmerPlaceholder.circle(
                                          size: Spacing.avatarMd,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: Spacing.md),
                                Row(
                                  children: [
                                    Container(
                                      width: Spacing.avatarSm,
                                      height: Spacing.avatarSm,
                                      decoration: BoxDecoration(
                                        color: color.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: Spacing.sm),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShimmerPlaceholder.rect(
                                          width: 80,
                                          height: 10,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                        SizedBox(height: Spacing.xxs),
                                        ShimmerPlaceholder.rect(
                                          width: 170,
                                          height: 9,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Spacing.lg),

                          // Schedule dates skeleton
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerPlaceholder.rect(
                                width: 100,
                                height: 12,
                                borderRadius: Spacing.radiusSm,
                              ),
                              SizedBox(height: Spacing.sm),
                              Row(
                                children: [
                                  ShimmerPlaceholder.rect(
                                    width: 80,
                                    height: 32,
                                    borderRadius: Spacing.radiusPill,
                                  ),
                                  SizedBox(width: Spacing.xs),
                                  ShimmerPlaceholder.rect(
                                    width: 80,
                                    height: 32,
                                    borderRadius: Spacing.radiusPill,
                                  ),
                                  SizedBox(width: Spacing.xs),
                                  ShimmerPlaceholder.rect(
                                    width: 80,
                                    height: 32,
                                    borderRadius: Spacing.radiusPill,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.lg),

                          // Price details card skeleton
                          Container(
                            padding: const EdgeInsets.all(Spacing.md),
                            decoration: BoxDecoration(
                              color: color.surface,
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusMd,
                              ),
                              border: Border.all(color: color.outlineVariant),
                            ),
                            child: Column(
                              children: [
                                for (int i = 0; i < 3; i++) ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Spacing.xs,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ShimmerPlaceholder.rect(
                                          width: 80,
                                          height: 10,
                                          borderRadius: Spacing.radiusSm,
                                        ),
                                        ShimmerPlaceholder.rect(
                                          width: 60,
                                          height: 10,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ShimmerPlaceholder.rect(
                                      width: 80,
                                      height: 12,
                                      borderRadius: Spacing.radiusSm,
                                    ),
                                    ShimmerPlaceholder.rect(
                                      width: 80,
                                      height: 12,
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
                                    color: color.surface,
                                    borderRadius: BorderRadius.circular(
                                      Spacing.radiusMd,
                                    ),
                                    border: Border.all(
                                      color: color.outlineVariant,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color.surface,
                                    borderRadius: BorderRadius.circular(
                                      Spacing.radiusMd,
                                    ),
                                    border: Border.all(
                                      color: color.outlineVariant,
                                    ),
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
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1500),
          color: color.surfaceContainerHighest.withValues(alpha: 0.35),
        );
  }
}

typedef FamilyPaymentSetupLoadingSkeleton = FamilySummaryLoadingSkeleton;
