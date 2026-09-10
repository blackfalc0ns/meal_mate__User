import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';

class FamilyReviewMacrosCard extends StatelessWidget {
  const FamilyReviewMacrosCard({
    super.key,
    required this.nutrition,
    this.targetCalories = 2000,
    this.targetProtein = 120,
    this.targetCarbs = 260,
    this.targetFat = 70,
  });

  final CalendarNutritionTotalsEntity nutrition;
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFat;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
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
                Icons.monitor_heart_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.family_review_nutrition_summary_section,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildColumn(
                  value: '${nutrition.calories}',
                  title: locale.family_meal_macros_calories,
                  targetText: 'من $targetCalories سعرة',
                  barColor: color.primary,
                  fraction: targetCalories > 0 && nutrition.calories > 0
                      ? (nutrition.calories / targetCalories).clamp(0.0, 1.0)
                      : 0.0,
                  color: color,
                ),
              ),
              _buildDivider(color),
              Expanded(
                child: _buildColumn(
                  value: '${nutrition.proteinG}',
                  title: locale.family_meal_macros_protein,
                  targetText: 'من $targetProtein جم',
                  barColor: color.secondary,
                  fraction: targetProtein > 0 && nutrition.proteinG > 0
                      ? (nutrition.proteinG / targetProtein).clamp(0.0, 1.0)
                      : 0.0,
                  color: color,
                ),
              ),
              _buildDivider(color),
              Expanded(
                child: _buildColumn(
                  value: '${nutrition.carbsG}',
                  title: locale.family_meal_macros_carbs,
                  targetText: 'من $targetCarbs جم',
                  barColor: color.tertiary,
                  fraction: targetCarbs > 0 && nutrition.carbsG > 0
                      ? (nutrition.carbsG / targetCarbs).clamp(0.0, 1.0)
                      : 0.0,
                  color: color,
                ),
              ),
              _buildDivider(color),
              Expanded(
                child: _buildColumn(
                  value: '${nutrition.fatG}',
                  title: locale.family_meal_macros_fat,
                  targetText: 'من $targetFat جم',
                  barColor: color.error,
                  fraction: targetFat > 0 && nutrition.fatG > 0
                      ? (nutrition.fatG / targetFat).clamp(0.0, 1.0)
                      : 0.0,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme color) {
    return Container(
      width: Spacing.border,
      height: Spacing.xl * 1.5,
      margin: const EdgeInsets.symmetric(horizontal: Spacing.xs / 2),
      color: color.outlineVariant,
    );
  }

  Widget _buildColumn({
    required String value,
    required String title,
    required String targetText,
    required Color barColor,
    required double fraction,
    required ColorScheme color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size9,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.xxs / 2),
        Text(
          value,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xxs / 2),
        Text(
          targetText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size8,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Container(
          height: Spacing.sm,
          decoration: BoxDecoration(
            color: color.outlineVariant,
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: fraction,
            child: Container(
              height: Spacing.sm,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
