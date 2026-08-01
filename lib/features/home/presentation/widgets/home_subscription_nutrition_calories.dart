import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeSubscriptionNutritionCalories extends StatelessWidget {
  const HomeSubscriptionNutritionCalories({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
      width: Spacing.homeNutritionCaloriesRingSize,
      height: Spacing.homeNutritionCaloriesRingSize,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned.fill(
            child: SvgPicture.asset(Assets.homeNutritionCalorieRing),
          ),
          PositionedDirectional(
            top: Spacing.homeNutritionCaloriesLabelTop,
            child: Text(
              locale.home_remaining_calories,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size7,
                color: color.onPrimary,
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.homeNutritionCaloriesValueTop,
            child: Text(
              locale.home_remaining_calories_value,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size24,
                color: color.onPrimary,
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.homeNutritionCaloriesGoalTop,
            child: Text(
              locale.home_calories_of_goal,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size7,
                color: color.onPrimary,
              ),
            ),
          ),
          Positioned(
            left: Spacing.homeNutritionFireBadgeStart,
            top: Spacing.homeNutritionFireBadgeTop,
            child: SvgPicture.asset(
              Assets.homeNutritionFireBadge,
              width: Spacing.homeNutritionFireBadgeSize,
              height: Spacing.homeNutritionFireBadgeSize,
            ),
          ),
        ],
      ),
    );
  }
}
