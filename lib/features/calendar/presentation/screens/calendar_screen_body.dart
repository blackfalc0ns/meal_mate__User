import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_navigation_coordinator.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_cubit.dart';

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
            CalendarHeader(
              title: locale.calendar_title,
              onBackPressed:
                  onBackPressed ??
                  () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      try {
                        context.read<HomeCubit>().selectTab(0);
                      } catch (_) {}
                    }
                  },
            ),
            Expanded(
              child: CalendarContent(
                showBottomSpace: showBottomSpace,
                onSelectRestaurant:
                    onSelectRestaurant ??
                    () {
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

                      unawaited(activeCoordinator.openMealPicker(context));
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
