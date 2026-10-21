import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';

class FamilyDayMealsErrorsSection extends StatelessWidget {
  const FamilyDayMealsErrorsSection({
    super.key,
    required this.onRetryCapabilities,
    required this.onRetryCalendar,
    required this.onRetryDay,
  });

  final VoidCallback onRetryCapabilities;
  final VoidCallback onRetryCalendar;
  final VoidCallback onRetryDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocSelector<FamilyCalendarViewModel, FamilyCalendarState, Failure?>(
          selector: (state) => state.capabilitiesFailure,
          builder: (context, failure) {
            if (failure == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: InlineApiErrorWidget(
                failure: failure,
                onRetry: onRetryCapabilities,
              ),
            );
          },
        ),
        BlocSelector<
          FamilyCalendarViewModel,
          FamilyCalendarState,
          ({Failure? failure, bool hasData})
        >(
          selector: (state) =>
              (failure: state.calendarFailure, hasData: state.hasCalendarData),
          builder: (context, data) {
            if (data.failure == null || !data.hasData) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: InlineApiErrorWidget(
                failure: data.failure!,
                onRetry: onRetryCalendar,
              ),
            );
          },
        ),
        BlocSelector<FamilyCalendarViewModel, FamilyCalendarState, Failure?>(
          selector: (state) => state.dayFailure,
          builder: (context, failure) {
            if (failure == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: InlineApiErrorWidget(
                failure: failure,
                onRetry: onRetryDay,
              ),
            );
          },
        ),
      ],
    );
  }
}
