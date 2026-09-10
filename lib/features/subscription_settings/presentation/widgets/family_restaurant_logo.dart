import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/models/family_restaurants_view_data.dart';

class FamilyRestaurantLogo extends StatelessWidget {
  const FamilyRestaurantLogo({super.key, required this.restaurant});

  final FamilyRestaurantCardData restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final foreground = color.primary;
    final words = restaurant.name.split(' ');

    return Container(
      width: Spacing.familyRestaurantsLogoSize,
      height: Spacing.familyRestaurantsLogoSize,
      decoration: BoxDecoration(
        color: color.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            words.first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size7,
              color: foreground,
            ),
          ),
          Text(
            words.length > 1 ? words[1] : '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size7,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
