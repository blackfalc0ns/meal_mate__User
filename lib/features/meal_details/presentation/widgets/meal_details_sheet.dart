import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_allergens_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_ingredients_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_info_row.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_macro_distribution_card.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_section.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_rating_badge.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_title_section.dart';

class MealDetailsSheet extends StatelessWidget {
  const MealDetailsSheet({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(Spacing.xxl),
      ),
      child: ColoredBox(
        color: color.surface,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            top: Spacing.lg,
            left: Spacing.xl,
            right: Spacing.xl,
            bottom: MediaQuery.paddingOf(context).bottom + Spacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MealDetailsRatingBadge(
                    title: meal.ratingTitle,
                    value: meal.ratingValue,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: Spacing.md),
              MealDetailsTitleSection(meal: meal),
              const SizedBox(height: Spacing.xl),
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
              MealDetailsAllergensSection(meal: meal),
              SizedBox(height: locale.localeName == 'ar' ? Spacing.sm : 0),
            ],
          ),
        ),
      ),
    );
  }
}
