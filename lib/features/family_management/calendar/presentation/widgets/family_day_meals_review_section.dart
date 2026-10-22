import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_deadline_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_selected_status.dart';

class FamilyDayMealsReviewSection extends StatelessWidget {
  const FamilyDayMealsReviewSection({super.key, required this.onReviewPressed});

  final VoidCallback? onReviewPressed;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({bool isEnabled, bool hasMeals, CalendarDayEntity? day})
    >(
      selector: (state) {
        final hasMeals = state.selectedDay?.meals.isNotEmpty == true;
        return (
          day: state.selectedDay,
          isEnabled: hasMeals && state.canConfirmMeals,
          hasMeals: hasMeals,
        );
      },
      builder: (context, data) => CalendarDeadlineBuilder(
        day: data.day,
        builder: (context) {
          final (:isEnabled, :hasMeals, :day) = data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FamilyDayReviewButton(
                label: locale.family_day_review_meals_button,
                onPressed: isEnabled && day?.isEditable == true
                    ? onReviewPressed
                    : null,
              ),
              const SizedBox(height: Spacing.familyDaySelectedTopGap),
              FamilyDaySelectedStatus(
                label: hasMeals
                    ? locale.family_day_all_meals_selected
                    : locale.family_member_no_meals_selected,
              ),
            ],
          );
        },
      ),
    );
  }
}
