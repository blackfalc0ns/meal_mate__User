import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerWalletLoadingSkeleton extends StatelessWidget {
  const InfluencerWalletLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.screenV,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShimmerPlaceholder.rect(width: 120, height: 20),
          const SizedBox(height: Spacing.xs),
          const ShimmerPlaceholder.rect(width: 200, height: 14),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: 140,
            borderRadius: Spacing.cardRadius,
          ),
          const SizedBox(height: Spacing.influencerWalletActionsTopGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: ShimmerPlaceholder.rect(
                  height: 48,
                  borderRadius: Spacing.radiusPill,
                ),
              ),
              SizedBox(width: Spacing.influencerWalletActionsGap),
              Expanded(
                child: ShimmerPlaceholder.rect(
                  height: 48,
                  borderRadius: Spacing.radiusPill,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: 100,
            borderRadius: Spacing.cardRadius,
          ),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: 160,
            borderRadius: Spacing.cardRadius,
          ),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: Spacing.buttonHeight,
            borderRadius: Spacing.radiusPill,
          ),
        ],
      ),
    );
  }
}
