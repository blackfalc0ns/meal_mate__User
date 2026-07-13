part of 'calendar_meal_picker_sheet.dart';

class _MealIngredientRow extends StatelessWidget {
  const _MealIngredientRow();

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final ingredients = [
      locale.calendar_grilled_chicken,
      locale.calendar_brown_rice,
      locale.calendar_broccoli,
      locale.calendar_carrot,
      locale.calendar_more,
    ];

    return FittedBox(
      alignment: Alignment.centerRight,
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (final ingredient in ingredients) ...[
            _IngredientChip(label: ingredient),
            const SizedBox(width: 3.5),
          ],
        ],
      ),
    );
  }
}
