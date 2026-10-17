import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyAddressLocationLoadingSkeleton extends StatelessWidget {
  const FamilyAddressLocationLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Stack(
      children: [
        const Positioned.fill(
          child: ShimmerPlaceholder.rect(
            key: ValueKey('family-addresses-map-skeleton'),
          ),
        ),
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerPlaceholder.rect(
                width: Spacing.xxxl * 2,
                height: Spacing.xxl,
                borderRadius: Spacing.radiusSm,
              ),
              SizedBox(height: Spacing.xs),
              ShimmerPlaceholder.circle(size: Spacing.iconXl),
            ],
          ),
        ),
        Positioned(
          left: Spacing.zero,
          right: Spacing.zero,
          bottom: Spacing.zero,
          child: Container(
            key: const ValueKey('family-addresses-sheet-skeleton'),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Spacing.bottomSheetRadius),
              ),
            ),
            child: const SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ShimmerPlaceholder.circle(size: Spacing.iconXl),
                      SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerPlaceholder.rect(
                              height: Spacing.base,
                              borderRadius: Spacing.radiusSm,
                            ),
                            SizedBox(height: Spacing.sm),
                            ShimmerPlaceholder.rect(
                              height: Spacing.sm,
                              borderRadius: Spacing.radiusSm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Spacing.sm),
                  ShimmerPlaceholder.rect(
                    height: Spacing.inputHeight,
                    borderRadius: Spacing.radiusMd,
                  ),
                  SizedBox(height: Spacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: ShimmerPlaceholder.rect(
                          height: Spacing.avatarLg,
                          borderRadius: Spacing.radiusMd,
                        ),
                      ),
                      SizedBox(width: Spacing.sm),
                      Expanded(
                        child: ShimmerPlaceholder.rect(
                          height: Spacing.avatarLg,
                          borderRadius: Spacing.radiusMd,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Spacing.sm),
                  ShimmerPlaceholder.rect(
                    height: Spacing.buttonHeight,
                    borderRadius: Spacing.radiusPill,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
