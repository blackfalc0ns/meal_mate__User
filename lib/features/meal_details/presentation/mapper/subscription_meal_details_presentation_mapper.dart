import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';

abstract final class SubscriptionMealDetailsPresentationMapper {
  static MealDetailsEntity map({
    required SubscriptionMealDetailsEntity meal,
    required AppLocalizations locale,
    String? restaurantInitials,
    String? fallbackRating,
  }) {
    final localeName = locale.localeName;
    final restaurantName = meal.restaurantName(localeName);
    final ratingValue =
        _ratingValue(meal.restaurantRating, meal.restaurantRatingCount) ??
        fallbackRating ??
        '';
    final nutrition = meal.nutrition;

    return MealDetailsEntity(
      title: meal.name(localeName),
      description: meal.description(localeName),
      restaurantName: restaurantName,
      restaurantLogo: restaurantInitials ?? _initials(restaurantName),
      restaurantLogoUrl: meal.restaurantLogoUrl,
      headerImageUrl: meal.imageUrl,
      ratingTitle: locale.meal_details_restaurant_rating,
      ratingValue: ratingValue,
      programLabel: locale.meal_details_meal_type,
      programValue: meal.slotName(localeName),
      deliveryLabel: locale.meal_details_delivery_time,
      deliveryValue: _deliveryWindow(
        meal.deliveryWindowStart,
        meal.deliveryWindowEnd,
      ),
      ingredientsTitle: locale.calendar_ingredients,
      ingredients: meal.ingredients
          .map(
            (ingredient) => MealDetailsIngredientEntity(
              label: ingredient.name(localeName),
              asset: _ingredientAsset(ingredient.category),
              iconUrl: ingredient.iconUrl,
            ),
          )
          .where((ingredient) => ingredient.label.isNotEmpty)
          .toList(),
      nutritionTitle: locale.meal_details_nutrition_facts,
      nutritionItems: [
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.fiberG, locale),
          label: locale.nutrition_details_fiber,
          type: MealDetailsNutritionType.fiber,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.proteinG, locale),
          label: locale.calendar_protein,
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.carbsG, locale),
          label: locale.calendar_carbs,
          type: MealDetailsNutritionType.carbs,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(nutrition.fatG, locale),
          label: locale.calendar_fat,
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsNutritionEntity(
          value: _plainNumber(nutrition.calories),
          label: locale.calendar_calories,
          type: MealDetailsNutritionType.calories,
        ),
      ],
      macroDistributionTitle: locale.meal_details_macro_distribution,
      macroItems: [
        MealDetailsMacroEntity(
          percent: _percent(nutrition.fatPercent, locale),
          label: locale.calendar_fat,
          value: _gramValue(nutrition.fatG, locale),
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsMacroEntity(
          percent: _percent(nutrition.proteinPercent, locale),
          label: locale.calendar_protein,
          value: _gramValue(nutrition.proteinG, locale),
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsMacroEntity(
          percent: _percent(nutrition.carbsPercent, locale),
          label: locale.calendar_carbs,
          value: _gramValue(nutrition.carbsG, locale),
          type: MealDetailsNutritionType.carbs,
        ),
      ],
      allergensTitle: locale.meal_details_allergens,
      allergens: meal.allergens
          .map(
            (allergen) => MealDetailsAllergenEntity(
              label: allergen.name(localeName),
              type: _allergenType(allergen.type),
            ),
          )
          .where((allergen) => allergen.label.isNotEmpty)
          .toList(),
    );
  }

  static String? _ratingValue(double? rating, int ratingCount) {
    if (rating == null) return null;
    final value = _plainNumber(rating);
    return ratingCount > 0 ? '$value ($ratingCount)' : value;
  }

  static String _deliveryWindow(String? start, String? end) {
    if ((start == null || start.isEmpty) && (end == null || end.isEmpty)) {
      return '';
    }
    if (start == null || start.isEmpty) return end ?? '';
    if (end == null || end.isEmpty) return start;
    return '$start - $end';
  }

  static String _gramValue(double? value, AppLocalizations locale) {
    if (value == null) return '-';
    return locale.meal_details_gram_value(_plainNumber(value));
  }

  static String _percent(int? value, AppLocalizations locale) {
    if (value == null) return '-';
    return locale.nutrition_details_percent_value(value);
  }

  static String _plainNumber(num? value) {
    if (value == null) return '-';
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  static String _ingredientAsset(String category) {
    return switch (category.toLowerCase()) {
      'poultry' => AssetsFake.ingredientChicken,
      'grains' => AssetsFake.ingredientRice,
      'produce' => AssetsFake.ingredientBroccoli,
      _ => AssetsFake.ingredientBroccoli,
    };
  }

  static MealDetailsAllergenType _allergenType(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('lactose') || normalized.contains('milk')) {
      return MealDetailsAllergenType.lactose;
    }
    if (normalized.contains('gluten') || normalized.contains('wheat')) {
      return MealDetailsAllergenType.gluten;
    }
    return MealDetailsAllergenType.nuts;
  }

  static String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
