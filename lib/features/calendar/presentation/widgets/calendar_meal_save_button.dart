import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarMealSaveButton extends StatelessWidget {
  const CalendarMealSaveButton({super.key, required this.controller});
  final RoundedLoadingButtonController controller;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      CalendarViewModel,
      CalendarState,
      ({bool canSave, bool isSaving})
    >(
      selector: (state) =>
          (canSave: state.canSaveMeals, isSaving: state.isSaving || state.isConfirming),
      builder: (context, buttonState) {
        final color = context.colorScheme;
        final locale = context.localization;
        return LayoutBuilder(
          builder: (context, constraints) {
            return RoundedLoadingButton(
              controller: controller,
              onPressed: buttonState.canSave && !buttonState.isSaving
                  ? () {
                      context.read<CalendarViewModel>().doIntent(
                        ConfirmCalendarDayMealsEvent(
                          localeName: locale.localeName,
                        ),
                      );
                    }
                  : null,
              animateOnTap: false,
              resetAfterDuration: false,
              height: Spacing.buttonHeight,
              width: constraints.maxWidth,
              borderRadius: Spacing.buttonRadius,
              elevation: 0,
              color: color.primary,
              successColor: color.primary,
              disabledColor: color.outlineVariant,
              valueColor: color.onPrimary,
              child: Text(
                locale.calendar_confirm_meals,
                locale: Locale(locale.localeName),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.onPrimary,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
