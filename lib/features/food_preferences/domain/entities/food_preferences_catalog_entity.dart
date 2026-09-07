class FoodPreferencesCatalogEntity {
  const FoodPreferencesCatalogEntity({
    this.ingredients = const [],
    this.allergens = const [],
    this.dietaryPreferences = const [],
  });

  final List<FoodPreferenceCatalogItemEntity> ingredients;
  final List<FoodPreferenceCatalogItemEntity> allergens;
  final List<FoodPreferenceCatalogItemEntity> dietaryPreferences;
}

class FoodPreferenceCatalogItemEntity {
  const FoodPreferenceCatalogItemEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.category,
    this.allergenCodes = const [],
  });

  final String code;
  final String nameAr;
  final String nameEn;
  final String? category;
  final List<String> allergenCodes;

  String name(String localeName) {
    if (localeName.startsWith('ar')) return nameAr.isNotEmpty ? nameAr : nameEn;
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }
}
