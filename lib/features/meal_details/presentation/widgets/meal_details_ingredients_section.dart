import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_ingredient_item.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_section_title.dart';

class MealDetailsIngredientsSection extends StatelessWidget {
  const MealDetailsIngredientsSection({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MealDetailsSectionTitle(title: meal.ingredientsTitle),
        const SizedBox(height: Spacing.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: color.outlineVariant),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final ingredient in meal.ingredients)
                  MealDetailsIngredientItem(ingredient: ingredient),
              ],
            ),
          ),
        ),
        SizedBox(height: locale.localeName == 'ar' ? 0 : Spacing.xs),
      ],
    );
  }
}
