import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyProgramGridLoadingSkeleton extends StatelessWidget {
  const FamilyProgramGridLoadingSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GridView.builder(
      key: const ValueKey('family-program-grid-loading'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: Spacing.familyProgramCardHeight,
        crossAxisSpacing: Spacing.familyProgramGridGap,
        mainAxisSpacing: Spacing.familyProgramGridGap,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => Container(
        key: const ValueKey('family-program-loading-card'),
        height: Spacing.familyProgramCardHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(
            Spacing.familyProgramCardSelectedRadius,
          ),
          border: Border.all(color: color.outlineVariant),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholder.rect(
                    height: Spacing.sm,
                    borderRadius: Spacing.radiusSm,
                  ),
                  SizedBox(height: Spacing.sm),
                  ShimmerPlaceholder.rect(
                    height: Spacing.xss,
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
            SizedBox(width: Spacing.sm),
            ShimmerPlaceholder.circle(size: Spacing.familyProgramImageSize),
          ],
        ),
      ),
    );
  }
}
