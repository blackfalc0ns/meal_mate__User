part of 'calendar_meal_picker_sheet.dart';

class CalendarMealIngredientRow extends StatelessWidget {
  const CalendarMealIngredientRow({required this.ingredients});

  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (final ingredient in ingredients) ...[
            CalendarMealPickerIngredientChip(label: ingredient),
            const SizedBox(width: 3.5),
          ],
        ],
      ),
    );
  }
}
