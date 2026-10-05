import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

abstract final class CalendarMealDetailsMapper {
  static MealDetailsEntity map({
    required CalendarMealEntity meal,
    required AppLocalizations locale,
    required String restaurantName,
    String? restaurantInitials,
    String? restaurantLogoUrl,
    String? headerImageUrl,
    String ratingValue = '',
    String deliveryWindow = '',
    String? description,
    VoidCallback? onSelectMeal,
  }) {
    final proteinG = _parseNullableInt(meal.protein);
    final carbsG = _parseNullableInt(meal.carbs);
    final fatG = _parseNullableInt(meal.fat);

    return MealDetailsEntity(
      title: meal.title,
      description:
          description ??
          (meal.description.isNotEmpty
              ? meal.description
              : locale.search_meal_description),
      restaurantName: restaurantName,
      restaurantLogo: restaurantInitials ?? _initials(restaurantName),
      restaurantLogoUrl: restaurantLogoUrl,
      headerImageUrl: headerImageUrl ?? meal.imageUrl,
      ratingTitle: locale.meal_details_restaurant_rating,
      ratingValue: ratingValue,
      programLabel: locale.meal_details_meal_type,
      programValue: meal.mealType,
      deliveryLabel: locale.meal_details_delivery_time,
      deliveryValue: deliveryWindow,
      tags: [
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
      ],
      ingredientsTitle: locale.calendar_ingredients,
      ingredients: meal.ingredients.isNotEmpty
          ? meal.ingredients
                .map(
                  (ingredient) => MealDetailsIngredientEntity(
                    label: ingredient.label,
                    asset: _resolveIngredientAsset(
                      ingredient.label,
                      ingredient.asset,
                    ),
                    iconUrl: ingredient.iconUrl,
                    weight: _ingredientWeight(
                      ingredient.label,
                      locale.localeName,
                    ),
                  ),
                )
                .where((ingredient) => ingredient.label.isNotEmpty)
                .toList()
          : _fallbackIngredients(locale.localeName),
      nutritionTitle: locale.meal_details_nutrition_facts,
      nutritionItems: [
        MealDetailsNutritionEntity(
          value: _gramValue(null, locale.localeName),
          label: locale.nutrition_details_fiber,
          type: MealDetailsNutritionType.fiber,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(proteinG, locale.localeName),
          label: locale.calendar_protein,
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(carbsG, locale.localeName),
          label: locale.calendar_carbs,
          type: MealDetailsNutritionType.carbs,
        ),
        MealDetailsNutritionEntity(
          value: _gramValue(fatG, locale.localeName),
          label: locale.calendar_fat,
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsNutritionEntity(
          value: meal.calories.isNotEmpty ? meal.calories : '-',
          label: locale.calendar_calories,
          type: MealDetailsNutritionType.calories,
        ),
      ],
      macroDistributionTitle: locale.meal_details_macro_distribution,
      macroItems: _macroItems(
        proteinG,
        carbsG,
        fatG,
        locale.localeName,
        locale,
        proteinPercentage: meal.proteinPercentage,
        carbsPercentage: meal.carbsPercentage,
        fatPercentage: meal.fatPercentage,
      ),
      allergensTitle: locale.meal_details_allergens,
      allergens: _mealDetailsAllergens(meal.allergens),
      onSelectMeal: onSelectMeal,
    );
  }

  static List<MealDetailsAllergenEntity> _mealDetailsAllergens(
    List<CalendarMealAllergenEntity> allergens,
  ) {
    final mapped = allergens
        .map(
          (allergen) => MealDetailsAllergenEntity(
            label: allergen.label,
            type: _allergenType(allergen.code),
          ),
        )
        .where((allergen) => allergen.label.isNotEmpty)
        .toList();

    if (mapped.isNotEmpty) return mapped;

    return const [
      MealDetailsAllergenEntity(
        label: 'جلوتين',
        type: MealDetailsAllergenType.gluten,
      ),
      MealDetailsAllergenEntity(
        label: 'لاكتوز',
        type: MealDetailsAllergenType.lactose,
      ),
      MealDetailsAllergenEntity(
        label: 'مكسرات',
        type: MealDetailsAllergenType.nuts,
      ),
    ];
  }

  static MealDetailsAllergenType _allergenType(String code) {
    final normalized = code.toUpperCase();
    if (normalized.contains('MILK') || normalized.contains('LACTOSE')) {
      return MealDetailsAllergenType.lactose;
    }
    if (normalized.contains('GLUTEN') || normalized.contains('WHEAT')) {
      return MealDetailsAllergenType.gluten;
    }
    return MealDetailsAllergenType.nuts;
  }

  static List<MealDetailsMacroEntity> _macroItems(
    int? proteinG,
    int? carbsG,
    int? fatG,
    String localeName,
    AppLocalizations locale, {
    double? proteinPercentage,
    double? carbsPercentage,
    double? fatPercentage,
  }) {
    final fatCalories = (fatG ?? 0) * 9;
    final proteinCalories = (proteinG ?? 0) * 4;
    final carbsCalories = (carbsG ?? 0) * 4;
    final total = fatCalories + proteinCalories + carbsCalories;

    final fatPercentStr = fatPercentage != null
        ? '%${fatPercentage.round()}'
        : _percent(fatCalories, total);
    final proteinPercentStr = proteinPercentage != null
        ? '%${proteinPercentage.round()}'
        : _percent(proteinCalories, total);
    final carbsPercentStr = carbsPercentage != null
        ? '%${carbsPercentage.round()}'
        : _percent(carbsCalories, total);

    return [
      MealDetailsMacroEntity(
        percent: fatPercentStr,
        label: locale.calendar_fat,
        value: _gramValue(fatG, localeName),
        type: MealDetailsNutritionType.fat,
      ),
      MealDetailsMacroEntity(
        percent: proteinPercentStr,
        label: locale.calendar_protein,
        value: _gramValue(proteinG, localeName),
        type: MealDetailsNutritionType.protein,
      ),
      MealDetailsMacroEntity(
        percent: carbsPercentStr,
        label: locale.calendar_carbs,
        value: _gramValue(carbsG, localeName),
        type: MealDetailsNutritionType.carbs,
      ),
    ];
  }

  static String _percent(int value, int total) {
    if (total == 0) return '-';
    return '%${((value / total) * 100).round()}';
  }

  static String _gramValue(int? value, String localeName) {
    if (value == null) return '-';
    return localeName == 'ar' ? '$value جم' : '${value}g';
  }

  static int? _parseNullableInt(String value) {
    if (value.isEmpty) return null;
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
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

  static String _resolveIngredientAsset(String name, String fallbackAsset) {
    final lower = name.toLowerCase();
    if (name.contains('دجاج') || lower.contains('chicken')) {
      return AssetsFake.ingredientChicken;
    }
    if (name.contains('أرز') ||
        name.contains('ارز') ||
        lower.contains('rice')) {
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
    return fallbackAsset;
  }

  static String _ingredientWeight(String name, String localeName) {
    final isAr = localeName == 'ar';
    if (name.contains('دجاج') || name.toLowerCase().contains('chicken')) {
      return isAr ? '120 جم' : '120g';
    }
    if (name.contains('أرز') ||
        name.contains('ارز') ||
        name.toLowerCase().contains('rice')) {
      return isAr ? '80 جم' : '80g';
    }
    if (name.contains('بروكلي') || name.toLowerCase().contains('broccoli')) {
      return isAr ? '60 جم' : '60g';
    }
    if (name.contains('جزر') || name.toLowerCase().contains('carrot')) {
      return isAr ? '50 جم' : '50g';
    }
    if (name.contains('خس') || name.toLowerCase().contains('lettuce')) {
      return isAr ? '30 جم' : '30g';
    }
    if (name.contains('ليمون') || name.toLowerCase().contains('lemon')) {
      return isAr ? '10 جم' : '10g';
    }
    return isAr ? '50 جم' : '50g';
  }

  static String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
