part of 'restaurant_menu_view.dart';

extension RestaurantMenuNavigation on RestaurantMenuMealsBodyState {
  void _openOptionDetails(RestaurantMenuOption option) {
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
          ingredients: option.ingredients.isNotEmpty
              ? option.ingredients
                    .map(
                      (ingredient) => MealDetailsIngredientEntity(
                        label: ingredient.label,
                        asset: _resolveIngredientAsset(ingredient.label),
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
          macroItems: [
            MealDetailsMacroEntity(
              percent: '25%',
              label: locale.calendar_fat,
              value: option.fat.isNotEmpty
                  ? locale.meal_details_gram_value(option.fat)
                  : '15 جم',
              type: MealDetailsNutritionType.fat,
            ),
            MealDetailsMacroEntity(
              percent: '30%',
              label: locale.calendar_protein,
              value: option.protein.isNotEmpty
                  ? locale.meal_details_gram_value(option.protein)
                  : '65 جم',
              type: MealDetailsNutritionType.protein,
            ),
            MealDetailsMacroEntity(
              percent: '%45',
              label: locale.calendar_carbs,
              value: option.carbs.isNotEmpty
                  ? locale.meal_details_gram_value(option.carbs)
                  : '60 جم',
              type: MealDetailsNutritionType.carbs,
            ),
          ],
          allergensTitle: locale.meal_details_allergens,
          allergens: [
            MealDetailsAllergenEntity(
              label: locale.localeName == 'ar' ? 'جلوتين' : 'Gluten',
              type: MealDetailsAllergenType.gluten,
            ),
            MealDetailsAllergenEntity(
              label: locale.localeName == 'ar' ? 'لاكتوز' : 'Lactose',
              type: MealDetailsAllergenType.lactose,
            ),
            MealDetailsAllergenEntity(
              label: locale.localeName == 'ar' ? 'مكسرات' : 'Nuts',
              type: MealDetailsAllergenType.nuts,
            ),
          ],
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

  static String _resolveIngredientAsset(String name) {
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
    return AssetsFake.ingredientBroccoli;
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

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}
