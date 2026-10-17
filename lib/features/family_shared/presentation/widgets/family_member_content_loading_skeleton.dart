import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberContentLoadingSkeleton extends StatelessWidget {
  const FamilyMemberContentLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
          label: locale.family_setup_title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section title skeleton
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
                          size: Spacing.familyProgramSummaryAvatarSize,
                        ),
                        SizedBox(width: Spacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: EdgeInsets.symmetric(vertical: Spacing.xs),
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
                          if (i > 0) const SizedBox(width: Spacing.sm),
                          Container(
                            width: Spacing.avatarMd,
                            height: Spacing.avatarMd,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: color.outlineVariant),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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

              // Price details card skeleton
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: color.surface,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
