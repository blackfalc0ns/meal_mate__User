import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';

class FamilyReviewMacrosCard extends StatelessWidget {
  const FamilyReviewMacrosCard({super.key, required this.nutrition});

  final CalendarNutritionTotalsEntity nutrition;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.xs,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_outline_rounded,
                size: Spacing.iconMd,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.family_review_nutrition_summary_section,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          // Calories Progress
          _buildProgressRow(
            context,
            label: locale.family_meal_macros_calories,
            valueText: locale.family_meal_calorie_unit(
              nutrition.calories.toString(),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          // Protein Progress
          _buildProgressRow(
            context,
            label: locale.family_meal_macros_protein,
            valueText: locale.family_meal_gram_unit(
              nutrition.proteinG.toString(),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          // Carbs Progress
          _buildProgressRow(
            context,
            label: locale.family_meal_macros_carbs,
            valueText: locale.family_meal_gram_unit(
              nutrition.carbsG.toString(),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          // Fat Progress
          _buildProgressRow(
            context,
            label: locale.family_meal_macros_fat,
            valueText: locale.family_meal_gram_unit(nutrition.fatG.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(
    BuildContext context, {
    required String label,
    required String valueText,
  }) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurface,
              ),
            ),
            Text(
              valueText,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
