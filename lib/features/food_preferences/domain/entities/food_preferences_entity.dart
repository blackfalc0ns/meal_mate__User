class FoodPreferencesEntity {
  const FoodPreferencesEntity({
    this.dietaryPattern,
    this.allergies = const [],
    this.dislikedFoods = const [],
    this.notes,
  });

  final String? dietaryPattern;
  final List<FoodPreferenceItemEntity> allergies;
  final List<FoodPreferenceItemEntity> dislikedFoods;
  final String? notes;
}

class FoodPreferenceItemEntity {
  const FoodPreferenceItemEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.severity,
  });

  final String code;
  final String nameAr;
  final String nameEn;
  final String? severity;
}
