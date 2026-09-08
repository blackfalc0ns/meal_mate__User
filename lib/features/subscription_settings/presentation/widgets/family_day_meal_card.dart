import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_nutrition_row.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_meal_icon.dart';

class FamilyDayMealCard extends StatelessWidget {
  const FamilyDayMealCard({
    super.key,
    required this.meal,
    required this.onEditPressed,
  });

  final FamilyDayMealEntity meal;
  final VoidCallback onEditPressed;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Spacing.familyDayMealImageRadius,
                  ),
                  child: Image.asset(
                    meal.imageAsset,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        meal.mealName,
                        locale: Locale(locale.localeName),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size16,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
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
