import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class OfferDetailsLoadingSkeleton extends StatelessWidget {
  const OfferDetailsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.offerDetailsHorizontalPadding,
        vertical: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Card Skeleton
          ShimmerWidget(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.md),
              ),
            ),
          ),
          const SizedBox(height: Spacing.base),
          // Countdown Timer Skeleton
          ShimmerWidget(
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.sm),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          // Info Card Skeleton
          ShimmerWidget(
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.md),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          // Benefits Section Skeleton
          ShimmerWidget(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.md),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xl),
          // Bottom CTA Skeleton
          ShimmerWidget(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Spacing.offerDetailsBottomButtonRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
