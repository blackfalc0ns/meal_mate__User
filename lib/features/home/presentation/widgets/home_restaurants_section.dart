import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeRestaurantsSection extends StatelessWidget {
  const HomeRestaurantsSection({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    const restaurants = [
      (AssetsFake.homeBurger, 'بروتين كيتشن'),
      (AssetsFake.homeOatmeal, 'هيلثي بايت'),
      (AssetsFake.homeHotdog, 'دايت هاوس'),
      (AssetsFake.homeDonut, 'بروتين كيتشن'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.homeHorizontalPadding,
          ),
          child: Text(
            title,
            style: AppTextStyles.h4.copyWith(color: color.onSurface),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: Spacing.homeRestaurantCardHeight,
          child: ListView.separated(
            reverse: true,
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
                        style: AppTextStyles.caption.copyWith(
                          color: color.onSurface,
                        ),
                      ),
                      Text(
                        'وجبات صحية متوازنة',
                        style: AppTextStyles.overline.copyWith(
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: Spacing.xl,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('استعراض'),
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
