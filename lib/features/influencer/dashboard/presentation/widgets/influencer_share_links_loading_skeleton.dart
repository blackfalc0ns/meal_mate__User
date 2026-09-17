import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerShareLinksLoadingSkeleton extends StatelessWidget {
  const InfluencerShareLinksLoadingSkeleton({super.key});

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
          const ShimmerPlaceholder.rect(
            height: 120,
            borderRadius: Spacing.cardRadius,
          ),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: 130,
            borderRadius: Spacing.cardRadius,
          ),
          const SizedBox(height: Spacing.base),
          const ShimmerPlaceholder.rect(
            height: 110,
            borderRadius: Spacing.cardRadius,
          ),
          const SizedBox(height: Spacing.base),
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : Spacing.xs,
                    right: index == 2 ? 0 : Spacing.xs,
                  ),
                  child: const ShimmerPlaceholder.rect(
                    height: 80,
                    borderRadius: Spacing.cardRadius,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.base),
          ...List.generate(
            2,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: Spacing.sm),
              child: ShimmerPlaceholder.rect(
                height: 56,
                borderRadius: Spacing.cardRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
