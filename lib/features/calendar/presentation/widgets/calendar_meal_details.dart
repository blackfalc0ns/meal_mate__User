part of 'calendar_meal_card.dart';

class _MealDetails extends StatelessWidget {
  const _MealDetails({required this.meal});

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
          child: _MealTypeBadge(mealType: meal.mealType),
        ),
        const SizedBox(height: 1),
        Text(
          meal.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: 14.5,
            color: color.onSurface,
          ).copyWith(height: 1.15),
        ),
        const SizedBox(height: Spacing.xss),
        _NutritionRow(meal: meal),
        const Spacer(),
        Text(
          locale.calendar_ingredients,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: 6.8,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (final ingredient in meal.ingredients) ...[
              _IngredientChip(label: ingredient),
              const SizedBox(width: 4.3),
            ],
          ],
        ),
      ],
    );
  }
}
