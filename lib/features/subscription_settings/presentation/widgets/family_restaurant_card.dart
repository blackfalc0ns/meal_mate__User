import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/models/family_restaurants_view_data.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_logo.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurant_tag.dart';

class FamilyRestaurantCard extends StatelessWidget {
  const FamilyRestaurantCard({
    super.key,
    required this.restaurant,
    this.onSelect,
  });

  final FamilyRestaurantCardData restaurant;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap:
          onSelect ??
          () {
            context.pushNamed(AppRoutes.familyMealSelection);
          },
      borderRadius: BorderRadius.circular(Spacing.familyRestaurantsCardRadius),
      child: Container(
        height: Spacing.familyRestaurantsCardHeight,
        padding: const EdgeInsets.all(Spacing.familyRestaurantsCardPadding),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(
            Spacing.familyRestaurantsCardRadius,
          ),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.04),
              offset: const Offset(0, Spacing.xxs),
              blurRadius: Spacing.xs,
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: Spacing.familyRestaurantsMealImageHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Spacing.familyRestaurantsCardRadius,
                      ),
                      child:
                          restaurant.imageUrl != null &&
                              restaurant.imageUrl!.isNotEmpty
                          ? (restaurant.imageUrl!.startsWith('assets/')
                                ? Image.asset(
                                    restaurant.imageUrl!,
                                    width: double.infinity,
                                    height: Spacing
                                        .familyRestaurantsMealImageHeight,
                                    fit: BoxFit.cover,
                                  )
                                : AppCachedNetworkImage(
                                    imageUrl: restaurant.imageUrl!,
                                    width: double.infinity,
                                    height: Spacing
                                        .familyRestaurantsMealImageHeight,
                                    fit: BoxFit.cover,
                                  ))
                          : ColoredBox(
                              color: color.surfaceContainerHighest,
                              child: Center(
                                child: Icon(
                                  Icons.restaurant_rounded,
                                  color: color.onSurfaceVariant,
                                  size: Spacing.iconXl,
                                ),
                              ),
                            ),
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
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
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
            const SizedBox(height: Spacing.xs),
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
            const SizedBox(height: Spacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (
                  int index = 0;
                  index < restaurant.tags.length;
                  index++
                ) ...[
                  if (index > 0) const SizedBox(width: Spacing.xxs),
                  Flexible(
                    child: FamilyRestaurantTag(tag: restaurant.tags[index]),
                  ),
                ],
              ],
            ),
            const Spacer(),
            AppButton(
              text: restaurant.buttonLabel,
              height: Spacing.familyRestaurantsCtaHeight,
              color: color.primary,
              borderRadius: Spacing.radiusPill,
              fontSize: FontSize.size11,
              fontWeight: FontWeightManger.bold,
              onPressed:
                  onSelect ??
                  () {
                    context.pushNamed(AppRoutes.familyMealSelection);
                  },
            ),
          ],
        ),
      ),
    );
  }
}
