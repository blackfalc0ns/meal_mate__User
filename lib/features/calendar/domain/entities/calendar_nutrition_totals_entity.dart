class CalendarNutritionTotalsEntity {
  const CalendarNutritionTotalsEntity({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.proteinPercentage,
    this.carbsPercentage,
    this.fatPercentage,
  });

  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final double? proteinPercentage;
  final double? carbsPercentage;
  final double? fatPercentage;
}
