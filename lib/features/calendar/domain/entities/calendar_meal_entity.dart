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
