import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class RedeemPackageLoadingSkeleton extends StatelessWidget {
  const RedeemPackageLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mini Hero Skeleton
          ShimmerWidget(
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.md),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          // Specs box skeleton
          ShimmerWidget(
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Spacing.sm),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          const ShimmerPlaceholder(width: 150, height: 20),
          const SizedBox(height: Spacing.md),
          // 3 package tier card skeletons
          ...List.generate(
            3,
            (_) => ShimmerWidget(
              child: Container(
                margin: const EdgeInsets.only(bottom: Spacing.md),
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Spacing.md),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
