import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_loading_skeleton.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_section.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_selected_day_section.dart';

enum CalendarViewMode { loading, noSubscription, error, empty, data }

class CalendarContent extends StatelessWidget {
  const CalendarContent({
    super.key,
    required this.showBottomSpace,
    required this.onSelectRestaurant,
    required this.onChangeMeal,
    required this.onMealTap,
    this.onNavigateToSubscriptions,
  });

  final bool showBottomSpace;
  final VoidCallback onSelectRestaurant;
  final VoidCallback onChangeMeal;
  final void Function(CalendarMealEntity, CalendarRestaurantEntity?) onMealTap;
  final VoidCallback? onNavigateToSubscriptions;

  static CalendarViewMode determineViewMode({
    required bool isLoading,
    required bool hasCalendarData,
    required bool hasNoSubscription,
    required bool hasFailure,
  }) {
    if (isLoading && !hasCalendarData) {
      return CalendarViewMode.loading;
    }
    if (hasNoSubscription) {
      return CalendarViewMode.noSubscription;
    }
    if (hasFailure && !hasCalendarData) {
      return CalendarViewMode.error;
    }
    if (!hasCalendarData) {
      return CalendarViewMode.empty;
    }
    return CalendarViewMode.data;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      CalendarOverviewCubit,
      CalendarOverviewState,
      CalendarViewMode
    >(
      selector: (overviewState) => determineViewMode(
        isLoading: overviewState.isCalendarLoading,
        hasCalendarData: overviewState.hasCalendarData,
        hasNoSubscription: overviewState.hasNoSubscription,
        hasFailure: overviewState.calendarFailure != null,
      ),
      builder: (context, mode) {
        return _buildViewForMode(context, mode: mode);
      },
    );
  }

  Widget _buildViewForMode(
    BuildContext context, {
    required CalendarViewMode mode,
  }) {
    switch (mode) {
      case CalendarViewMode.loading:
        return CalendarLoadingSkeleton(showBottomSpace: showBottomSpace);
      case CalendarViewMode.noSubscription:
        return _buildNoSubscriptionView(context);
      case CalendarViewMode.error:
        return _buildErrorView(context);
      case CalendarViewMode.empty:
        return _buildEmptyView(context);
      case CalendarViewMode.data:
        return _buildDataView(context);
    }
  }

  Widget _buildDataView(BuildContext context) {
    return Column(
      children: [
        const CalendarPickerSection(),
        Expanded(
          child: CalendarSelectedDaySection(
            showBottomSpace: showBottomSpace,
            onSelectRestaurant: onSelectRestaurant,
            onChangeMeal: onChangeMeal,
            onMealTap: onMealTap,
          ),
        ),
      ],
    );
  }

  Widget _buildNoSubscriptionView(BuildContext context) {
    return Column(
      children: [
        const CalendarPickerSection(isNoSubscription: true),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              start: Spacing.screenH,
              end: Spacing.screenH,
              top: Spacing.xs,
              bottom: showBottomSpace
                  ? Spacing.bottomNavHeight + Spacing.xxxl + Spacing.md
                  : Spacing.xl,
            ),
            child: Center(
              child: CalendarEmptyMealsState(
                isNoSubscription: true,
                onAddMeals: () => _navigateToSubscriptions(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context) {
    final locale = context.localization;
    final failure = context
        .watch<CalendarOverviewCubit>()
        .state
        .calendarFailure;
    if (failure == null) return const SizedBox.shrink();

    return ApiErrorWidget(
      exception: failure.exception,
      onRetry: () {
        final subId = context
            .read<CalendarOverviewCubit>()
            .state
            .subscriptionId;
        unawaited(
          context.read<CalendarOverviewCubit>().loadCalendar(
            subscriptionId: subId,
            localeName: locale.localeName,
          ),
        );
      },
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    final locale = context.localization;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        bottom: showBottomSpace
            ? Spacing.bottomNavHeight + Spacing.xxxl
            : Spacing.zero,
      ),
      child: EmptyStateWidget(
        title: locale.calendar_title,
        description: locale.billing_no_subscription_description,
        icon: Icons.calendar_month_rounded,
      ),
    );
  }

  void _navigateToSubscriptions(BuildContext context) {
    if (onNavigateToSubscriptions != null) {
      onNavigateToSubscriptions!();
      return;
    }
    unawaited(context.pushNamed(AppRoutes.subscriptions));
  }
}
