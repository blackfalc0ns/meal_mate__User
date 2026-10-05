import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_calories_donut.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_macro_column.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_mode_toggle.dart';

class MealDetailsNutritionCard extends StatefulWidget {
  const MealDetailsNutritionCard({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  State<MealDetailsNutritionCard> createState() =>
      _MealDetailsNutritionCardState();
}

class _MealDetailsNutritionCardState extends State<MealDetailsNutritionCard> {
  MealDetailsNutritionMode _mode = MealDetailsNutritionMode.perMeal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isPerMeal = _mode == MealDetailsNutritionMode.perMeal;

    final macroItems = isPerMeal
        ? widget.meal.macroItems
        : (widget.meal.macroItemsPer100g.isNotEmpty
              ? widget.meal.macroItemsPer100g
              : widget.meal.macroItems);

    final fatItem = _findMacro(macroItems, MealDetailsNutritionType.fat);
    final proteinItem = _findMacro(
      macroItems,
      MealDetailsNutritionType.protein,
    );
    final carbsItem = _findMacro(macroItems, MealDetailsNutritionType.carbs);

    final caloriesItem = _findCaloriesItem(isPerMeal);
    final caloriesValue = caloriesItem?.value ?? '550';
    final caloriesLabel = caloriesItem?.label ?? locale.calendar_calories;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.meal.nutritionTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              MealDetailsNutritionModeToggle(
                selectedMode: _mode,
                onModeChanged: (mode) => setState(() => _mode = mode),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MealDetailsMacroColumn(
                percent: fatItem?.percent ?? '25%',
                value: fatItem?.value ?? '15 جم',
                label: fatItem?.label ?? locale.calendar_fat,
                icon: Icons.water_drop_rounded,
                indicatorColor: color.secondary,
              ),
              SizedBox(
                height: 52.0,
                child: VerticalDivider(
                  color: color.outlineVariant,
                  thickness: 1.0,
                ),
              ),
              MealDetailsMacroColumn(
                percent: proteinItem?.percent ?? '30%',
                value: proteinItem?.value ?? '65 جم',
                label: proteinItem?.label ?? locale.calendar_protein,
                icon: Icons.fitness_center_rounded,
                indicatorColor: color.error,
              ),
              SizedBox(
                height: 52.0,
                child: VerticalDivider(
                  color: color.outlineVariant,
                  thickness: 1.0,
                ),
              ),
              MealDetailsMacroColumn(
                percent: carbsItem?.percent ?? '%45',
                value: carbsItem?.value ?? '60 جم',
                label: carbsItem?.label ?? locale.calendar_carbs,
                icon: Icons.bakery_dining_rounded,
                indicatorColor: color.primary,
              ),
              SizedBox(
                height: 52.0,
                child: VerticalDivider(
                  color: color.outlineVariant,
                  thickness: 1.0,
                ),
              ),
              MealDetailsCaloriesDonut(
                calories: caloriesValue,
                label: caloriesLabel,
                progress: 0.48,
              ),
            ],
          ),
        ],
      ),
    );
  }

  MealDetailsMacroEntity? _findMacro(
    List<MealDetailsMacroEntity> items,
    MealDetailsNutritionType type,
  ) {
    for (final item in items) {
      if (item.type == type) return item;
    }
    return null;
  }

  MealDetailsNutritionEntity? _findCaloriesItem(bool isPerMeal) {
    final list = isPerMeal
        ? widget.meal.nutritionItems
        : (widget.meal.nutritionItemsPer100g.isNotEmpty
              ? widget.meal.nutritionItemsPer100g
              : widget.meal.nutritionItems);

    for (final item in list) {
      if (item.type == MealDetailsNutritionType.calories) return item;
    }
    return null;
  }
}
