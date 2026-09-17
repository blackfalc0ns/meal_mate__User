import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class OffersLoadingSkeleton extends StatelessWidget {
  const OffersLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.offersHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.md),
            // Hero banner skeleton
            ShimmerWidget(
              child: Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            // Page indicator skeleton
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == 0 ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            // Filter chips skeleton
            Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(Spacing.sm),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            // Section header skeleton
            const ShimmerPlaceholder(width: 130, height: 20),
            const SizedBox(height: Spacing.md),
            // Deal cards horizontal list skeleton
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.md),
                itemBuilder: (_, _) => ShimmerWidget(
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Spacing.md),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            // Coupon banner skeleton
            ShimmerWidget(
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Spacing.md),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            // Invite banner skeleton
            ShimmerWidget(
              child: Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Spacing.md),
                ),
              ),
            ),
            const SizedBox(height: Spacing.xxxl),
          ],
        ),
      ),
    );
  }
}
