import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_nutrition_details_entity.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_nutrition_details_calorie_metric.dart';

class HomeNutritionDetailsCalorieCard extends StatelessWidget {
  const HomeNutritionDetailsCalorieCard({super.key, required this.details});

  final HomeNutritionDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.nutritionDetailsCalorieCardHeight,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(Spacing.nutritionDetailsCardRadius),
        border: Border.all(
          color: color.primaryContainer,
          width: Spacing.nutritionDetailsBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.18),
            blurRadius: Spacing.xxl,
            offset: const Offset(Spacing.zero, Spacing.md),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: Spacing.nutritionDetailsBurnedStart,
          top: Spacing.nutritionDetailsRingTop,
          end: Spacing.xxl,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.nutritionDetailsSideMetricPaddingTop,
              ),
              child: HomeNutritionDetailsCalorieMetric(
                label: locale.nutrition_details_burned,
                value: details.burnedCalories.toString(),
                unit: locale.nutrition_details_calorie_unit,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: Spacing.nutritionDetailsRingSize,
              height: Spacing.nutritionDetailsRingSize,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SvgPicture.asset(Assets.nutritionDetailsCalorieRing),
                  SizedBox(
                    width: Spacing.avatarLg,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          locale.nutrition_details_remaining,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onPrimary,
                          ),
                        ),
                        Text(
                          details.remainingCalories.toString(),
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size25,
                            color: color.onPrimary,
                          ),
                        ),
                        Text(
                          locale.nutrition_details_calorie_unit,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.nutritionDetailsSideMetricPaddingTop,
              ),
              child: HomeNutritionDetailsCalorieMetric(
                label: locale.nutrition_details_goal,
                value: details.goalCalories.toString(),
                unit: locale.nutrition_details_calorie_unit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
