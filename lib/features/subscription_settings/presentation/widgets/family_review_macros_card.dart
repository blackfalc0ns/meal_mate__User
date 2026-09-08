import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_review_meals_fake_data_source.dart';

class FamilyReviewMacrosCard extends StatelessWidget {
  const FamilyReviewMacrosCard({
    super.key,
    required this.nutrition,
  });

  final FamilyReviewNutritionalProgressData nutrition;

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
            progressText: locale.family_review_calories_progress(
              nutrition.caloriesCurrent.toString(),
              nutrition.caloriesTarget.toString(),
            ),
            fraction: (nutrition.caloriesCurrent / nutrition.caloriesTarget)
                .clamp(0.0, 1.0),
          ),
          const SizedBox(height: Spacing.sm),
          // Protein Progress
          _buildProgressRow(
            context,
            label: locale.family_meal_macros_protein,
            progressText: locale.family_review_grams_progress(
              nutrition.proteinCurrent.toString(),
              nutrition.proteinTarget.toString(),
            ),
            fraction: (nutrition.proteinCurrent / nutrition.proteinTarget)
                .clamp(0.0, 1.0),
          ),
          const SizedBox(height: Spacing.sm),
          // Carbs Progress
          _buildProgressRow(
            context,
            label: locale.family_meal_macros_carbs,
            progressText: locale.family_review_grams_progress(
              nutrition.carbsCurrent.toString(),
              nutrition.carbsTarget.toString(),
            ),
            fraction: (nutrition.carbsCurrent / nutrition.carbsTarget)
                .clamp(0.0, 1.0),
          ),
          const SizedBox(height: Spacing.sm),
          // Fat Progress
          _buildProgressRow(
            context,
            label: locale.family_meal_macros_fat,
            progressText: locale.family_review_grams_progress(
              nutrition.fatCurrent.toString(),
              nutrition.fatTarget.toString(),
            ),
            fraction:
                (nutrition.fatCurrent / nutrition.fatTarget).clamp(0.0, 1.0),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(
    BuildContext context, {
    required String label,
    required String progressText,
    required double fraction,
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
              progressText,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xs / 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: Spacing.xs,
            backgroundColor: color.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color.primary),
          ),
        ),
      ],
    );
  }
}
