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

    return Text(
      title,

      style: getSemiBoldStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size12,
        color: color.primary,
      ),
    );
  }
}
