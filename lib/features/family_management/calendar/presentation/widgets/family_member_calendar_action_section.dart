import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'family_member_calendar_primary_action.dart';

class FamilyMemberCalendarActionSection extends StatelessWidget {
  const FamilyMemberCalendarActionSection({
    super.key,
    required this.hasMeals,
    required this.onChooseMeals,
    required this.onShowDetails,
  });
  final bool hasMeals;
  final VoidCallback onChooseMeals;
  final VoidCallback onShowDetails;
  @override
  Widget build(BuildContext context) =>
      BlocSelector<FamilyCalendarViewModel, FamilyCalendarState, bool>(
        selector: (state) =>
            state.selectedDay?.isEditable == true &&
            (hasMeals ? state.canViewCalendar : state.canEditMealsAndDays),
        builder: (context, data) => FamilyMemberCalendarPrimaryAction(
          hasMeals: hasMeals,
          canEdit: data,
          onChooseMeals: onChooseMeals,
          onShowDetails: onShowDetails,
        ),
      );
}
