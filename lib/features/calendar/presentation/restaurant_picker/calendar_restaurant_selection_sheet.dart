import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantSelectionSheet extends StatelessWidget {
  const CalendarRestaurantSelectionSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocBuilder<CalendarViewModel, CalendarState>(
      buildWhen: (previous, current) =>
          previous.restaurants != current.restaurants ||
          previous.isRestaurantsLoading != current.isRestaurantsLoading ||
          previous.restaurantsFailure != current.restaurantsFailure ||
          previous.hasRestaurantPool != current.hasRestaurantPool,
      builder: (context, sheetState) {
        final failure = sheetState.restaurantsFailure;
        if (failure != null && !sheetState.hasRestaurantPool) {
          return ApiErrorWidget(
            exception: failure.exception,
            onRetry: () => context.read<CalendarViewModel>().doIntent(
              LoadCalendarRestaurantsEvent(localeName: locale.localeName),
            ),
          );
        }

        return CalendarRestaurantPickerSheet(
          restaurants: sheetState.restaurants,
          isLoading: sheetState.isRestaurantsLoading,
          onSearchChanged: (query) {
            context.read<CalendarViewModel>().doIntent(
              LoadCalendarRestaurantsEvent(
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
