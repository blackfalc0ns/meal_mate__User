class SubscriptionMealDetailsEntity {
  const SubscriptionMealDetailsEntity({
    required this.mealId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.imageUrl,
    required this.slot,
    required this.slotNameAr,
    required this.slotNameEn,
    required this.restaurantId,
    required this.restaurantNameAr,
    required this.restaurantNameEn,
    required this.restaurantLogoUrl,
    required this.restaurantRating,
    required this.restaurantRatingCount,
    required this.deliveryWindowStart,
    required this.deliveryWindowEnd,
    required this.ingredients,
    required this.nutrition,
    required this.allergens,
  });

  final String mealId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? imageUrl;
  final String slot;
  final String slotNameAr;
  final String slotNameEn;
  final String restaurantId;
  final String restaurantNameAr;
  final String restaurantNameEn;
  final String? restaurantLogoUrl;
  final double? restaurantRating;
  final int restaurantRatingCount;
  final String? deliveryWindowStart;
  final String? deliveryWindowEnd;
  final List<SubscriptionMealIngredientDetailsEntity> ingredients;
  final SubscriptionMealNutritionDetailsEntity nutrition;
  final List<SubscriptionMealAllergenDetailsEntity> allergens;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
  String description(String localeName) =>
      localeName == 'ar' ? descriptionAr : descriptionEn;
  String slotName(String localeName) =>
      localeName == 'ar' ? slotNameAr : slotNameEn;
  String restaurantName(String localeName) =>
      localeName == 'ar' ? restaurantNameAr : restaurantNameEn;
}

class SubscriptionMealIngredientDetailsEntity {
  const SubscriptionMealIngredientDetailsEntity({
    required this.ingredientId,
    required this.nameAr,
    required this.nameEn,
    required this.category,
    required this.isCore,
    required this.iconUrl,
  });

  final String ingredientId;
  final String nameAr;
  final String nameEn;
  final String category;
  final bool isCore;
  final String? iconUrl;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionMealNutritionDetailsEntity {
  const SubscriptionMealNutritionDetailsEntity({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.carbsPercent,
    required this.proteinPercent,
    required this.fatPercent,
  });

  final double? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final double? fiberG;
  final int? carbsPercent;
  final int? proteinPercent;
  final int? fatPercent;
}

class SubscriptionMealAllergenDetailsEntity {
  const SubscriptionMealAllergenDetailsEntity({
    required this.nameAr,
    required this.nameEn,
    required this.type,
  });

  final String nameAr;
  final String nameEn;
  final String type;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}
