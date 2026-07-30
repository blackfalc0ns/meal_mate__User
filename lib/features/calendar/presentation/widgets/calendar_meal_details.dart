part of 'calendar_meal_card.dart';

class CalendarMealDetails extends StatelessWidget {
  const CalendarMealDetails({super.key, required this.meal});

  final CalendarMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: CalendarMealTypeBadge(mealType: meal.mealType),
        ),
        const SizedBox(height: 1),
        Text(
          meal.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
         
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: 13,
            color: color.onSurface,
          ).copyWith(height: 1.15),
        ),
        const SizedBox(height: Spacing.xss),
        CalendarMealCardNutritionRow(meal: meal),
        const Spacer(),
        Text(
          locale.calendar_ingredients,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (final ingredient in meal.ingredients) ...[
              CalendarMealCardIngredientChip(label: ingredient),
              const SizedBox(width: 4.3),
            ],
          ],
        ),
      ],
    );
  }
}
