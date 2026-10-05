import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

/// Loading skeleton for address coverage preview.
/// Supports both [restaurantsOnly] mode (single placeholder card) and
/// full panel skeleton for the initial coverage preview loading state.
class AddressCoverageLoadingSkeleton extends StatelessWidget {
  const AddressCoverageLoadingSkeleton({
    super.key,
    this.restaurantsOnly = false,
  });

  final bool restaurantsOnly;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    if (restaurantsOnly) {
      return _buildRestaurantCardSkeleton(color);
    }

    return _buildPanelSkeleton(color);
  }

  Widget _buildRestaurantCardSkeleton(ColorScheme color) {
    return ShimmerWidget(
      baseColor: color.surfaceContainerHighest,
      highlightColor: color.surfaceContainerLowest,
      child: Container(
        width: 104,
        height: 115,
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: color.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(Spacing.radiusSm),
          border: Border.all(
            color: color.outlineVariant,
            width: Spacing.hairline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Container(
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelSkeleton(ColorScheme color) {
    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      padding: const EdgeInsets.only(
        left: Spacing.xl,
        right: Spacing.xl,
        top: Spacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ShimmerWidget(
                baseColor: color.surfaceContainerHighest,
                highlightColor: color.surfaceContainerLowest,
                child: Container(
                  width: 40,
                  height: Spacing.xs,
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Spacing.xs),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              children: [
                ShimmerWidget(
                  baseColor: color.surfaceContainerHighest,
                  highlightColor: color.surfaceContainerLowest,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                        baseColor: color.surfaceContainerHighest,
                        highlightColor: color.surfaceContainerLowest,
                        child: Container(
                          width: 140,
                          height: 16,
                          decoration: BoxDecoration(
                            color: color.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(Spacing.xs),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      ShimmerWidget(
                        baseColor: color.surfaceContainerHighest,
                        highlightColor: color.surfaceContainerLowest,
                        child: Container(
                          width: 200,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(Spacing.xs),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            ShimmerWidget(
              baseColor: color.surfaceContainerHighest,
              highlightColor: color.surfaceContainerLowest,
              child: Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(Spacing.xs),
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SizedBox(
              height: 115,
              child: Row(
                children: [
                  for (int i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: Spacing.sm),
                    const AddressCoverageLoadingSkeleton(restaurantsOnly: true),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),
            ShimmerWidget(
              baseColor: color.surfaceContainerHighest,
              highlightColor: color.surfaceContainerLowest,
              child: Container(
                height: Spacing.buttonSmallHeight,
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
