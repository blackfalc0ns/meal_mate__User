import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyRestaurantsLoadingSkeleton extends StatelessWidget {
  const FamilyRestaurantsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GridView.builder(
      key: const ValueKey('family-restaurants-loading-skeleton'),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Spacing.familyRestaurantsGridGap,
        crossAxisSpacing: Spacing.familyRestaurantsGridGap,
        mainAxisExtent: Spacing.familyRestaurantsCardHeight,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          height: Spacing.familyRestaurantsCardHeight,
          padding: const EdgeInsets.all(Spacing.familyRestaurantsCardPadding),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.familyRestaurantsCardRadius,
            ),
            border: Border.all(color: color.outlineVariant),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerPlaceholder.rect(
                width: double.infinity,
                height: Spacing.familyRestaurantsMealImageHeight,
                borderRadius: Spacing.familyDayMemberSelectorRadius,
              ),
              Column(
                children: [
                  ShimmerPlaceholder.rect(
                    width: 90,
                    height: 14,
                    borderRadius: Spacing.radiusXs,
                  ),
                  SizedBox(height: Spacing.xxs),
                  ShimmerPlaceholder.rect(
                    width: 110,
                    height: 10,
                    borderRadius: Spacing.radiusXs,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerPlaceholder.rect(
                    width: 48,
                    height: Spacing.familyRestaurantsTagHeight,
                    borderRadius: Spacing.familyRestaurantsFilterRadius,
                  ),
                  SizedBox(width: Spacing.xxs),
                  ShimmerPlaceholder.rect(
                    width: 48,
                    height: Spacing.familyRestaurantsTagHeight,
                    borderRadius: Spacing.familyRestaurantsFilterRadius,
                  ),
                ],
              ),
              ShimmerPlaceholder.rect(
                width: double.infinity,
                height: Spacing.familyRestaurantsCtaHeight,
                borderRadius: Spacing.familyRestaurantsFilterRadius,
              ),
            ],
          ),
        );
      },
    );
  }
}
