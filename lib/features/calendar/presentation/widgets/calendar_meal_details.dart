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
            fontSize: FontSize.size13,
            color: color.onSurface,
          ).copyWith(height: 1.15),
        ),
        const SizedBox(height: Spacing.xss),
        CalendarMealCardNutritionRow(meal: meal),
        const SizedBox(height: Spacing.xs),
        Text(
          locale.calendar_ingredients,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurface,
          ),
        ),
        if (meal.ingredients.isNotEmpty) ...[
          const SizedBox(height: Spacing.xss),
          Wrap(
            spacing: Spacing.xs,
            runSpacing: Spacing.xss,
            children: [
              for (final ingredient in meal.ingredients)
                CalendarMealCardIngredientChip(ingredient: ingredient),
            ],
          ),
        ],
      ],
    );
  }
}
