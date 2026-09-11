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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Spacing.sm),
            const Center(
              child: FractionallySizedBox(
                widthFactor: 0.45,
                child: ShimmerPlaceholder.rect(
                  height: Spacing.xxl,
                  borderRadius: Spacing.radiusSm,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            const Center(
              child: FractionallySizedBox(
                widthFactor: 0.65,
                child: ShimmerPlaceholder.rect(
                  height: Spacing.base,
                  borderRadius: Spacing.radiusSm,
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Container(
              padding: const EdgeInsetsDirectional.only(
                start: Spacing.md,
                top: Spacing.sm,
                bottom: Spacing.sm,
                end: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(
                  Spacing.subscriptionProgramCardRadius,
                ),
                border: Border.all(color: color.outlineVariant),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: ShimmerPlaceholder.rect(
                            height: Spacing.xl,
                            borderRadius: Spacing.radiusPill,
                          ),
                        ),
                        SizedBox(height: Spacing.xs),
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: ShimmerPlaceholder.rect(
                            height: Spacing.base,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ),
                        SizedBox(height: Spacing.xs),
                        FractionallySizedBox(
                          widthFactor: 0.75,
                          child: ShimmerPlaceholder.rect(
                            height: Spacing.sm,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Spacing.sm),
                  ShimmerPlaceholder.rect(
                    width: Spacing.familyPackageCardImageSize * 2,
                    height: Spacing.familyPackageCardImageSize * 2,
                    borderRadius: Spacing.radiusMd,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            const Row(
              children: [
                ShimmerPlaceholder.circle(size: Spacing.avatarSm),
                SizedBox(width: Spacing.sm),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: 0.45,
                      child: ShimmerPlaceholder.rect(
                        height: Spacing.lg,
                        borderRadius: Spacing.radiusSm,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(
                  Spacing.subscriptionProgramCardRadius,
                ),
                border: Border.all(color: color.outlineVariant),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ShimmerPlaceholder.rect(
                        width: Spacing.familyPackageCardImageSize,
                        height: Spacing.familyPackageCardImageSize,
                        borderRadius: Spacing.radiusMd,
                      ),
                      SizedBox(width: Spacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerPlaceholder.rect(
                            width: Spacing.familyPackageCardImageSize * 2,
                            height: Spacing.base,
                            borderRadius: Spacing.radiusSm,
                          ),
                          SizedBox(height: Spacing.xs),
                          ShimmerPlaceholder.rect(
                            width: Spacing.familyPackageCardImageSize * 1.5,
                            height: Spacing.sm,
                            borderRadius: Spacing.radiusSm,
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShimmerPlaceholder.circle(size: Spacing.iconMd),
                          SizedBox(height: Spacing.xs),
                          ShimmerPlaceholder.rect(
                            width: Spacing.familyPackageCardImageSize * 1.5,
                            height: Spacing.base,
                            borderRadius: Spacing.radiusPill,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Spacing.md),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: ShimmerPlaceholder.rect(
                      height: Spacing.sm,
                      borderRadius: Spacing.radiusSm,
                    ),
                  ),
                ],
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
