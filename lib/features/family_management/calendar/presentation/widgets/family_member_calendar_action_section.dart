import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_deadline_builder.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
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
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({CalendarDayEntity? day, bool canView, bool canEdit})
    >(
      selector: (state) => (
        day: state.selectedDay,
        canView: state.canViewCalendar,
        canEdit: state.canEditMealsAndDays,
      ),
      builder: (context, data) => CalendarDeadlineBuilder(
        day: data.day,
        builder: (context) => Column(
          children: [
            if (data.day?.hasOperationalRestriction == true)
              Text(
                locale.calendar_operational_deadline_passed_generic,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurfaceVariant,
                ),
              ),
            FamilyMemberCalendarPrimaryAction(
              hasMeals: hasMeals,
              canEdit: hasMeals
                  ? data.canView
                  : data.canEdit && data.day?.isEditable == true,
              onChooseMeals: onChooseMeals,
              onShowDetails: onShowDetails,
            ),
          ],
        ),
      ),
    );
  }
}
