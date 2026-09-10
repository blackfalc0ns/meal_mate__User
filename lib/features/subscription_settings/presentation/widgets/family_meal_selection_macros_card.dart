import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';

class FamilyMealSelectionMacrosCard extends StatelessWidget {
  const FamilyMealSelectionMacrosCard({super.key, required this.macros});

  final CalendarNutritionTotalsEntity macros;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.pie_chart_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.family_meal_macros_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs / 2),
                    Text(
                      locale.family_meal_macros_subtitle,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: Spacing.iconXs,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs / 2),
                    Text(
                      locale.family_meal_macros_selected_badge,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildMacroColumn(
                  animationAsset: Assets.fireAnimation,
                  label: locale.family_meal_macros_calories,
                  value: locale.family_meal_calorie_unit(
                    macros.calories.toString(),
                  ),
                  barColor: color.primary,
                  fillFraction: 0.85,
                  color: color,
                ),
              ),
              _buildDivider(color),
              Expanded(
                child: _buildMacroColumn(
                  animationAsset: Assets.muscleAnimation,
                  label: locale.family_meal_macros_protein,
                  value: locale.family_meal_gram_unit(
                    macros.proteinG.toString(),
                  ),
                  barColor: color.secondary,
                  fillFraction: 0.75,
                  color: color,
                ),
              ),
              _buildDivider(color),
              Expanded(
                child: _buildMacroColumn(
                  animationAsset: Assets.wheatAnimation,
                  label: locale.family_meal_macros_carbs,
                  value: locale.family_meal_gram_unit(macros.carbsG.toString()),
                  barColor: color.tertiary,
                  fillFraction: 0.65,
                  color: color,
                ),
              ),
              _buildDivider(color),
              Expanded(
                child: _buildMacroColumn(
                  animationAsset: Assets.dropletAnimation,
                  label: locale.family_meal_macros_fat,
                  value: locale.family_meal_gram_unit(macros.fatG.toString()),
                  barColor: color.error,
                  fillFraction: 0.50,
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
      height: Spacing.xl,
      margin: const EdgeInsets.symmetric(horizontal: Spacing.xs / 2),
      color: color.outlineVariant,
    );
  }

  Widget _buildMacroColumn({
    required String animationAsset,
    required String label,
    required String value,
    required Color barColor,
    required double fillFraction,
    required ColorScheme color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              animationAsset,
              width: 20,
              height: 25,
              fit: BoxFit.contain,
              repeat: true,
            ),
            const SizedBox(width: Spacing.xs / 2),
            Text(
              label,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xs / 2),
        Text(
          value,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurface,
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
            widthFactor: fillFraction.clamp(0.1, 1.0),
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
