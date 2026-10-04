import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_navigation_coordinator.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_effect.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/mapper/calendar_failure_message_mapper.dart';

class CalendarScreenEffects extends StatelessWidget {
  const CalendarScreenEffects({
    super.key,
    required this.child,
    this.coordinator,
  });

  final Widget child;
  final CalendarNavigationCoordinator? coordinator;

  @override
  Widget build(BuildContext context) {
    final activeCoordinator = coordinator ?? CalendarNavigationCoordinator();

    return BlocListener<CalendarFlowCubit, CalendarFlowState>(
      listenWhen: (previous, current) =>
          current.effect != null &&
          previous.effect?.id != current.effect?.id,
      listener: (context, state) {
        final effect = state.effect;
        if (effect == null) return;

        switch (effect) {
          case OpenRestaurantPickerEffect():
            unawaited(
              activeCoordinator.openRestaurantPicker(
                context,
                date: effect.date,
                subscriptionId: effect.subscriptionId,
              ),
            );
          case OpenMealPickerEffect():
            unawaited(activeCoordinator.openMealPicker(context));
          case CloseMealPickerEffect():
            activeCoordinator.closeMealPicker(context);
          case MealsSavedEffect():
            activeCoordinator.showSuccessSnackBar(
              context,
              context.localization.calendar_meals_save_success,
            );
            activeCoordinator.closeMealPicker(context);
          case MealsConfirmedEffect():
            activeCoordinator.closeMealPicker(context);
            activeCoordinator.showSuccessSnackBar(
              context,
              context.localization.calendar_confirm_meals_success,
            );
            unawaited(activeCoordinator.showMealsConfirmationSheet(context));
          case CalendarFailureEffect():
            final message = CalendarFailureMessageMapper.map(
              failure: effect.failure,
              locale: context.localization,
            );
            activeCoordinator.showErrorSnackBar(context, message);
        }
      },
      child: child,
    );
  }
}
