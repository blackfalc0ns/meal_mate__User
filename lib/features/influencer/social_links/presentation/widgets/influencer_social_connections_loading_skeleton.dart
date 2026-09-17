import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerSocialConnectionsLoadingSkeleton extends StatelessWidget {
  const InfluencerSocialConnectionsLoadingSkeleton({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShimmerPlaceholder.rect(width: 140, height: 20),
          const SizedBox(height: Spacing.xs),
          const ShimmerPlaceholder.rect(width: 220, height: 14),
          const SizedBox(height: Spacing.lg),
          ...List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: Spacing.md),
              child: ShimmerPlaceholder.rect(
                height: 100,
                borderRadius: Spacing.cardRadius,
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          const ShimmerPlaceholder.rect(
            height: Spacing.buttonHeight,
            borderRadius: Spacing.radiusPill,
          ),
        ],
      ),
    );
  }
}
