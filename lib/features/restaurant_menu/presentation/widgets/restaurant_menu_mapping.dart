part of 'restaurant_menu_view.dart';

List<RestaurantMenuOption> _optionsFromGroup(
  SubscriptionRestaurantMealGroupEntity group,
  String localeName,
  String moreLabel,
) {
  return group.meals.map((meal) {
    final ingredients = meal.ingredients
        .map(
          (ingredient) => CalendarMealIngredientEntity(
            label: ingredient.name(localeName),
            asset: _ingredientAsset(ingredient.category),
            iconUrl: ingredient.iconUrl,
          ),
        )
        .where((ingredient) => ingredient.label.isNotEmpty)
        .toList();
    final visibleIngredients = _visibleIngredients(ingredients, moreLabel);

    return (
      id: meal.mealId,
      slot: group.name(localeName),
      title: meal.name(localeName),
      imageAsset: Assets.calendarMealPickerHero,
      imageUrl: meal.imageUrl,
      calories: meal.calories?.toString() ?? '',
      protein: meal.proteinG?.toString() ?? '',
      carbs: meal.carbsG?.toString() ?? '',
      fat: meal.fatG?.toString() ?? '',
      ingredients: visibleIngredients,
      selected: false,
      blockReason: null,
    );
  }).toList();
}

List<RestaurantMenuOption> _optionsFromAvailableMeals(
  List<CalendarMealEntity> meals,
  String slot,
  String moreLabel,
  List<String> selectedMealIds,
) {
  return meals
      .where((meal) => meal.slot.toLowerCase() == slot.toLowerCase())
      .map((meal) {
        final visibleIngredients = _visibleIngredients(
          meal.ingredients,
          moreLabel,
        );

        return (
          id: meal.id,
          slot: meal.slot,
          title: meal.title,
          imageAsset: Assets.calendarMealPickerHero,
          imageUrl: meal.imageUrl,
          calories: meal.calories,
          protein: meal.protein,
          carbs: meal.carbs,
          fat: meal.fat,
          ingredients: visibleIngredients,
          selected: selectedMealIds.contains(meal.id),
          blockReason: meal.blockReason,
        );
      })
      .toList();
}

List<MealDetailsMacroEntity> _macroItems(
  SubscriptionRestaurantMealEntity meal,
  String localeName,
  AppLocalizations locale,
) {
  final fatCalories = (meal.fatG ?? 0) * 9;
  final proteinCalories = (meal.proteinG ?? 0) * 4;
  final carbsCalories = (meal.carbsG ?? 0) * 4;
  final total = fatCalories + proteinCalories + carbsCalories;

  return [
    MealDetailsMacroEntity(
      percent: _percent(fatCalories, total),
      label: locale.calendar_fat,
      value: _gramValue(meal.fatG, localeName),
      type: MealDetailsNutritionType.fat,
    ),
    MealDetailsMacroEntity(
      percent: _percent(proteinCalories, total),
      label: locale.calendar_protein,
      value: _gramValue(meal.proteinG, localeName),
      type: MealDetailsNutritionType.protein,
    ),
    MealDetailsMacroEntity(
      percent: _percent(carbsCalories, total),
      label: locale.calendar_carbs,
      value: _gramValue(meal.carbsG, localeName),
      type: MealDetailsNutritionType.carbs,
    ),
  ];
}

String _percent(int value, int total) {
  if (total == 0) return '-';
  return '%${((value / total) * 100).round()}';
}

String _gramValue(int? value, String localeName) {
  if (value == null) return '-';
  return localeName == 'ar' ? '$value جم' : '${value}g';
}

String _ingredientAsset(String category) {
  return Assets.calendarMealPickerHero;
}

List<CalendarMealIngredientEntity> _visibleIngredients(
  List<CalendarMealIngredientEntity> ingredients,
  String moreLabel,
) {
  if (ingredients.length <= 4) return ingredients;
  return [
    ...ingredients.take(4),
    CalendarMealIngredientEntity(
      label: moreLabel,
      asset: Assets.calendarMealPickerHero,
    ),
  ];
}
