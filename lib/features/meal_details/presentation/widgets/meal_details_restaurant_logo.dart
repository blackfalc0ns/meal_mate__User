import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsRestaurantLogo extends StatelessWidget {
  const MealDetailsRestaurantLogo({
    super.key,
    required this.label,
    required this.size,
  });

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color.primary, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size9,
          color: color.onPrimary,
        ).copyWith(height: locale.localeName == 'ar' ? 1 : 0.95),
      ),
    );
  }
}
