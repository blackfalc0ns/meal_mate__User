import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_nutrition_calories.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_nutrition_macro.dart';

class HomeSubscriptionNutritionPanel extends StatelessWidget {
  const HomeSubscriptionNutritionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
      width: Spacing.homeNutritionPanelWidth,
      height: Spacing.homeNutritionPanelHeight,
      child: Stack(
        children: [
          Positioned(
            left: Spacing.homeNutritionBackgroundStart,
            top: Spacing.homeNutritionBackgroundTop,
            child: SvgPicture.asset(
              Assets.homeNutritionBackgroundGreen,
              width: Spacing.homeNutritionBackgroundWidth,
              height: Spacing.homeNutritionBackgroundHeight,
            ),
          ),
          Positioned(
            left: Spacing.homeNutritionLightBackgroundStart,
            top: Spacing.homeNutritionBackgroundTop,
            child: SvgPicture.asset(
              Assets.homeNutritionBackgroundLight,
              width: Spacing.homeNutritionLightBackgroundWidth,
              height: Spacing.homeNutritionBackgroundHeight,
            ),
          ),
          const Positioned(
            left: 0,
            top: 0,
            child: HomeSubscriptionNutritionCalories(),
          ),
          Positioned(
            top: Spacing.homeNutritionTitleTop,
            left: Spacing.homeNutritionTitleStart,
            child: SizedBox(
              width: Spacing.homeNutritionTitleWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        locale.home_main_nutrients,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  SvgPicture.asset(
                    Assets.homeNutritionHeart,
                    width: Spacing.homeNutritionTitleIconSize,
                    height: Spacing.homeNutritionTitleIconSize,
                    colorFilter: ColorFilter.mode(
                      color.onTertiaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: Spacing.homeNutritionFatStart,
            top: Spacing.homeNutritionFatTop,
            child: HomeSubscriptionNutritionMacro(
              width: Spacing.homeNutritionFatWidth,
              label: locale.home_fat,
              value: locale.home_fat_value,
              goal: locale.home_fat_goal,
              progressColor: color.secondary,
            ),
          ),
          Positioned(
            left: Spacing.homeNutritionCarbsStart,
            top: Spacing.homeNutritionCarbsTop,
            child: HomeSubscriptionNutritionMacro(
              width: Spacing.homeNutritionCarbsWidth,
              label: locale.home_carbs,
              value: locale.home_carbs_value,
              goal: locale.home_carbs_goal,
              progressColor: color.secondary,
            ),
          ),
          Positioned(
            left: Spacing.homeNutritionProteinStart,
            top: Spacing.homeNutritionProteinTop,
            child: HomeSubscriptionNutritionMacro(
              width: Spacing.homeNutritionProteinWidth,
              label: locale.home_protein,
              value: locale.home_protein_value,
              goal: locale.home_protein_goal,
              progressColor: color.primary,
            ),
          ),
        ],
      ),
    );
  }
}
