import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerStatisticsLoadingSkeleton extends StatelessWidget {
  const InfluencerStatisticsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: Spacing.screenV,
        horizontal: Spacing.screenH,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              ShimmerPlaceholder.circle(
                size: Spacing.influencerStatsTitleIconSize,
              ),
              SizedBox(width: Spacing.sm),
              ShimmerPlaceholder.rect(width: 140, height: 20),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: index == 0 ? 0 : Spacing.xxs,
                  ),
                  child: const ShimmerPlaceholder.rect(
                    height: 38,
                    borderRadius: Spacing.radiusPill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          const ShimmerPlaceholder.rect(
            height: Spacing.influencerStatsSummaryHeight,
            borderRadius: Spacing.influencerStatsSummaryRadius,
          ),
          const SizedBox(height: Spacing.lg),
          const ShimmerPlaceholder.rect(
            height: Spacing.influencerStatsChartCardHeight,
            borderRadius: Spacing.influencerStatsChartCardRadius,
          ),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: 90,
            borderRadius: Spacing.cardRadius,
          ),
        ],
      ),
    );
  }
}
