import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_logo.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_tag.dart';

class FamilyRestaurantCard extends StatelessWidget {
  const FamilyRestaurantCard({super.key, required this.restaurant});

  final FamilyRestaurantCardData restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.familyMealSelection);
      },
      borderRadius: BorderRadius.circular(
        Spacing.familyRestaurantsCardRadius,
      ),
      child: Container(
        height: Spacing.familyRestaurantsCardHeight,
        padding: const EdgeInsets.all(Spacing.familyRestaurantsCardPadding),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(
            Spacing.familyRestaurantsCardRadius,
          ),
          border: Border.all(color: color.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.06),
              offset: const Offset(0, Spacing.xs),
              blurRadius: Spacing.xs,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: Spacing.familyRestaurantsMealImageHeight,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Spacing.familyDayMemberSelectorRadius,
                    ),
                    child: Image.asset(
                      restaurant.imageAsset,
                      width: double.infinity,
                      height: Spacing.familyRestaurantsMealImageHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          width: double.infinity,
                          height: Spacing.familyRestaurantsMealImageHeight,
                        );
                      },
                    ),
                  ),
                  PositionedDirectional(
                    top: Spacing.xs,
                    start: Spacing.xs,
                    child: Container(
                      height: Spacing.familyRestaurantsRatingHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.primary,
                        borderRadius: BorderRadius.circular(
                          Spacing.radiusPill,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: color.onPrimary,
                            size: Spacing.iconXs,
                          ),
                          const SizedBox(width: Spacing.xxs),
                          Text(
                            restaurant.rating,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: Spacing.xs,
                    end: Spacing.xs,
                    child: FamilyRestaurantLogo(restaurant: restaurant),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  restaurant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  restaurant.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int index = 0; index < restaurant.tags.length; index++) ...[
                  if (index > 0) const SizedBox(width: Spacing.xxs),
                  Flexible(
                    child: FamilyRestaurantTag(tag: restaurant.tags[index]),
                  ),
                ],
              ],
            ),
            AppButton(
              text: restaurant.buttonLabel,
              height: Spacing.familyRestaurantsCtaHeight,
              color: color.primary,
              borderRadius: Spacing.familyRestaurantsFilterRadius,
              fontSize: FontSize.size11,
              onPressed: () {
                context.pushNamed(AppRoutes.familyMealSelection);
              },
            ),
          ],
        ),
      ),
    );
  }
}
