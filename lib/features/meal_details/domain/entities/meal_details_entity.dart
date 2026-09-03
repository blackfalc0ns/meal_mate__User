class MealDetailsEntity {
  const MealDetailsEntity({
    required this.title,
    required this.description,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.ratingTitle,
    required this.ratingValue,
    required this.programLabel,
    required this.programValue,
    required this.deliveryLabel,
    required this.deliveryValue,
    required this.ingredientsTitle,
    required this.ingredients,
    required this.nutritionTitle,
    required this.nutritionItems,
    required this.macroDistributionTitle,
    required this.macroItems,
    required this.allergensTitle,
    required this.allergens,
    this.headerImageUrl,
    this.restaurantLogoUrl,
    this.onSelectMeal,
  });

  final String title;
  final String description;
  final String restaurantName;
  final String restaurantLogo;
  final String? headerImageUrl;
  final String? restaurantLogoUrl;
  final String ratingTitle;
  final String ratingValue;
  final String programLabel;
  final String programValue;
  final String deliveryLabel;
  final String deliveryValue;
  final String ingredientsTitle;
  final List<MealDetailsIngredientEntity> ingredients;
  final String nutritionTitle;
  final List<MealDetailsNutritionEntity> nutritionItems;
  final String macroDistributionTitle;
  final List<MealDetailsMacroEntity> macroItems;
  final String allergensTitle;
  final List<MealDetailsAllergenEntity> allergens;
  final void Function()? onSelectMeal;
}

class MealDetailsIngredientEntity {
  const MealDetailsIngredientEntity({
    required this.label,
    required this.asset,
    this.iconUrl,
  });

  final String label;
  final String asset;
  final String? iconUrl;
}

class MealDetailsNutritionEntity {
  const MealDetailsNutritionEntity({
    required this.value,
    required this.label,
    required this.type,
  });

  final String value;
  final String label;
  final MealDetailsNutritionType type;
}

class MealDetailsMacroEntity {
  const MealDetailsMacroEntity({
    required this.percent,
    required this.label,
    required this.value,
    required this.type,
  });

  final String percent;
  final String label;
  final String value;
  final MealDetailsNutritionType type;
}

class MealDetailsAllergenEntity {
  const MealDetailsAllergenEntity({required this.label, required this.type});

  final String label;
  final MealDetailsAllergenType type;
}

enum MealDetailsNutritionType { fiber, protein, carbs, fat, calories }

enum MealDetailsAllergenType { nuts, lactose, gluten }
