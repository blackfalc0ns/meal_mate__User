import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilySubscriptionSetupLoadingSkeleton extends StatelessWidget {
  const FamilySubscriptionSetupLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.family_setup_title,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Spacing.md),

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
            const SizedBox(height: Spacing.lg),

            // Package Banner skeleton
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: color.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(color: color.outlineVariant),
              ),
              child: const Row(
                children: [
                  ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                  SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerPlaceholder.rect(
                          width: Spacing.xxxl * 2,
                          height: Spacing.sm,
                          borderRadius: Spacing.radiusSm,
                        ),
                        SizedBox(height: Spacing.xs),
                        ShimmerPlaceholder.rect(
                          width: Spacing.xxxl * 1.5,
                          height: Spacing.xs,
                          borderRadius: Spacing.radiusSm,
                        ),
                      ],
                    ),
                  ),
                  ShimmerPlaceholder.rect(
                    width: Spacing.xxxl,
                    height: Spacing.md,
                    borderRadius: Spacing.radiusSm,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),

            // Family Name field skeleton
            const ShimmerPlaceholder.rect(
              width: Spacing.xxxl * 2,
              height: Spacing.sm,
              borderRadius: Spacing.radiusSm,
            ),
            const SizedBox(height: Spacing.xs),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              decoration: BoxDecoration(
                color: color.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(color: color.outlineVariant),
              ),
              child: const Row(
                children: [
                  ShimmerPlaceholder.circle(size: Spacing.iconSm),
                  SizedBox(width: Spacing.sm),
                  ShimmerPlaceholder.rect(
                    width: Spacing.xxxl * 2.5,
                    height: Spacing.xs,
                    borderRadius: Spacing.radiusSm,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // Members count header skeleton
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerPlaceholder.rect(
                  width: Spacing.xxxl * 2,
                  height: Spacing.sm,
                  borderRadius: Spacing.radiusSm,
                ),
                ShimmerPlaceholder.rect(
                  width: Spacing.xxxl,
                  height: Spacing.md,
                  borderRadius: Spacing.radiusPill,
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),

            // Member tiles skeletons
            for (int i = 0; i < 2; i++) ...[
              Container(
                margin: const EdgeInsets.only(bottom: Spacing.sm),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: color.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: const Row(
                  children: [
                    ShimmerPlaceholder.circle(size: Spacing.avatarMd),
                    SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerPlaceholder.rect(
                            width: Spacing.xxxl * 2,
                            height: Spacing.sm,
                            borderRadius: Spacing.radiusSm,
                          ),
                          SizedBox(height: Spacing.xs),
                          ShimmerPlaceholder.rect(
                            width: Spacing.xxxl * 1.5,
                            height: Spacing.xs,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ],
                      ),
                    ),
                    ShimmerPlaceholder.circle(size: Spacing.iconSm),
                  ],
                ),
              ),
            ],

            // Add member button skeleton
            const SizedBox(height: Spacing.xs),
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(color: color.outlineVariant),
              ),
              child: const Center(
                child: ShimmerPlaceholder.rect(
                  width: Spacing.xxxl * 2,
                  height: Spacing.sm,
                  borderRadius: Spacing.radiusSm,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // Next button skeleton
            const ShimmerPlaceholder.rect(
              height: Spacing.buttonHeight,
              borderRadius: Spacing.radiusPill,
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }
}
