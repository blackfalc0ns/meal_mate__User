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
      ({bool isEnabled, bool hasMeals})
    >(
      selector: (state) {
        final hasMeals = state.selectedDay?.meals.isNotEmpty == true;
        return (
          isEnabled:
              state.selectedDay?.isEditable == true &&
              hasMeals &&
              state.canConfirmMeals,
          hasMeals: hasMeals,
        );
      },
      builder: (context, data) {
        final (:isEnabled, :hasMeals) = data;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FamilyDayReviewButton(
              label: locale.family_day_review_meals_button,
              onPressed: isEnabled ? onReviewPressed : null,
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
    );
  }
}
