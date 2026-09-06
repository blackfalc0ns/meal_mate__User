import 'package:flutter/material.dart';
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
      ratingTitle: locale.localeName == 'ar'
          ? 'تقييم المطعم'
          : 'Restaurant rating',
      ratingValue: ratingValue,
      programLabel: locale.localeName == 'ar' ? 'نوع الوجبة' : 'Meal type',
      programValue: meal.mealType,
      deliveryLabel: locale.localeName == 'ar'
          ? 'وقت التوصيل'
          : 'Delivery time',
      deliveryValue: deliveryWindow,
      ingredientsTitle: locale.calendar_ingredients,
      ingredients: meal.ingredients
          .map(
            (ingredient) => MealDetailsIngredientEntity(
              label: ingredient.label,
              asset: ingredient.asset,
              iconUrl: ingredient.iconUrl,
            ),
          )
          .where((ingredient) => ingredient.label.isNotEmpty)
          .toList(),
      nutritionTitle: locale.localeName == 'ar'
          ? 'القيم الغذائية'
          : 'Nutrition facts',
      nutritionItems: [
        MealDetailsNutritionEntity(
          value: _gramValue(null, locale.localeName),
          label: locale.localeName == 'ar' ? 'ألياف' : 'Fiber',
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
      macroDistributionTitle: locale.localeName == 'ar'
          ? 'توزيع العناصر الغذائية'
          : 'Macro distribution',
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
      allergensTitle: locale.localeName == 'ar'
          ? 'مسببات الحساسية'
          : 'Allergens',
      allergens: _mealDetailsAllergens(meal.allergens),
      onSelectMeal: onSelectMeal,
    );
  }

  static List<MealDetailsAllergenEntity> _mealDetailsAllergens(
    List<CalendarMealAllergenEntity> allergens,
  ) {
    return allergens
        .map(
          (allergen) => MealDetailsAllergenEntity(
            label: allergen.label,
            type: _allergenType(allergen.code),
          ),
        )
        .where((allergen) => allergen.label.isNotEmpty)
        .toList();
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

  static String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
