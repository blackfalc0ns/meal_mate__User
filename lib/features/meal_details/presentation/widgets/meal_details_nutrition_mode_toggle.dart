import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

class MealDetailsNutritionModeToggle extends StatelessWidget {
  const MealDetailsNutritionModeToggle({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  final MealDetailsNutritionMode selectedMode;
  final ValueChanged<MealDetailsNutritionMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isPerMeal = selectedMode == MealDetailsNutritionMode.perMeal;

    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
      ),
      padding: const EdgeInsets.all(Spacing.xxs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            context: context,
            title: locale.meal_details_per_meal,
            isSelected: isPerMeal,
            onTap: () => onModeChanged(MealDetailsNutritionMode.perMeal),
          ),
          _buildItem(
            context: context,
            title: locale.meal_details_per_100g,
            isSelected: !isPerMeal,
            onTap: () => onModeChanged(MealDetailsNutritionMode.per100g),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary
              : color.surface.withValues(alpha: 0.0),
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
        ),
        child: Text(
          title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: isSelected ? color.onPrimary : color.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
