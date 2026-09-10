class CalendarMealEntity {
  const CalendarMealEntity({
    this.id = '',
    this.slot = '',
    this.imageUrl,
    this.blockReason,
    this.selected = false,
    this.description = '',
    required this.mealType,
    required this.title,
    required this.time,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.imageAsset,
    required this.actionLabel,
    this.allergens = const [],
    this.proteinPercentage,
    this.carbsPercentage,
    this.fatPercentage,
  });

  final String id;
  final String slot;
  final String? imageUrl;
  final String? blockReason;
  final bool selected;
  final String description;
  final String mealType;
  final String title;
  final String time;
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  final List<CalendarMealIngredientEntity> ingredients;
  final String imageAsset;
  final String actionLabel;
  final List<CalendarMealAllergenEntity> allergens;
  final double? proteinPercentage;
  final double? carbsPercentage;
  final double? fatPercentage;

  CalendarMealEntity copyWith({
    String? id,
    String? slot,
    String? imageUrl,
    String? blockReason,
    bool? selected,
    String? description,
    String? mealType,
    String? title,
    String? time,
    String? calories,
    String? protein,
    String? carbs,
    String? fat,
    List<CalendarMealIngredientEntity>? ingredients,
    String? imageAsset,
    String? actionLabel,
    List<CalendarMealAllergenEntity>? allergens,
    double? proteinPercentage,
    double? carbsPercentage,
    double? fatPercentage,
  }) {
    return CalendarMealEntity(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      imageUrl: imageUrl ?? this.imageUrl,
      blockReason: blockReason ?? this.blockReason,
      selected: selected ?? this.selected,
      description: description ?? this.description,
      mealType: mealType ?? this.mealType,
      title: title ?? this.title,
      time: time ?? this.time,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      ingredients: ingredients ?? this.ingredients,
      imageAsset: imageAsset ?? this.imageAsset,
      actionLabel: actionLabel ?? this.actionLabel,
      allergens: allergens ?? this.allergens,
      proteinPercentage: proteinPercentage ?? this.proteinPercentage,
      carbsPercentage: carbsPercentage ?? this.carbsPercentage,
      fatPercentage: fatPercentage ?? this.fatPercentage,
    );
  }
}

class CalendarMealAllergenEntity {
  const CalendarMealAllergenEntity({required this.code, required this.label});

  final String code;
  final String label;
}

class CalendarMealIngredientEntity {
  const CalendarMealIngredientEntity({
    required this.label,
    required this.asset,
    this.iconUrl,
  });

  final String label;
  final String asset;
  final String? iconUrl;
}
