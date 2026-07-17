part of 'calendar_meal_card.dart';

class CalendarMealCardNutritionRow extends StatelessWidget {
  const CalendarMealCardNutritionRow({required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = [
      CalendarMealCardNutritionItem(
        icon: Icons.local_fire_department_rounded,
        value: meal.calories,
        label: locale.calendar_calories,
      ),
      CalendarMealCardNutritionItem(
        icon: Icons.fitness_center_rounded,
        value: meal.protein,
        label: locale.calendar_protein,
      ),
      CalendarMealCardNutritionItem(
        icon: Icons.rice_bowl_rounded,
        value: meal.carbs,
        label: locale.calendar_carbs,
      ),
      CalendarMealCardNutritionItem(
        icon: Icons.water_drop_rounded,
        value: meal.fat,
        label: locale.calendar_fat,
      ),
    ];

    return SizedBox(
      height: 26,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            items[index],
            if (index != items.length - 1)
              Container(
                width: 0.5,
                height: 24,
                color: color.onSurface.withValues(alpha: 0.20),
              ),
          ],
        ],
      ),
    );
  }
}
