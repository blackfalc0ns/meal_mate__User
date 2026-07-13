part of 'calendar_meal_card.dart';

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = [
      _NutritionItem(
        icon: Icons.local_fire_department_rounded,
        value: meal.calories,
        label: locale.calendar_calories,
      ),
      _NutritionItem(
        icon: Icons.fitness_center_rounded,
        value: meal.protein,
        label: locale.calendar_protein,
      ),
      _NutritionItem(
        icon: Icons.rice_bowl_rounded,
        value: meal.carbs,
        label: locale.calendar_carbs,
      ),
      _NutritionItem(
        icon: Icons.water_drop_rounded,
        value: meal.fat,
        label: locale.calendar_fat,
      ),
    ];

    return SizedBox(
      height: 22,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            items[index],
            if (index != items.length - 1)
              Container(
                width: 0.5,
                height: 20,
                color: color.onSurface.withValues(alpha: 0.20),
              ),
          ],
        ],
      ),
    );
  }
}
