import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMemberAccessLoadingSkeleton extends StatelessWidget {
  const FamilyMemberAccessLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Spacing.screenH),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 90.0,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.md),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 140.0,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.md),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 76.0,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.md),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 220.0,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.md),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: 68.0,
          borderRadius: Spacing.radiusLg,
        ),
      ],
    );
  }
}
