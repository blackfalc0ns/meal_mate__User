import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MealDetailsSectionTitle extends StatelessWidget {
  const MealDetailsSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Text(
      title,
      textAlign: TextAlign.right,
      style: getSemiBoldStyle(
        fontFamily: FontConstant.ibmPlexSansArabic,
        fontSize: FontSize.size12,
        color: color.primary,
      ).copyWith(height: locale.localeName == 'ar' ? 1.45 : 1.2),
    );
  }
}
