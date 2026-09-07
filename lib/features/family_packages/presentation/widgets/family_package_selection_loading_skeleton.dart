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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
              const ShimmerPlaceholder.rect(
                height: 115.0,
                borderRadius: Spacing.subscriptionProgramCardRadius,
              ),
              const SizedBox(height: Spacing.md),
              const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: ShimmerPlaceholder.rect(
                    height: Spacing.lg,
                    borderRadius: Spacing.radiusSm,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: Container(
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
                          children: [
                            ShimmerPlaceholder.circle(size: Spacing.iconMd),
                            SizedBox(width: Spacing.sm),
                            ShimmerPlaceholder.rect(
                              width: 50.0,
                              height: Spacing.base,
                              borderRadius: Spacing.radiusPill,
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ShimmerPlaceholder.rect(
                                  width: 90.0,
                                  height: Spacing.base,
                                  borderRadius: Spacing.radiusSm,
                                ),
                                SizedBox(height: Spacing.xs),
                                ShimmerPlaceholder.rect(
                                  width: 70.0,
                                  height: Spacing.xs,
                                  borderRadius: Spacing.radiusSm,
                                ),
                              ],
                            ),
                            SizedBox(width: Spacing.md),
                            ShimmerPlaceholder.rect(
                              width: Spacing.familyPackageCardImageSize,
                              height: Spacing.familyPackageCardImageSize,
                              borderRadius: Spacing.radiusMd,
                            ),
                          ],
                        ),
                        SizedBox(height: Spacing.md),
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.6,
                            child: ShimmerPlaceholder.rect(
                              height: Spacing.sm,
                              borderRadius: Spacing.radiusSm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: Spacing.sm),
              const ShimmerPlaceholder.rect(
                height: Spacing.buttonHeight,
                borderRadius: Spacing.radiusPill,
              ),
              const SizedBox(height: Spacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
