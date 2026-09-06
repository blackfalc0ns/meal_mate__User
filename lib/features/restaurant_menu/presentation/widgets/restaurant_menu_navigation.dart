part of 'restaurant_menu_view.dart';

extension RestaurantMenuNavigation on RestaurantMenuViewState {
  void _openMealDetails(SubscriptionRestaurantMealEntity meal) {
    final locale = context.localization;
    final details = widget.details;
    final programId = widget.programId;
    final bundleId = widget.bundleId;
    final restaurantId = widget.restaurantId ?? details?.restaurantId;

    if (programId != null &&
        programId.isNotEmpty &&
        bundleId != null &&
        bundleId.isNotEmpty &&
        restaurantId != null &&
        restaurantId.isNotEmpty &&
        meal.mealId.isNotEmpty) {
      Navigator.of(context).pushNamed(
        AppRoutes.mealDetails,
        arguments: SubscriptionMealDetailsArgs(
          programId: programId,
          bundleId: bundleId,
          restaurantId: restaurantId,
          mealId: meal.mealId,
          restaurantInitials: widget.restaurantInitials,
          restaurantRating: widget.restaurantRating,
        ),
      );
      return;
    }

    final restaurantName =
        details?.name(locale.localeName) ??
        widget.restaurantName ??
        locale.calendar_restaurant_name;

    Navigator.of(context).pushNamed(
      AppRoutes.mealDetails,
      arguments: MealDetailsEntity(
        title: meal.name(locale.localeName),
        description: locale.search_meal_description,
        restaurantName: restaurantName,
        restaurantLogo: widget.restaurantInitials ?? _initials(restaurantName),
        restaurantLogoUrl: widget.restaurantLogoUrl ?? details?.logoUrl,
        headerImageUrl: meal.imageUrl ?? details?.coverImageUrl,
        ratingTitle: locale.localeName == 'ar'
            ? 'تقييم المطعم'
            : 'Restaurant rating',
        ratingValue: widget.restaurantRating ?? '',
        programLabel: locale.localeName == 'ar'
            ? 'مناسبة لبرنامج'
            : 'Suitable for program',
        programValue: '',
        deliveryLabel: locale.localeName == 'ar'
            ? 'وقت التوصيل'
            : 'Delivery time',
        deliveryValue: '',
        ingredientsTitle: locale.calendar_ingredients,
        ingredients: meal.ingredients
            .map(
              (ingredient) => MealDetailsIngredientEntity(
                label: ingredient.name(locale.localeName),
                asset: _ingredientAsset(ingredient.category),
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
            value: _gramValue(meal.proteinG, locale.localeName),
            label: locale.calendar_protein,
            type: MealDetailsNutritionType.protein,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(meal.carbsG, locale.localeName),
            label: locale.calendar_carbs,
            type: MealDetailsNutritionType.carbs,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(meal.fatG, locale.localeName),
            label: locale.calendar_fat,
            type: MealDetailsNutritionType.fat,
          ),
          MealDetailsNutritionEntity(
            value: meal.calories?.toString() ?? '-',
            label: locale.calendar_calories,
            type: MealDetailsNutritionType.calories,
          ),
        ],
        macroDistributionTitle: locale.localeName == 'ar'
            ? 'توزيع العناصر الغذائية'
            : 'Macro distribution',
        macroItems: _macroItems(meal, locale.localeName, locale),
        allergensTitle: locale.localeName == 'ar'
            ? 'مسببات الحساسية'
            : 'Allergens',
        allergens: const [],
      ),
    );
  }

  void _openMealDetailsForCalendarMeal(CalendarMealEntity meal) {
    final locale = context.localization;
    final details = widget.details;
    final availableMeals = widget.availableMeals;
    final restaurant = availableMeals?.restaurant;
    final isSelected = widget.selectedMealIds.contains(meal.id);
    final restaurantName =
        widget.restaurantName ??
        restaurant?.name ??
        details?.name(locale.localeName) ??
        locale.calendar_restaurant_name;

    Navigator.of(context).pushNamed(
      AppRoutes.mealDetails,
      arguments: CalendarMealDetailsMapper.map(
        meal: meal,
        locale: locale,
        restaurantName: restaurantName,
        restaurantInitials: widget.restaurantInitials,
        restaurantLogoUrl:
            widget.restaurantLogoUrl ?? restaurant?.logoUrl ?? details?.logoUrl,
        headerImageUrl: meal.imageUrl ?? details?.coverImageUrl,
        ratingValue: widget.restaurantRating ?? restaurant?.rating ?? '',
        deliveryWindow: restaurant?.deliveryWindow ?? '',
        description: locale.search_meal_description,
        onSelectMeal:
            widget.mode == RestaurantMenuMode.selection &&
                !isSelected &&
                widget.onMealToggled != null
            ? () => widget.onMealToggled!(meal.id)
            : null,
      ),
    );
  }

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
