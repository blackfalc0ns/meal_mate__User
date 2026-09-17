import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerDashboardLoadingSkeleton extends StatelessWidget {
  const InfluencerDashboardLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.screenH,
        top: Spacing.md,
        end: Spacing.screenH,
        bottom: Spacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerPlaceholder.rect(
            height: Spacing.influencerHeroHeight,
            borderRadius: Spacing.influencerHeroRadius,
          ),
          const SizedBox(height: Spacing.influencerMetricsTopGap),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: Spacing.influencerMetricCardHeight,
              crossAxisSpacing: Spacing.influencerMetricGridGap,
              mainAxisSpacing: Spacing.influencerMetricGridGap,
            ),
            itemBuilder: (_, _) => const ShimmerPlaceholder.rect(
              borderRadius: Spacing.influencerMetricCardRadius,
            ),
          ),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: 90,
            borderRadius: Spacing.cardRadius,
          ),
          const SizedBox(height: Spacing.lg),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder.rect(width: 120, height: 18),
              ShimmerPlaceholder.rect(width: 60, height: 16),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: Spacing.sm),
              child: ShimmerPlaceholder.rect(
                height: 64,
                borderRadius: Spacing.cardRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
