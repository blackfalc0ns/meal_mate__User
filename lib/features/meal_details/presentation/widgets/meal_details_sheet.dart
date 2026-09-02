import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_allergens_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_ingredients_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_info_row.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_macro_distribution_card.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_optional_notes_field.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_title_section.dart';

class MealDetailsSheet extends StatelessWidget {
  const MealDetailsSheet({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(Spacing.xxl),
      ),
      child: ColoredBox(
        color: color.surface,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: Spacing.md,
                left: Spacing.xl,
                right: Spacing.xl,
                bottom: MediaQuery.paddingOf(context).bottom + Spacing.xl,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
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
                    const Spacer(),
                    const SizedBox(height: Spacing.lg),
                    if (meal.allergens.isNotEmpty) ...[
                      MealDetailsAllergensSection(meal: meal),
                      const SizedBox(height: Spacing.lg),
                    ],
                    const MealDetailsOptionalNotesField(),
                    const SizedBox(height: Spacing.lg),
                    // MealDetailsBottomActionButton(
                    //   onPressed: () => Navigator.maybePop(context),
                    // ),
                    // SizedBox(
                    //   height: locale.localeName == 'ar' ? Spacing.sm : 0,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
