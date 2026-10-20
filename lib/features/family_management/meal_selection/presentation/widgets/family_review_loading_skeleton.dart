import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyReviewLoadingSkeleton extends StatelessWidget {
  const FamilyReviewLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('family-review-loading-skeleton'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 86.0,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.base),
        ShimmerPlaceholder.rect(
          width: 140.0,
          height: 18.0,
          borderRadius: Spacing.radiusXs,
        ),
        SizedBox(height: Spacing.sm),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 64.0,
          borderRadius: Spacing.cardRadius,
        ),
        SizedBox(height: Spacing.sm),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 64.0,
          borderRadius: Spacing.cardRadius,
        ),
        SizedBox(height: Spacing.sm),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 64.0,
          borderRadius: Spacing.cardRadius,
        ),
        SizedBox(height: Spacing.base),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 93.0,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.base),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 69.0,
          borderRadius: Spacing.cardRadius,
        ),
        SizedBox(height: Spacing.base),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 72.0,
          borderRadius: Spacing.cardRadius,
        ),
      ],
    );
  }
}
