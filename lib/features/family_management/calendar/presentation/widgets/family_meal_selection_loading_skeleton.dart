import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyMealSelectionLoadingSkeleton extends StatelessWidget {
  const FamilyMealSelectionLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('family-meal-selection-loading-skeleton'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMealSelectionCardHeight,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.md),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMealSelectionCardHeight,
          borderRadius: Spacing.radiusLg,
        ),
        SizedBox(height: Spacing.md),
        ShimmerPlaceholder.rect(
          width: double.infinity,
          height: Spacing.familyMealSelectionCardHeight,
          borderRadius: Spacing.radiusLg,
        ),
      ],
    );
  }
}
