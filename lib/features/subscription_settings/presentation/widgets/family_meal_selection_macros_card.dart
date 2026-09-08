import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_meal_selection_fake_data_source.dart';

class FamilyMealSelectionMacrosCard extends StatelessWidget {
  const FamilyMealSelectionMacrosCard({
    super.key,
    required this.macros,
  });

  final FamilyMacrosSummaryData macros;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.primary.withValues(alpha: 0.2),
          width: Spacing.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.family_meal_macros_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
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
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
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
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.sm,
                    horizontal: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Text(
                        locale.family_meal_macros_calories,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.family_meal_calorie_unit(macros.calories.toString()),
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.sm,
                    horizontal: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Text(
                        locale.family_meal_macros_carbs,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.family_meal_gram_unit(macros.carbs.toString()),
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.sm,
                    horizontal: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Text(
                        locale.family_meal_macros_protein,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.family_meal_gram_unit(macros.protein.toString()),
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.sm,
                    horizontal: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    border: Border.all(color: color.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Text(
                        locale.family_meal_macros_fat,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.family_meal_gram_unit(macros.fat.toString()),
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
