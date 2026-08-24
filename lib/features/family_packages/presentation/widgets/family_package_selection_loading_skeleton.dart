import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyPackageSelectionLoadingSkeleton extends StatelessWidget {
  const FamilyPackageSelectionLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.family_setup_title,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Spacing.md),
            const ShimmerPlaceholder.rect(
              height: Spacing.xl,
              borderRadius: Spacing.radiusSm,
            ),
            const SizedBox(height: Spacing.xs),
            const ShimmerPlaceholder.rect(
              height: Spacing.base,
              borderRadius: Spacing.radiusSm,
            ),
            const SizedBox(height: Spacing.lg),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
                itemBuilder: (_, _) => Container(
                  height: 80,
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(Spacing.radiusLg),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: const Row(
                    children: [
                      ShimmerPlaceholder.circle(size: Spacing.avatarMd),
                      SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShimmerPlaceholder.rect(
                              width: Spacing.xxxl * 2,
                              height: Spacing.sm,
                              borderRadius: Spacing.radiusSm,
                            ),
                            SizedBox(height: Spacing.xs),
                            ShimmerPlaceholder.rect(
                              width: Spacing.xxxl * 3,
                              height: Spacing.xs,
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
            const SizedBox(height: Spacing.md),
            const ShimmerPlaceholder.rect(
              height: Spacing.buttonHeight,
              borderRadius: Spacing.radiusPill,
            ),
            const SizedBox(height: Spacing.base),
          ],
        ),
      ),
    );
  }
}
