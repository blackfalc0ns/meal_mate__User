import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeNutritionDetailsTipCard extends StatelessWidget {
  const HomeNutritionDetailsTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.nutritionDetailsTipHeight,
      decoration: BoxDecoration(
        color: color.tertiaryContainer,
        borderRadius: BorderRadius.circular(Spacing.nutritionDetailsCardRadius),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.nutritionDetailsBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.12),
            blurRadius: Spacing.xxl,
            offset: const Offset(Spacing.zero, Spacing.sm),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: Spacing.nutritionDetailsTipTitleEnd,
          top: Spacing.nutritionDetailsTipTitleTop,
          end: Spacing.nutritionDetailsTipImageStart,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locale.nutrition_details_tip_title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurface,
                    ),
                  ),
                  SizedBox(height: Spacing.base),
                  Text(
                    locale.nutrition_details_tip_message,

                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width:
                  Spacing.nutritionDetailsTipTextStart -
                  Spacing.nutritionDetailsTipImageStart -
                  Spacing.nutritionDetailsTipImageWidth,
            ),
            Padding(
              padding: EdgeInsets.only(
                top:
                    Spacing.nutritionDetailsTipImageTop -
                    Spacing.nutritionDetailsTipTitleTop,
              ),
              child: Image.asset(
                AssetsFake.nutritionDetailsTipLeaf,
                width: Spacing.nutritionDetailsTipImageWidth,
                height: Spacing.nutritionDetailsTipImageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
