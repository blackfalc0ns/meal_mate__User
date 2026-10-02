part of 'restaurant_menu_view.dart';

extension RestaurantMenuNavigation on RestaurantMenuViewState {
  void _openOptionDetails(RestaurantMenuOption option) {
    if (widget.onOptionDetails != null) {
      widget.onOptionDetails!(option);
      return;
    }

    final locale = context.localization;
    final menuData = widget.menuData;
    final restaurantName =
        menuData.restaurantName ?? locale.calendar_restaurant_name;

    unawaited(
      Navigator.of(context).pushNamed(
      AppRoutes.mealDetails,
      arguments: MealDetailsEntity(
        title: option.title,
        description: locale.search_meal_description,
        restaurantName: restaurantName,
        restaurantLogo: menuData.restaurantInitials ?? _initials(restaurantName),
        restaurantLogoUrl: menuData.restaurantLogoUrl,
        headerImageUrl: option.imageUrl,
        ratingTitle: locale.localeName == 'ar'
            ? 'تقييم المطعم'
            : 'Restaurant rating',
        ratingValue: menuData.restaurantRating ?? '',
        programLabel: locale.localeName == 'ar'
            ? 'مناسبة لبرنامج'
            : 'Suitable for program',
        programValue: '',
        deliveryLabel: locale.localeName == 'ar'
            ? 'وقت التوصيل'
            : 'Delivery time',
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
        nutritionTitle: locale.localeName == 'ar'
            ? 'القيم الغذائية'
            : 'Nutrition facts',
        nutritionItems: [
          MealDetailsNutritionEntity(
            value: '-',
            label: locale.localeName == 'ar' ? 'ألياف' : 'Fiber',
            type: MealDetailsNutritionType.fiber,
          ),
          MealDetailsNutritionEntity(
            value: option.protein.isNotEmpty ? '${option.protein}g' : '-',
            label: locale.calendar_protein,
            type: MealDetailsNutritionType.protein,
          ),
          MealDetailsNutritionEntity(
            value: option.carbs.isNotEmpty ? '${option.carbs}g' : '-',
            label: locale.calendar_carbs,
            type: MealDetailsNutritionType.carbs,
          ),
          MealDetailsNutritionEntity(
            value: option.fat.isNotEmpty ? '${option.fat}g' : '-',
            label: locale.calendar_fat,
            type: MealDetailsNutritionType.fat,
          ),
          MealDetailsNutritionEntity(
            value: option.calories.isNotEmpty ? option.calories : '-',
            label: locale.calendar_calories,
            type: MealDetailsNutritionType.calories,
          ),
        ],
        macroDistributionTitle: locale.localeName == 'ar'
            ? 'توزيع العناصر الغذائية'
            : 'Macro distribution',
        macroItems: const [],
        allergensTitle: locale.localeName == 'ar'
            ? 'مسببات الحساسية'
            : 'Allergens',
        allergens: const [],
        onSelectMeal: widget.mode == RestaurantMenuMode.selection &&
                !option.selected &&
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
