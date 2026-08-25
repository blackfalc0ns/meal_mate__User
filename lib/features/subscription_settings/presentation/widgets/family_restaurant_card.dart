import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_logo.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_tag.dart';

class FamilyRestaurantCard extends StatelessWidget {
  const FamilyRestaurantCard({super.key, required this.restaurant});

  final FamilyRestaurantCardData restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    locale.localeName;

    return Container(
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
            color: color.shadow.withValues(alpha: 0.08),
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
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: ClipRRect(
                    borderRadius: BorderRadiusDirectional.horizontal(
                      start: Radius.circular(Spacing.avatarLg),
                      end: Radius.circular(Spacing.md),
                    ),
                    child: Image.asset(
                      restaurant.imageAsset,
                      width: Spacing.familyRestaurantsMealImageWidth,
                      height: Spacing.familyRestaurantsMealImageHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          width: Spacing.familyRestaurantsMealImageWidth,
                          height: Spacing.familyRestaurantsMealImageHeight,
                        );
                      },
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.xs,
                  end: Spacing.xs,
                  child: Container(
                    height: Spacing.familyRestaurantsRatingHeight,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.circular(
                        Spacing.familyRestaurantsFilterRadius,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          restaurant.rating,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onPrimary,
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Icon(
                          Icons.star_rounded,
                          color: color.onPrimary,
                          size: Spacing.iconSm,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
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
              Text(
                restaurant.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int index = 0; index < restaurant.tags.length; index++) ...[
                if (index > 0) const SizedBox(width: Spacing.xs),
                Flexible(
                  child: FamilyRestaurantTag(tag: restaurant.tags[index]),
                ),
              ],
            ],
          ),
          SizedBox(
            height: Spacing.familyRestaurantsCtaHeight,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.primary,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: Center(
                child: Text(
                  restaurant.buttonLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size7,
                    color: color.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
