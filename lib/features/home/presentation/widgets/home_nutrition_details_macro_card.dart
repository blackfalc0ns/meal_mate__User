import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_nutrition_details_entity.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_details_progress_bar.dart';

class HomeNutritionDetailsMacroCard extends StatelessWidget {
  const HomeNutritionDetailsMacroCard({super.key, required this.macro});

  final HomeNutritionDetailsMacroEntity macro;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final progressColor = switch (macro.type) {
      HomeNutritionDetailsMacroType.protein => color.primary,
      HomeNutritionDetailsMacroType.carbs => color.secondary,
      HomeNutritionDetailsMacroType.fat => color.secondary,
      HomeNutritionDetailsMacroType.fiber => color.primary,
      HomeNutritionDetailsMacroType.sugar => color.error,
    };
    final label = switch (macro.type) {
      HomeNutritionDetailsMacroType.protein => locale.home_protein,
      HomeNutritionDetailsMacroType.carbs => locale.home_carbs,
      HomeNutritionDetailsMacroType.fat => locale.home_fat,
      HomeNutritionDetailsMacroType.fiber => locale.nutrition_details_fiber,
      HomeNutritionDetailsMacroType.sugar => locale.nutrition_details_sugar,
    };

    return Container(
      height: Spacing.nutritionDetailsMacroCardHeight,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.nutritionDetailsCardRadius),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.nutritionDetailsBorderWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: Spacing.nutritionDetailsMacroIconEnd,
          top: Spacing.nutritionDetailsMacroValueTop,
          end: Spacing.nutritionDetailsMacroValueStart,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Spacing.nutritionDetailsMacroIconWidth,
                  height: Spacing.nutritionDetailsMacroIconBoxHeight,
                  child: OverflowBox(
                    alignment: AlignmentDirectional.topStart,
                    minWidth: Spacing.nutritionDetailsMacroIconWidth,
                    maxWidth: Spacing.nutritionDetailsMacroIconWidth,
                    minHeight: Spacing.nutritionDetailsMacroIconHeight,
                    maxHeight: Spacing.nutritionDetailsMacroIconHeight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Spacing.nutritionDetailsMacroIconPaddingTop,
                      ),
                      child: Image.asset(
                        macro.imageAsset,
                        width: Spacing.nutritionDetailsMacroIconWidth,
                        height: Spacing.nutritionDetailsMacroIconHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
               SizedBox(width: Spacing.base),
                Text(
                  label,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: macro.consumed.toString(),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: progressColor,
                            ),
                          ),
                          TextSpan(
                            text: locale.nutrition_details_macro_separator,
                          ),
                          TextSpan(
                            text: macro.target.toString(),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurface,
                            ),
                          ),
                          TextSpan(text: locale.nutrition_details_gram_suffix),
                        ],
                      ),
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurface,
                      ),
                    ),
                    SizedBox(height: Spacing.nutritionDetailsMacroPercentGap),
                    Text(
                      locale.nutrition_details_percent_value(macro.percent),
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(
                Spacing.zero,
                Spacing.nutritionDetailsProgressOffsetY,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: Spacing.nutritionDetailsProgressPaddingStart,
                  end: Spacing.nutritionDetailsProgressPaddingEnd,
                ),
                child: HomeNutritionDetailsProgressBar(
                  percent: macro.percent,
                  progressColor: progressColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
