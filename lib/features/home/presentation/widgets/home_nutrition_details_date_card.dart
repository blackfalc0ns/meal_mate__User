import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeNutritionDetailsDateCard extends StatelessWidget {
  const HomeNutritionDetailsDateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.nutritionDetailsDateHeight,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: color.tertiaryContainer,
        borderRadius: BorderRadius.circular(Spacing.nutritionDetailsCardRadius),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.nutritionDetailsBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: Spacing.lg,
            offset: const Offset(Spacing.zero, Spacing.xs),
          ),
        ],
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: locale.nutrition_details_date_prefix),
            TextSpan(
              text: locale.nutrition_details_date_day,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.primary,
              ),
            ),
            TextSpan(text: locale.nutrition_details_date_suffix),
          ],
        ),
        style: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size14,
          color: color.onSurface,
        ),
      ),
    );
  }
}
