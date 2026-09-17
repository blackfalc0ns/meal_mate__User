import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerBankAccountLoadingSkeleton extends StatelessWidget {
  const InfluencerBankAccountLoadingSkeleton({super.key});

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
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: Spacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholder.rect(width: 100, height: 16),
                  SizedBox(height: Spacing.xs),
                  ShimmerPlaceholder.rect(
                    height: Spacing.inputHeight,
                    borderRadius: Spacing.inputRadius,
                  ),
                ],
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
