import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerWithdrawLoadingSkeleton extends StatelessWidget {
  const InfluencerWithdrawLoadingSkeleton({super.key});

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
        children: const [
          ShimmerPlaceholder.rect(width: 140, height: 20),
          SizedBox(height: Spacing.xs),
          ShimmerPlaceholder.rect(width: 220, height: 14),
          SizedBox(height: Spacing.base),
          ShimmerPlaceholder.rect(
            height: 100,
            borderRadius: Spacing.cardRadius,
          ),
          SizedBox(height: Spacing.base),
          ShimmerPlaceholder.rect(
            height: Spacing.inputHeight,
            borderRadius: Spacing.inputRadius,
          ),
          SizedBox(height: Spacing.base),
          ShimmerPlaceholder.rect(
            height: 120,
            borderRadius: Spacing.cardRadius,
          ),
          SizedBox(height: Spacing.lg),
          ShimmerPlaceholder.rect(
            height: Spacing.buttonHeight,
            borderRadius: Spacing.radiusPill,
          ),
        ],
      ),
    );
  }
}
