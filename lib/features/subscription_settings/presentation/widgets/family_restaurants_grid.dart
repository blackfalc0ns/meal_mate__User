import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_card.dart';

class FamilyRestaurantsGrid extends StatelessWidget {
  const FamilyRestaurantsGrid({super.key, required this.restaurants});

  final List<FamilyRestaurantCardData> restaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;

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
        return FamilyRestaurantCard(restaurant: restaurants[index]);
      },
    );
  }
}
