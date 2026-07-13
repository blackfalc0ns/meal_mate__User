part of 'calendar_meal_picker_sheet.dart';

class _MealNutritionRow extends StatelessWidget {
  const _MealNutritionRow();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = [
      _MealNutrition(
        icon: Icons.local_fire_department_rounded,
        value: '550',
        label: locale.calendar_calories,
      ),
      _MealNutrition(
        icon: Icons.water_drop_outlined,
        value: '35 جم',
        label: locale.calendar_protein,
      ),
      _MealNutrition(
        icon: Icons.grass_rounded,
        value: '55 جم',
        label: locale.calendar_carbs,
      ),
      _MealNutrition(
        icon: Icons.water_drop_rounded,
        value: '18 جم',
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
              Container(width: 0.45, height: 18, color: color.outlineVariant),
          ],
        ],
      ),
    );
  }
}
