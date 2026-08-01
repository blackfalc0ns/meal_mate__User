import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class HomeRestaurantsSection extends StatelessWidget {
  const HomeRestaurantsSection({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final restaurants = [
      (AssetsFake.homeBurger, locale.home_restaurant_protein_kitchen),
      (AssetsFake.homeOatmeal, locale.home_restaurant_healthy_bite),
      (AssetsFake.homeHotdog, locale.home_restaurant_diet_house),
      (AssetsFake.homeDonut, locale.home_restaurant_protein_kitchen),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.homeHorizontalPadding,
          ),
          child: Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size20,
              color: color.onSurface,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: Spacing.homeRestaurantCardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.homeHorizontalPadding,
            ),
            itemCount: restaurants.length,
            separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
            itemBuilder: (_, index) {
              final restaurant = restaurants[index];
              return SizedBox(
                width: Spacing.homeRestaurantCardWidth,
                child: Card(
                  child: Column(
                    children: [
                      Image.asset(
                        restaurant.$1,
                        height: Spacing.xxxl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        restaurant.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurface,
                        ),
                      ),
                      Text(
                        locale.home_restaurant_balanced_meals,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size7,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: Spacing.xl,
                        child: AppButton(
                          fontSize: FontSize.size11,

                          onPressed: () {},
                          text: locale.home_restaurant_browse,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
