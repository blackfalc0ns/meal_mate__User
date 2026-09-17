import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class PromoCheckoutLoadingSkeleton extends StatelessWidget {
  const PromoCheckoutLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        children: [
          // Checkmark header skeleton
          ShimmerWidget(
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.md),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          // Order summary card skeleton
          ShimmerWidget(
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.md),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          // Security badges skeleton
          ShimmerWidget(
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.sm),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xl),
          // CTA button skeleton
          ShimmerWidget(
            child: Container(
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
