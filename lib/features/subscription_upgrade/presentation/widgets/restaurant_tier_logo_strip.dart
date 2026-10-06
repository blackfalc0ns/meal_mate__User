import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class RestaurantTierLogoStrip extends StatelessWidget {
  const RestaurantTierLogoStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: Spacing.restaurantTierLogoStripWidth,
      height: Spacing.restaurantTierLogoStripHeight,
      child: FittedBox(
        alignment: AlignmentDirectional.centerStart,
        child: SvgPicture.asset(
          Assets.subscriptionRestaurantStack,
          semanticsLabel: locale.subscription_restaurant_categories_title,
          placeholderBuilder: (_) =>
              Icon(Icons.restaurant_rounded, color: color.primary),
        ),
      ),
    );
  }
}
