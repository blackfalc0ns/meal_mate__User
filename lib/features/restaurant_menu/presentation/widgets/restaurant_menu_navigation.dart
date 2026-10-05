part of 'restaurant_menu_view.dart';

extension RestaurantMenuNavigation on RestaurantMenuMealsBodyState {
  void _openOptionDetails(RestaurantMenuOption option) {
    if (widget.onOptionDetails != null) {
      widget.onOptionDetails!(option);
      return;
    }

    final locale = context.localization;
    final menuData = widget.menuData;
    final restaurantName =
        menuData.restaurantName ?? locale.calendar_restaurant_name;
    final isOptionSelected =
        widget.isMealSelected?.call(option.id) ?? option.selected;
    final isBlocked = option.isBlocked;

    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.mealDetails,
        arguments: MealDetailsEntity(
          title: option.title,
          description: locale.search_meal_description,
          restaurantName: restaurantName,
          restaurantLogo:
              menuData.restaurantInitials ?? _initials(restaurantName),
          restaurantLogoUrl: menuData.restaurantLogoUrl,
          headerImageUrl: option.imageUrl,
          ratingTitle: locale.meal_details_restaurant_rating,
          ratingValue: menuData.restaurantRating ?? '',
          programLabel: locale.meal_details_meal_type,
          programValue: '',
          deliveryLabel: locale.meal_details_delivery_time,
          deliveryValue: '',
          ingredientsTitle: locale.calendar_ingredients,
          ingredients: option.ingredients
              .map(
                (ingredient) => MealDetailsIngredientEntity(
                  label: ingredient.label,
                  asset: Assets.calendarMealPickerHero,
                  iconUrl: ingredient.iconUrl,
                ),
              )
              .where((ingredient) => ingredient.label.isNotEmpty)
              .toList(),
          nutritionTitle: locale.meal_details_nutrition_facts,
          nutritionItems: [
            MealDetailsNutritionEntity(
              value: '-',
              label: locale.nutrition_details_fiber,
              type: MealDetailsNutritionType.fiber,
            ),
            MealDetailsNutritionEntity(
              value: option.protein.isNotEmpty
                  ? locale.meal_details_gram_value(option.protein)
                  : '-',
              label: locale.calendar_protein,
              type: MealDetailsNutritionType.protein,
            ),
            MealDetailsNutritionEntity(
              value: option.carbs.isNotEmpty
                  ? locale.meal_details_gram_value(option.carbs)
                  : '-',
              label: locale.calendar_carbs,
              type: MealDetailsNutritionType.carbs,
            ),
            MealDetailsNutritionEntity(
              value: option.fat.isNotEmpty
                  ? locale.meal_details_gram_value(option.fat)
                  : '-',
              label: locale.calendar_fat,
              type: MealDetailsNutritionType.fat,
            ),
            MealDetailsNutritionEntity(
              value: option.calories.isNotEmpty ? option.calories : '-',
              label: locale.calendar_calories,
              type: MealDetailsNutritionType.calories,
            ),
          ],
          macroDistributionTitle: locale.meal_details_macro_distribution,
          macroItems: const [],
          allergensTitle: locale.meal_details_allergens,
          allergens: const [],
          onSelectMeal:
              widget.mode == RestaurantMenuMode.selection &&
                  !isOptionSelected &&
                  !isBlocked &&
                  widget.onMealToggled != null
              ? () => widget.onMealToggled!(option.id)
              : null,
        ),
      ),
    );
  }

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
