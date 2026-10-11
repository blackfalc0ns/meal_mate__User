class FoodPreferencesEntity {
  const FoodPreferencesEntity({
    this.dietaryPattern,
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.dislikedFoods = const [],
    this.notes,
    this.allergiesCompletedAtUtc,
    this.dietaryPreferencesCompletedAtUtc,
    this.hasNoAllergies = false,
    this.hasNoDietaryRestriction = false,
  });

  final String? dietaryPattern;
  final List<FoodPreferenceItemEntity> dietaryPreferences;
  final List<FoodPreferenceItemEntity> allergies;
  final List<FoodPreferenceItemEntity> dislikedFoods;
  final String? notes;
  final DateTime? allergiesCompletedAtUtc;
  final DateTime? dietaryPreferencesCompletedAtUtc;
  final bool hasNoAllergies;
  final bool hasNoDietaryRestriction;

  bool get isAllergiesConfirmed =>
      allergies.isNotEmpty || allergiesCompletedAtUtc != null || hasNoAllergies;

  bool get isDietaryPreferencesConfirmed =>
      dietaryPreferences.isNotEmpty ||
      dietaryPreferencesCompletedAtUtc != null ||
      hasNoDietaryRestriction;
}

class FoodPreferenceItemEntity {
  const FoodPreferenceItemEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.severity,
  });

  static const String noneCode = 'NONE';

  final String code;
  final String nameAr;
  final String nameEn;
  final String? severity;
}
