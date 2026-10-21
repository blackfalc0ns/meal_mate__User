import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_member_calendar_entity.dart';
import 'family_member_selected_meals_card.dart';

class FamilyMemberSelectedMealsSection extends StatefulWidget {
  const FamilyMemberSelectedMealsSection({
    super.key,
    required this.meals,
    required this.selectedDate,
    required this.displayName,
  });
  final List<CalendarMealEntity> meals;
  final DateTime selectedDate;
  final String displayName;
  @override
  State<FamilyMemberSelectedMealsSection> createState() =>
      _FamilyMemberSelectedMealsSectionState();
}

class _FamilyMemberSelectedMealsSectionState
    extends State<FamilyMemberSelectedMealsSection> {
  List<CalendarMealEntity>? _sourceMeals;
  String? _localeName;
  List<FamilyCalendarSelectedMealEntity> _meals = const [];
  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    if (!identical(_sourceMeals, widget.meals) ||
        _localeName != locale.localeName) {
      _sourceMeals = widget.meals;
      _localeName = locale.localeName;
      _meals = widget.meals
          .map(
            (meal) => FamilyCalendarSelectedMealEntity(
              typeLabel: meal.slot.isNotEmpty
                  ? meal.mealType
                  : (meal.mealType.isNotEmpty
                        ? meal.mealType
                        : locale.calendar_title),
              name: meal.title,
              description: meal.calories.isNotEmpty
                  ? locale.family_member_calories_value(meal.calories)
                  : meal.description,
              chosenLabel: locale.family_member_meal_chosen,
              imageAsset: meal.imageAsset,
              imageUrl: meal.imageUrl,
            ),
          )
          .toList();
    }
    return FamilyMemberSelectedMealsCard(
      title: locale.family_member_selected_meals_title,
      subtitle: locale.family_member_selected_meals_subtitle(
        widget.displayName,
        intl.DateFormat.MMMMd(locale.localeName).format(widget.selectedDate),
      ),
      countLabel: locale.family_member_selected_meals_count(_meals.length),
      meals: _meals,
    );
  }
}
