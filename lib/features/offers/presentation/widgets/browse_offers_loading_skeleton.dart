import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class BrowseOffersLoadingSkeleton extends StatelessWidget {
  const BrowseOffersLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Spacing.md),
          // Filter tabs skeleton
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(Spacing.sm),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          // Hero banner skeleton
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
          // Section header skeleton
          const ShimmerPlaceholder(width: 140, height: 20),
          const SizedBox(height: Spacing.md),
          // 2 Card skeletons
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
            itemBuilder: (_, _) => ShimmerWidget(
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Spacing.md),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}
