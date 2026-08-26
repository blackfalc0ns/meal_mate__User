part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerNutritionRow extends StatelessWidget {
  const CalendarMealPickerNutritionRow({super.key, required this.option});

  final CalendarMealPickerOption option;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = [
      CalendarMealPickerNutrition(
        icon: Icons.local_fire_department_rounded,
        value: option.calories,
        label: locale.calendar_calories,
      ),
      CalendarMealPickerNutrition(
        icon: Icons.water_drop_outlined,
        value: option.protein,
        label: locale.calendar_protein,
      ),
      CalendarMealPickerNutrition(
        icon: Icons.grass_rounded,
        value: option.carbs,
        label: locale.calendar_carbs,
      ),
      CalendarMealPickerNutrition(
        icon: Icons.water_drop_rounded,
        value: option.fat,
        label: locale.calendar_fat,
      ),
    ];

    return SizedBox(
      height: 30,
      child: Row(
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
