import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_loading_skeleton.dart';

class FamilyMemberCalendarPlanSection extends StatelessWidget {
  const FamilyMemberCalendarPlanSection({
    super.key,
    required this.onRetry,
    required this.child,
  });

  final VoidCallback onRetry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({
        String? activeSubscriptionId,
        bool isLoadingCalendar,
        bool hasData,
        Failure? calendarFailure,
      })
    >(
      selector: (state) => (
        activeSubscriptionId: state.activeSubscriptionId,
        isLoadingCalendar: state.isLoadingCalendar,
        hasData: state.hasCalendarData,
        calendarFailure: state.calendarFailure,
      ),
      builder: (context, state) {
        final subId = state.activeSubscriptionId;
        if (subId == null || subId.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
            child: EmptyStateWidget(
              title: locale.family_member_no_plan,
              description: locale.family_member_no_active_subscription,
              icon: Icons.calendar_month_outlined,
            ),
          );
        }

        if (state.isLoadingCalendar && !state.hasData) {
          return const FamilyMemberCalendarLoadingSkeleton(
            includeMemberSelector: false,
          );
        }

        if (state.calendarFailure != null && !state.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
            child: ApiErrorWidget(
              exception: state.calendarFailure!.exception,
              onRetry: onRetry,
            ),
          );
        }

        return child;
      },
    );
  }
}
