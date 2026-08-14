class SubscriptionRestaurantDetailsEntity {
  const SubscriptionRestaurantDetailsEntity({
    required this.restaurantId,
    required this.nameAr,
    required this.nameEn,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.ingredientOrigins,
    required this.mealGroups,
  });

  final String restaurantId;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final String? coverImageUrl;
  final List<SubscriptionRestaurantIngredientOriginEntity> ingredientOrigins;
  final List<SubscriptionRestaurantMealGroupEntity> mealGroups;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionRestaurantIngredientOriginEntity {
  const SubscriptionRestaurantIngredientOriginEntity({
    required this.category,
    required this.nameAr,
    required this.nameEn,
    required this.isLocal,
    required this.sourceAr,
    required this.sourceEn,
    required this.originCountryCode,
    required this.originCountryNameAr,
    required this.originCountryNameEn,
    required this.flagEmoji,
    required this.iconUrl,
  });

  final String category;
  final String nameAr;
  final String nameEn;
  final bool isLocal;
  final String sourceAr;
  final String sourceEn;
  final String originCountryCode;
  final String originCountryNameAr;
  final String originCountryNameEn;
  final String flagEmoji;
  final String? iconUrl;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
  String source(String localeName) => localeName == 'ar' ? sourceAr : sourceEn;
  String originCountryName(String localeName) =>
      localeName == 'ar' ? originCountryNameAr : originCountryNameEn;
}

class SubscriptionRestaurantMealGroupEntity {
  const SubscriptionRestaurantMealGroupEntity({
    required this.slot,
    required this.nameAr,
    required this.nameEn,
    required this.meals,
  });

  final String slot;
  final String nameAr;
  final String nameEn;
  final List<SubscriptionRestaurantMealEntity> meals;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionRestaurantMealEntity {
  const SubscriptionRestaurantMealEntity({
    required this.mealId,
    required this.nameAr,
    required this.nameEn,
    required this.imageUrl,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.ingredients,
  });

  final String mealId;
  final String nameAr;
  final String nameEn;
  final String? imageUrl;
  final int? calories;
  final int? proteinG;
  final int? carbsG;
  final int? fatG;
  final List<SubscriptionRestaurantMealIngredientEntity> ingredients;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;
}

class SubscriptionRestaurantMealIngredientEntity {
  const SubscriptionRestaurantMealIngredientEntity({
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
