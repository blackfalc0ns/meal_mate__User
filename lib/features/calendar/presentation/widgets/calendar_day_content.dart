import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_frozen_day_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';

class CalendarDayContent extends StatelessWidget {
  const CalendarDayContent({
    super.key,
    required this.selectedDay,
    required this.showBottomSpace,
    required this.onSelectRestaurant,
    required this.onChangeMeal,
    required this.onMealTap,
  });
  final CalendarDayEntity? selectedDay;
  final bool showBottomSpace;
  final VoidCallback onSelectRestaurant;
  final VoidCallback onChangeMeal;
  final void Function(CalendarMealEntity, CalendarRestaurantEntity?) onMealTap;
  @override
  Widget build(BuildContext context) {
    final restaurant = selectedDay?.restaurant;
    final meals = selectedDay?.meals ?? const [];
    final selectedMeals = meals.where((meal) => meal.selected).toList();
    final readOnly = selectedDay?.isEditable != true;
    final hasMeals = meals.isNotEmpty;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsetsDirectional.only(
        start: Spacing.screenH,
        end: Spacing.screenH,
        top: hasMeals ? Spacing.xxxl : Spacing.base,
        bottom: showBottomSpace
            ? Spacing.bottomNavHeight + Spacing.xxxl + Spacing.md
            : Spacing.xl,
      ),
      child: Column(
        children: [
          if (selectedDay?.isFrozen == true)
            const CalendarFrozenDayState()
          else if (!hasMeals)
            CalendarEmptyMealsState(
              onAddMeals: readOnly ? null : () => onSelectRestaurant(),
            )
          else ...[
            if (restaurant != null) ...[
              CalendarRestaurantSummaryCard(
                key: ValueKey(
                  '${selectedDay?.date?.toIso8601String() ?? ''}'
                  '-${_mealsSignature(selectedMeals)}',
                ),
                restaurant: restaurant,
                day: selectedDay,
                onMorePressed: readOnly ? null : () => onSelectRestaurant(),
              ),
              const SizedBox(height: Spacing.xl),
            ],
            for (final meal in meals) ...[
              CalendarMealCard(
                meal: meal,
                readOnly: readOnly,
                onTap: () => onMealTap(meal, restaurant),
                onChangeMeal: onChangeMeal,
              ),
              const SizedBox(height: Spacing.md),
            ],
          ],
        ],
      ),
    );
  }

  String _mealsSignature(List<CalendarMealEntity> meals) {
    return meals
        .map(
          (meal) =>
              '${meal.id}:${meal.protein}:${meal.carbs}:${meal.fat}:${meal.calories}',
        )
        .join('|');
  }
}
