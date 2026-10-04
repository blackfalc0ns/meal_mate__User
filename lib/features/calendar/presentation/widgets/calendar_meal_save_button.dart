import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarMealSaveButton extends StatelessWidget {
  const CalendarMealSaveButton({
    super.key,
    this.isLoading,
    this.enabled,
    this.onPressed,
    this.controller,
  });

  final bool? isLoading;
  final bool? enabled;
  final VoidCallback? onPressed;
  final RoundedLoadingButtonController? controller;

  @override
  Widget build(BuildContext context) {
    if (isLoading != null && enabled != null) {
      return _buildButton(
        context,
        isLoading: isLoading!,
        enabled: enabled!,
        onPressed: onPressed,
      );
    }

    return BlocSelector<
      MealSelectionCubit,
      MealSelectionState,
      ({bool loading, bool enabled})
    >(
      selector: (state) => (
        loading: state.isSaving || state.isConfirming,
        enabled: state.canSaveMeals && !state.isSaving && !state.isConfirming,
      ),
      builder: (context, buttonState) {
        return _buildButton(
          context,
          isLoading: buttonState.loading,
          enabled: buttonState.enabled,
          onPressed:
              onPressed ??
              () {
                final locale = context.localization;
                try {
                  unawaited(
                    context.read<CalendarFlowCubit>().confirmMeals(
                      localeName: locale.localeName,
                    ),
                  );
                } catch (_) {
                  unawaited(
                    context.read<MealSelectionCubit>().confirm(
                      localeName: locale.localeName,
                    ),
                  );
                }
              },
        );
      },
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required bool isLoading,
    required bool enabled,
    VoidCallback? onPressed,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: Spacing.buttonHeight,
          width: constraints.maxWidth,
          child: ElevatedButton(
            onPressed: enabled && !isLoading ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: color.primary,
              disabledBackgroundColor: color.outlineVariant,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Spacing.buttonRadius),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        color.onPrimary,
                      ),
                    ),
                  )
                : Text(
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
          ),
        );
      },
    );
  }
}
