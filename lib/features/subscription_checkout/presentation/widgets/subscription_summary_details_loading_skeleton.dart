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

    Widget skeletonCard({required double height, double? width}) {
      return ShimmerWidget(
        baseColor: color.surfaceContainerHighest,
        highlightColor: color.surface,
        child: Container(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: color.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
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
            skeletonCard(height: 280),
            const SizedBox(height: Spacing.md),
            skeletonCard(height: 110),
            const SizedBox(height: Spacing.md),
            skeletonCard(height: 60),
            const SizedBox(height: Spacing.md),
            skeletonCard(height: 60),
            const SizedBox(height: Spacing.md),
            skeletonCard(height: 60),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(child: skeletonCard(height: 64)),
                const SizedBox(width: Spacing.xss),
                Expanded(child: skeletonCard(height: 64)),
                const SizedBox(width: Spacing.xss),
                Expanded(child: skeletonCard(height: 64)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
