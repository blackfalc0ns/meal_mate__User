import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_allergens_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_bottom_action_button.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_info_row.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_ingredients_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_macro_distribution_card.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_section.dart';
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
          const SizedBox(height: Spacing.md),
          MealDetailsInfoRow(meal: meal),
          const SizedBox(height: Spacing.md),
          MealDetailsIngredientsSection(meal: meal),
          const SizedBox(height: Spacing.base),
          MealDetailsNutritionSection(
            title: meal.nutritionTitle,
            items: meal.nutritionItems,
          ),
          const SizedBox(height: Spacing.base),
          MealDetailsMacroDistributionCard(meal: meal),
          const SizedBox(height: Spacing.lg),
          if (meal.allergens.isNotEmpty) ...[
            MealDetailsAllergensSection(meal: meal),
            const SizedBox(height: Spacing.lg),
          ],
          if (onSelectMeal != null) ...[
            const MealDetailsOptionalNotesField(),
            const SizedBox(height: Spacing.lg),
            MealDetailsBottomActionButton(
              onPressed: () {
                onSelectMeal();
                Navigator.maybePop(context);
              },
            ),
            const SizedBox(height: Spacing.lg),
          ],
        ],
      ),
    );
  }
}
