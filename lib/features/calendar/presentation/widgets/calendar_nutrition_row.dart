part of 'calendar_meal_card.dart';

class CalendarMealCardNutritionRow extends StatelessWidget {
  const CalendarMealCardNutritionRow({super.key, required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    return AppNutritionRow(
      calories: meal.calories,
      protein: meal.protein,
      carbs: meal.carbs,
      fat: meal.fat,
      order: NutritionOrder.caloriesProteinCarbsFat,
    );
  }
}
