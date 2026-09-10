import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/models/family_restaurants_view_data.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/staggered_slide_item.dart';

class FamilyRestaurantsGrid extends StatelessWidget {
  const FamilyRestaurantsGrid({
    super.key,
    required this.restaurants,
    this.onRestaurantSelected,
  });

  final List<FamilyRestaurantCardData> restaurants;
  final ValueChanged<FamilyRestaurantCardData>? onRestaurantSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Spacing.familyRestaurantsGridGap,
        crossAxisSpacing: Spacing.familyRestaurantsGridGap,
        mainAxisExtent: Spacing.familyRestaurantsCardHeight,
      ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return StaggeredSlideItem(
          key: ValueKey('restaurant_${restaurant.id}_$index'),
          index: index,
          child: FamilyRestaurantCard(
            restaurant: restaurant,
            onSelect: onRestaurantSelected != null
                ? () => onRestaurantSelected!(restaurant)
                : null,
          ),
        );
      },
    );
  }
}
