import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/app_nutrition_row.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meal_icon.dart';

class FamilyDayMealCard extends StatelessWidget {
  const FamilyDayMealCard({super.key, required this.meal, this.onEditPressed});

  final FamilyDayMealEntity meal;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.familyDayMealCardBorderWidth,
        ),
        borderRadius: BorderRadius.circular(Spacing.familyDayMealCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FamilyDayMealIcon(type: meal.iconType),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      meal.mealType,
                      locale: Locale(locale.localeName),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: Spacing.familyDayMealButtonWidth,
                  height: 32,
                  child: AppButton.outlined(
                    text: meal.actionLabel,
                    onPressed: onEditPressed,
                    isExpanded: true,
                    height: 32,
                    borderRadius: 16,
                    color: color.primary,
                    textColor: color.primary,
                    fontSize: FontSize.size12,
                    fontWeight: FontWeightManger.bold,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            if (meal.isEmpty)
              InkWell(
                onTap: onEditPressed,
                borderRadius: BorderRadius.circular(Spacing.md),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(Spacing.md),
                    border: Border.all(
                      color: color.outlineVariant,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        color: color.primary,
                        size: Spacing.iconMd,
                      ),
                      const SizedBox(width: Spacing.sm),
                      Text(
                        meal.mealName,
                        locale: Locale(locale.localeName),
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Spacing.familyDayMealImageRadius,
                    ),
                    child: meal.imageUrl?.isNotEmpty == true
                        ? AppCachedNetworkImage(
                            imageUrl: meal.imageUrl!,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            meal.imageAsset.isNotEmpty
                                ? meal.imageAsset
                                : Assets.profileBillingPlanBottle,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.mealName,
                          locale: Locale(locale.localeName),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size16,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        if (meal.calories.isNotEmpty ||
                            meal.carbs.isNotEmpty ||
                            meal.protein.isNotEmpty ||
                            meal.fat.isNotEmpty)
                          AppNutritionRow(
                            calories: meal.calories,
                            carbs: meal.carbs,
                            protein: meal.protein,
                            fat: meal.fat,
                            caloriesLabel: meal.caloriesLabel,
                            carbsLabel: meal.carbsLabel,
                            proteinLabel: meal.proteinLabel,
                            fatLabel: meal.fatLabel,
                            order: NutritionOrder.caloriesCarbsProteinFat,
                            animationSize: 18.0,
                            height: 44.0,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
