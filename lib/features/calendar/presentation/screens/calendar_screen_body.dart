import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_state.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_navigation_coordinator.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_header.dart';

class CalendarScreenBody extends StatelessWidget {
  const CalendarScreenBody({
    super.key,
    this.showBottomSpace = false,
    this.coordinator,
    this.onBackPressed,
    this.onSelectRestaurant,
    this.onMealTap,
    this.onChangeMeal,
  });

  final bool showBottomSpace;
  final CalendarNavigationCoordinator? coordinator;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSelectRestaurant;
  final void Function(
    CalendarMealEntity meal,
    CalendarRestaurantEntity? restaurant,
  )?
  onMealTap;
  final VoidCallback? onChangeMeal;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final activeCoordinator = coordinator ?? CalendarNavigationCoordinator();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: color.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: color.surface,
        body: Column(
          children: [
            _buildCalendarHeader(
              context,
              locale.calendar_title,
              activeCoordinator,
            ),
            Expanded(
              child: CalendarContent(
                showBottomSpace: showBottomSpace,
                onSelectRestaurant:
                    onSelectRestaurant ??
                    () {
                      final overviewState = context
                          .read<CalendarOverviewViewModel>()
                          .state;
                      final day = overviewState.selectedDay;
                      final date = overviewState.selectedDate ?? day?.date;
                      final subId = overviewState.subscriptionId;

                      if (date != null && subId.isNotEmpty) {
                        unawaited(
                          context.read<RestaurantPickerViewModel>().load(
                            subscriptionId: subId,
                            date: date,
                            localeName: locale.localeName,
                          ),
                        );
                      }

                      unawaited(
                        activeCoordinator.openRestaurantPicker(context),
                      );
                    },
                onMealTap:
                    onMealTap ??
                    (meal, restaurant) {
                      activeCoordinator.openMealDetails(
                        context,
                        meal,
                        restaurant,
                      );
                    },
                onChangeMeal:
                    onChangeMeal ??
                    () {
                      final day = context
                          .read<CalendarOverviewViewModel>()
                          .state
                          .selectedDay;
                      final date =
                          context
                              .read<CalendarOverviewViewModel>()
                              .state
                              .selectedDate ??
                          day?.date;
                      final subId = context
                          .read<CalendarOverviewViewModel>()
                          .state
                          .subscriptionId;
                      final restaurant = day?.restaurant;

                      if (date != null &&
                          subId.isNotEmpty &&
                          restaurant != null) {
                        unawaited(
                          context.read<MealSelectionViewModel>().load(
                            subscriptionId: subId,
                            date: date,
                            restaurantId: restaurant.id,
                            localeName: locale.localeName,
                            initialSelectedMealIds: (day?.meals ?? const [])
                                .map((m) => m.id)
                                .toList(),
                          ),
                        );
                      }

                      unawaited(
                        activeCoordinator.openMealPicker(
                          context,
                          date: date,
                          subscriptionId: subId,
                        ),
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader(
    BuildContext context,
    String title,
    CalendarNavigationCoordinator activeCoordinator,
  ) {
    NotificationBadgeViewModel? badgeVm;
    try {
      badgeVm = context.read<NotificationBadgeViewModel>();
    } catch (_) {
      if (getIt.isRegistered<NotificationBadgeViewModel>()) {
        badgeVm = getIt<NotificationBadgeViewModel>();
      }
    }

    if (badgeVm == null) {
      return CalendarHeader(
        title: title,
        hasNotification: false,
        onNotificationPressed: () =>
            activeCoordinator.openNotifications(context),
      );
    }

    return BlocSelector<
      NotificationBadgeViewModel,
      NotificationBadgeState,
      bool
    >(
      bloc: badgeVm,
      selector: (state) => state.hasUnread,
      builder: (context, hasNotification) {
        return CalendarHeader(
          title: title,
          hasNotification: hasNotification,
          onNotificationPressed: () =>
              activeCoordinator.openNotifications(context),
        );
      },
    );
  }
}
