import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyBrowseRestaurantsLoadingSkeleton extends StatelessWidget {
  const FamilyBrowseRestaurantsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (_, _) => Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(color: color.outlineVariant),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShimmerPlaceholder.rect(
                width: double.infinity,
                borderRadius: Spacing.radiusSm,
              ),
            ),
            SizedBox(height: Spacing.sm),
            ShimmerPlaceholder.rect(
              width: 90,
              height: Spacing.sm,
              borderRadius: Spacing.radiusSm,
            ),
            SizedBox(height: Spacing.xs),
            ShimmerPlaceholder.rect(
              width: 60,
              height: Spacing.xs,
              borderRadius: Spacing.radiusSm,
            ),
          ],
        ),
      ),
    );
  }
}
