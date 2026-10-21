import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
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
    required this.onRetryCalendar,
    required this.onChooseMeals,
    required this.onEditMeal,
  });

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

    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({
        List<CalendarMealEntity> meals,
        String restaurantName,
        bool isEditable,
        bool canEditMealsAndDays,
        bool canUnitExchange,
        bool isLoadingCalendar,
        bool hasCalendarData,
        Failure? calendarFailure,
      })
    >(
      selector: (state) => (
        meals: state.selectedDay?.meals ?? const [],
        restaurantName: state.selectedDay?.restaurant?.name ?? '',
        isEditable: state.selectedDay?.isEditable == true,
        canEditMealsAndDays: state.canEditMealsAndDays,
        canUnitExchange: state.canUnitExchange,
        isLoadingCalendar: state.isLoadingCalendar,
        hasCalendarData: state.hasCalendarData,
        calendarFailure: state.calendarFailure,
      ),
      builder: (context, data) {
        final (
          :meals,
          :restaurantName,
          :isEditable,
          :canEditMealsAndDays,
          :canUnitExchange,
          :isLoadingCalendar,
          :hasCalendarData,
          :calendarFailure,
        ) = data;
        if (isLoadingCalendar && !hasCalendarData) {
          return const FamilyDayMealsLoadingSkeleton();
        }

        if (calendarFailure != null && !hasCalendarData) {
          return ApiErrorWidget(
            exception: calendarFailure.exception,
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
      },
    );
  }
}
