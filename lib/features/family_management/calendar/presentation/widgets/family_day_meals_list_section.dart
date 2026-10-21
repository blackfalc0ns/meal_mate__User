import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_day_details_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meal_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_meals_loading_skeleton.dart';

class FamilyDayMealsListSection extends StatelessWidget {
  const FamilyDayMealsListSection({
    super.key,
    required this.meals,
    required this.restaurantName,
    required this.isEditable,
    required this.canEditMealsAndDays,
    required this.canUnitExchange,
    required this.isLoadingCalendar,
    required this.hasCalendarData,
    this.calendarFailure,
    required this.onRetryCalendar,
    required this.onChooseMeals,
    required this.onEditMeal,
  });

  final List<CalendarMealEntity> meals;
  final String restaurantName;
  final bool isEditable;
  final bool canEditMealsAndDays;
  final bool canUnitExchange;
  final bool isLoadingCalendar;
  final bool hasCalendarData;
  final Failure? calendarFailure;
  final VoidCallback onRetryCalendar;
  final VoidCallback onChooseMeals;
  final ValueChanged<String> onEditMeal;

  FamilyDayMealIconType _mapSlotToIconType(String slot) {
    return switch (slot.toLowerCase().trim()) {
      'breakfast' || 'إفطار' || 'فطور' => FamilyDayMealIconType.breakfast,
      'lunch' || 'غداء' => FamilyDayMealIconType.lunch,
      'dinner' || 'عشاء' => FamilyDayMealIconType.dinner,
      _ => FamilyDayMealIconType.snack,
    };
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    if (isLoadingCalendar && !hasCalendarData) {
      return const FamilyDayMealsLoadingSkeleton();
    }

    if (calendarFailure != null && !hasCalendarData) {
      return ApiErrorWidget(
        exception: calendarFailure!.exception,
        onRetry: onRetryCalendar,
      );
    }

    if (meals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
        child: FamilyDayMealCard(
          meal: FamilyDayMealEntity(
            mealType: locale.calendar_title,
            restaurantName: restaurantName,
            mealName: locale.family_member_choose_meal,
            actionLabel: locale.family_review_edit_button,
            imageAsset: Assets.profileBillingPlanBottle,
            iconType: FamilyDayMealIconType.lunch,
            isEmpty: true,
          ),
          onEditPressed: (isEditable && canEditMealsAndDays)
              ? onChooseMeals
              : null,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final meal in meals) ...[
          FamilyDayMealCard(
            meal: FamilyDayMealEntity(
              mealType: meal.mealType.isNotEmpty
                  ? meal.mealType
                  : (meal.slot.isNotEmpty ? meal.slot : ''),
              restaurantName: restaurantName,
              mealName: meal.title,
              actionLabel: locale.family_review_edit_button,
              imageAsset: meal.imageAsset,
              imageUrl: meal.imageUrl,
              iconType: _mapSlotToIconType(meal.slot),
              calories: meal.calories,
              carbs: meal.carbs,
              protein: meal.protein,
              fat: meal.fat,
            ),
            onEditPressed: (isEditable && canUnitExchange)
                ? () => onEditMeal(
                    meal.slot.isNotEmpty ? meal.slot : meal.mealType,
                  )
                : null,
          ),
          const SizedBox(height: Spacing.familyDayMealListGap),
        ],
      ],
    );
  }
}
