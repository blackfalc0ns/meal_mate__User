import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
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
                  icon: Icons.local_fire_department_rounded,
                  iconColor: color.primary,
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
                  icon: Icons.fitness_center_rounded,
                  iconColor: color.secondary,
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
                  icon: Icons.grain_rounded,
                  iconColor: color.tertiary,
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
                  icon: Icons.water_drop_rounded,
                  iconColor: color.error,
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
    required IconData icon,
    required Color iconColor,
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
            Icon(icon, size: Spacing.iconXs, color: iconColor),
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
          height: Spacing.xs / 1.5,
          decoration: BoxDecoration(
            color: color.outlineVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: fillFraction.clamp(0.1, 1.0),
            child: Container(
              height: Spacing.xs / 1.5,
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
