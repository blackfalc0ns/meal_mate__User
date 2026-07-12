class CalendarMealEntity {
  const CalendarMealEntity({
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

  final String mealType;
  final String title;
  final String time;
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  final List<String> ingredients;
  final String imageAsset;
  final String actionLabel;
}
