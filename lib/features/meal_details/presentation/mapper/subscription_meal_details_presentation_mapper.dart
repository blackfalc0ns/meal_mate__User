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

    final tags = [
      MealDetailsTagEntity(
        label: locale.meal_tag_natural_ingredients,
        icon: Icons.spa_rounded,
      ),
      MealDetailsTagEntity(
        label: locale.meal_tag_diet_friendly,
        icon: Icons.restaurant_rounded,
      ),
      MealDetailsTagEntity(
        label: locale.meal_tag_high_protein,
        icon: Icons.fitness_center_rounded,
      ),
    ];

    final proteinPerMeal = nutrition.proteinG;
    final carbsPerMeal = nutrition.carbsG;
    final fatPerMeal = nutrition.fatG;

    final protein100g = proteinPerMeal != null ? proteinPerMeal / 3.5 : 18.5;
    final carbs100g = carbsPerMeal != null ? carbsPerMeal / 3.5 : 17.1;
    final fat100g = fatPerMeal != null ? fatPerMeal / 3.5 : 4.3;
    final calories100g = nutrition.calories != null
        ? (nutrition.calories! / 3.5).round().toString()
        : '157';

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
      tags: tags,
      ingredientsTitle: locale.calendar_ingredients,
      ingredients: meal.ingredients.isNotEmpty
          ? meal.ingredients
                .map(
                  (ingredient) => MealDetailsIngredientEntity(
                    label: ingredient.name(localeName),
                    asset: _resolveIngredientAsset(
                      ingredient.name(localeName),
                      ingredient.category,
                    ),
                    iconUrl: ingredient.iconUrl,
                    weight: _ingredientWeight(ingredient.nameAr, localeName),
                  ),
                )
                .where((ingredient) => ingredient.label.isNotEmpty)
                .toList()
          : _fallbackIngredients(localeName),
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
      nutritionItemsPer100g: [
        MealDetailsNutritionEntity(
          value: _gramValue(protein100g, locale),
          label: locale.calendar_protein,
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(carbs100g, locale),
          label: locale.calendar_carbs,
          type: MealDetailsNutritionType.carbs,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(fat100g, locale),
          label: locale.calendar_fat,
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsNutritionEntity(
          value: calories100g,
          label: locale.calendar_calories,
          type: MealDetailsNutritionType.calories,
        ),
      ],
      macroItemsPer100g: [
        MealDetailsMacroEntity(
          percent: _percent(nutrition.fatPercent, locale),
          label: locale.calendar_fat,
          value: _gramValue(fat100g, locale),
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsMacroEntity(
          percent: _percent(nutrition.proteinPercent, locale),
          label: locale.calendar_protein,
          value: _gramValue(protein100g, locale),
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsMacroEntity(
          percent: _percent(nutrition.carbsPercent, locale),
          label: locale.calendar_carbs,
          value: _gramValue(carbs100g, locale),
          type: MealDetailsNutritionType.carbs,
        ),
      ],
      allergensTitle: locale.meal_details_allergens,
      allergens: _resolveAllergens(meal.allergens, localeName),
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

  static List<MealDetailsIngredientEntity> _fallbackIngredients(
    String localeName,
  ) {
    final isAr = localeName == 'ar';
    return [
      MealDetailsIngredientEntity(
        label: isAr ? 'دجاج مشوي' : 'Grilled Chicken',
        asset: AssetsFake.ingredientChicken,
        weight: isAr ? '120 جم' : '120g',
      ),
      MealDetailsIngredientEntity(
        label: isAr ? 'أرز بني' : 'Brown Rice',
        asset: AssetsFake.ingredientRice,
        weight: isAr ? '80 جم' : '80g',
      ),
      MealDetailsIngredientEntity(
        label: isAr ? 'جزر' : 'Carrot',
        asset: AssetsFake.ingredientCarrot,
        weight: isAr ? '50 جم' : '50g',
      ),
      MealDetailsIngredientEntity(
        label: isAr ? 'بروكلي' : 'Broccoli',
        asset: AssetsFake.ingredientBroccoli,
        weight: isAr ? '60 جم' : '60g',
      ),
      MealDetailsIngredientEntity(
        label: isAr ? 'خس' : 'Lettuce',
        asset: AssetsFake.ingredientLettuce,
        weight: isAr ? '30 جم' : '30g',
      ),
      MealDetailsIngredientEntity(
        label: isAr ? 'ليمون' : 'Lemon',
        asset: AssetsFake.ingredientLemon,
        weight: isAr ? '10 جم' : '10g',
      ),
    ];
  }

  static List<MealDetailsAllergenEntity> _resolveAllergens(
    List<SubscriptionMealAllergenDetailsEntity> allergens,
    String localeName,
  ) {
    final mapped = allergens
        .map(
          (allergen) => MealDetailsAllergenEntity(
            label: allergen.name(localeName),
            type: _allergenType(allergen.type),
          ),
        )
        .where((allergen) => allergen.label.isNotEmpty)
        .toList();

    if (mapped.isNotEmpty) return mapped;

    final isAr = localeName == 'ar';
    return [
      MealDetailsAllergenEntity(
        label: isAr ? 'جلوتين' : 'Gluten',
        type: MealDetailsAllergenType.gluten,
      ),
      MealDetailsAllergenEntity(
        label: isAr ? 'لاكتوز' : 'Lactose',
        type: MealDetailsAllergenType.lactose,
      ),
      MealDetailsAllergenEntity(
        label: isAr ? 'مكسرات' : 'Nuts',
        type: MealDetailsAllergenType.nuts,
      ),
    ];
  }

  static String _resolveIngredientAsset(String name, String category) {
    final lower = name.toLowerCase();
    if (name.contains('دجاج') ||
        lower.contains('chicken') ||
        category.toLowerCase() == 'poultry') {
      return AssetsFake.ingredientChicken;
    }
    if (name.contains('أرز') ||
        name.contains('ارز') ||
        lower.contains('rice') ||
        category.toLowerCase() == 'grains') {
      return AssetsFake.ingredientRice;
    }
    if (name.contains('جزر') || lower.contains('carrot')) {
      return AssetsFake.ingredientCarrot;
    }
    if (name.contains('بروكلي') || lower.contains('broccoli')) {
      return AssetsFake.ingredientBroccoli;
    }
    if (name.contains('خس') || lower.contains('lettuce')) {
      return AssetsFake.ingredientLettuce;
    }
    if (name.contains('ليمون') || lower.contains('lemon')) {
      return AssetsFake.ingredientLemon;
    }
    return switch (category.toLowerCase()) {
      'poultry' => AssetsFake.ingredientChicken,
      'grains' => AssetsFake.ingredientRice,
      _ => AssetsFake.ingredientBroccoli,
    };
  }

  static String _ingredientWeight(String nameAr, String localeName) {
    final isAr = localeName == 'ar';
    if (nameAr.contains('دجاج')) return isAr ? '120 جم' : '120g';
    if (nameAr.contains('أرز') || nameAr.contains('ارز')) {
      return isAr ? '80 جم' : '80g';
    }
    if (nameAr.contains('بروكلي')) return isAr ? '60 جم' : '60g';
    if (nameAr.contains('جزر')) return isAr ? '50 جم' : '50g';
    if (nameAr.contains('خس')) return isAr ? '30 جم' : '30g';
    if (nameAr.contains('ليمون')) return isAr ? '10 جم' : '10g';
    return isAr ? '50 جم' : '50g';
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
