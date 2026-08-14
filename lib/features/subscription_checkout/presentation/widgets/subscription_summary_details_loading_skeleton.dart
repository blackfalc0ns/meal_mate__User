import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionSummaryDetailsLoadingSkeleton extends StatelessWidget {
  const SubscriptionSummaryDetailsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    Widget skeletonBox({required double height, double? width}) {
      return ShimmerWidget(
        baseColor: color.surfaceContainerHighest,
        highlightColor: color.surface,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionSummaryCardRadius,
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: locale.subscription_summary_title,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Spacing.subscriptionSummaryDetailsWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: skeletonBox(
                width: Spacing.subscriptionSummaryTitleWidth,
                height: Spacing.subscriptionSummaryTitleHeight,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              children: [
                Expanded(
                  child: skeletonBox(
                    height: Spacing.subscriptionSummaryTopTileHeight,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: skeletonBox(
                    height: Spacing.subscriptionSummaryTopTileHeight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            skeletonBox(height: Spacing.subscriptionSummaryTopTileHeight),
            const SizedBox(height: Spacing.md),
            skeletonBox(height: Spacing.subscriptionSummaryIncludesHeight),
            const SizedBox(height: Spacing.md),
            skeletonBox(height: Spacing.subscriptionSummaryPriceHeight),
          ],
        ),
      ),
    );
  }
}
