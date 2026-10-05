import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_allergens_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_bottom_action_button.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_ingredients_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_card.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_optional_notes_field.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_title_section.dart';

class MealDetailsContent extends StatelessWidget {
  const MealDetailsContent({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final onSelectMeal = meal.onSelectMeal;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.screenV,
        horizontal: Spacing.screenH,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MealDetailsTitleSection(meal: meal),
          const SizedBox(height: Spacing.base),
          MealDetailsNutritionCard(meal: meal),
          const SizedBox(height: Spacing.base),
          MealDetailsIngredientsSection(meal: meal),
          const SizedBox(height: Spacing.base),
          MealDetailsAllergensSection(meal: meal),
          const SizedBox(height: Spacing.base),
          if (onSelectMeal != null) ...[
            const MealDetailsOptionalNotesField(),
            const SizedBox(height: Spacing.lg),
            MealDetailsBottomActionButton(
              onPressed: () {
                onSelectMeal();
                unawaited(Navigator.maybePop(context));
              },
            ),
            const SizedBox(height: Spacing.lg),
          ],
          const SizedBox(height: Spacing.xxxl),
        ],
      ),
    );
  }
}
