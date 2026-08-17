import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class RestaurantTierCountBadge extends StatelessWidget {
  const RestaurantTierCountBadge({
    super.key,
    required this.text,
    required this.foregroundColor,
    required this.borderColor,
  });

  final String text;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.iconLg,
      height: Spacing.iconLg,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.surface,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        semanticsLabel: locale.subscription_summary_restaurants,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size12,
          color: foregroundColor,
        ),
      ),
    );
  }
}
