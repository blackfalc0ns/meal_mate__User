import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantSelectionSheet extends StatelessWidget {
  const CalendarRestaurantSelectionSheet({
    super.key,
    this.date,
    this.subscriptionId,
  });

  final DateTime? date;
  final String? subscriptionId;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    DateTime? effectiveDate = date;
    String? effectiveSubId = subscriptionId;

    try {
      final overviewState = context.read<CalendarOverviewViewModel>().state;
      effectiveDate ??=
          overviewState.selectedDate ?? overviewState.selectedDay?.date;
      effectiveSubId ??= overviewState.subscriptionId;
    } catch (_) {}

    final resolvedDate = effectiveDate ?? DateTime.now();
    final resolvedSubId = effectiveSubId ?? '';

    return BlocBuilder<RestaurantPickerViewModel, RestaurantPickerState>(
      buildWhen: (previous, current) =>
          previous.restaurants != current.restaurants ||
          previous.isLoading != current.isLoading ||
          previous.failure != current.failure ||
          previous.hasRestaurants != current.hasRestaurants,
      builder: (context, sheetState) {
        final failure = sheetState.failure;
        if (failure != null && !sheetState.hasRestaurants) {
          return ApiErrorWidget(
            exception: failure.exception,
            onRetry: () => unawaited(
              context.read<RestaurantPickerViewModel>().load(
                date: resolvedDate,
                subscriptionId: resolvedSubId,
                localeName: locale.localeName,
              ),
            ),
          );
        }

        return CalendarRestaurantPickerSheet(
          date: resolvedDate,
          restaurants: sheetState.restaurants,
          isLoading: sheetState.isLoading,
          onSearchChanged: (query) {
            unawaited(
              context.read<RestaurantPickerViewModel>().load(
                date: resolvedDate,
                subscriptionId: resolvedSubId,
                localeName: locale.localeName,
                query: query,
              ),
            );
          },
          onRestaurantSelected: (restaurant) {
            Navigator.pop(context, restaurant);
          },
        );
      },
    );
  }
}
