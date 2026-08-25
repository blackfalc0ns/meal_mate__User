import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';

class FamilyRestaurantLogo extends StatelessWidget {
  const FamilyRestaurantLogo({super.key, required this.restaurant});

  final FamilyRestaurantCardData restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    locale.localeName;

    final foreground = restaurant.darkLogo ? color.surface : color.primary;
    final background = restaurant.darkLogo
        ? color.onSurface
        : color.surfaceContainerLowest;

    return Container(
      width: Spacing.familyRestaurantsLogoSize,
      height: Spacing.familyRestaurantsLogoSize,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: restaurant.darkLogo
            ? null
            : Border.all(color: color.outlineVariant, width: Spacing.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            restaurant.logoLine1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: foreground,
            ),
          ),
          Text(
            restaurant.logoLine2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: foreground,
            ),
          ),
          if (restaurant.logoLine3 != null)
            Text(
              restaurant.logoLine3!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: foreground,
              ),
            ),
        ],
      ),
    );
  }
}
