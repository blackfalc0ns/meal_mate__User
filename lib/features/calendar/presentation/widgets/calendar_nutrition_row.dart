part of 'calendar_meal_card.dart';

class CalendarMealCardNutritionRow extends StatelessWidget {
  const CalendarMealCardNutritionRow({super.key, required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = [
      CalendarMealCardNutritionItem(
        icon: Icons.local_fire_department_rounded,
        animationAsset: Assets.fireAnimation,
        value: meal.calories,
        label: locale.calendar_calories,
      ),
      CalendarMealCardNutritionItem(
        icon: Icons.fitness_center_rounded,
        animationAsset: Assets.muscleAnimation,
        value: meal.protein,
        label: locale.calendar_protein,
      ),
      CalendarMealCardNutritionItem(
        icon: Icons.rice_bowl_rounded,
        animationAsset: Assets.wheatAnimation,
        value: meal.carbs,
        label: locale.calendar_carbs,
      ),
      CalendarMealCardNutritionItem(
        icon: Icons.water_drop_rounded,
        animationAsset: Assets.dropletAnimation,
        value: meal.fat,
        label: locale.calendar_fat,
      ),
    ];

    return SizedBox(
      height: 46,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Expanded(child: items[index]),
            if (index != items.length - 1)
              Container(
                width: 0.5,
                height: 32,
                color: color.onSurface.withValues(alpha: 0.20),
              ),
          ],
        ],
      ),
    );
  }
}
