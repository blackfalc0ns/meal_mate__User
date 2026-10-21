import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';

class FamilyMemberCalendarAppBarTitle extends StatelessWidget {
  const FamilyMemberCalendarAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocSelector<FamilyCalendarViewModel, FamilyCalendarState, String>(
      selector: (state) => state.displayName,
      builder: (context, displayName) {
        final screenTitle = displayName.isNotEmpty
            ? locale.family_member_calendar_title(displayName)
            : locale.calendar_title;
        return Text(
          screenTitle,
          locale: Locale(locale.localeName),
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size18,
            color: color.onSurface,
          ),
        );
      },
    );
  }
}
