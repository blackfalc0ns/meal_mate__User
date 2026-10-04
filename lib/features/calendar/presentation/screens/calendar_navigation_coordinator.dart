import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_meal_selection_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meals_confirmation_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_selection_sheet.dart';
import 'package:meal_meat_user/features/meal_details/presentation/mapper/calendar_meal_details_mapper.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarNavigationCoordinator {
  bool _restaurantSheetOpen = false;
  bool _mealPickerOpen = false;
  Route<void>? _mealPickerRoute;

  bool get isRestaurantSheetOpen => _restaurantSheetOpen;
  bool get isMealPickerOpen => _mealPickerOpen;

  Future<void> openRestaurantPicker(
    BuildContext context, {
    DateTime? date,
    String? subscriptionId,
  }) async {
    if (_restaurantSheetOpen) return;
    _restaurantSheetOpen = true;

    final restaurantPickerCubit = context.read<RestaurantPickerCubit>();
    final flowCubit = context.read<CalendarFlowCubit>();
    final locale = context.localization;

    final selectedRestaurant =
        await showModalBottomSheet<CalendarRestaurantOptionEntity>(
          context: context,
          isScrollControlled: true,
          backgroundColor: context.colorScheme.surface,
          builder: (sheetContext) {
            return BlocProvider<RestaurantPickerCubit>.value(
              value: restaurantPickerCubit,
              child: const CalendarRestaurantSelectionSheet(),
            );
          },
        );

    _restaurantSheetOpen = false;

    if (selectedRestaurant == null || !context.mounted) return;

    await flowCubit.selectRestaurant(
      restaurant: selectedRestaurant,
      localeName: locale.localeName,
      date: date,
      subscriptionId: subscriptionId,
    );
  }

  Future<void> openMealPicker(
    BuildContext context, {
    CalendarRestaurantOptionEntity? initialRestaurant,
    RoundedLoadingButtonController? saveButtonController,
  }) async {
    if (_mealPickerOpen) return;
    _mealPickerOpen = true;

    final mealSelectionCubit = context.read<MealSelectionCubit>();
    final flowCubit = context.read<CalendarFlowCubit>();
    CalendarViewModel? legacyViewModel;
    try {
      legacyViewModel = context.read<CalendarViewModel>();
    } catch (_) {}

    final route = MaterialPageRoute<void>(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MealSelectionCubit>.value(value: mealSelectionCubit),
            BlocProvider<CalendarFlowCubit>.value(value: flowCubit),
            if (legacyViewModel != null)
              BlocProvider<CalendarViewModel>.value(value: legacyViewModel),
          ],
          child: CalendarMealSelectionScreen(
            saveButtonController:
                saveButtonController ?? RoundedLoadingButtonController(),
            initialRestaurant: initialRestaurant,
          ),
        );
      },
    );

    _mealPickerRoute = route;
    await Navigator.of(context).push<void>(route);

    if (identical(_mealPickerRoute, route)) {
      _mealPickerRoute = null;
    }
    _mealPickerOpen = false;
  }

  void closeMealPicker(BuildContext context) {
    final route = _mealPickerRoute;
    final navigator = route?.navigator;
    _mealPickerOpen = false;
    _mealPickerRoute = null;

    if (route == null || navigator == null) return;
    if (route.isCurrent) {
      navigator.pop();
      return;
    }
    if (route.isActive) {
      navigator.removeRoute(route);
    }
  }

  Future<void> showMealsConfirmationSheet(BuildContext context) async {
    await CalendarMealsConfirmationSheet.show(
      context,
      statusText: context.localization.calendar_status_awaiting_restaurant,
    );
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    CustomSnackbar.showSuccess(
      context: context,
      message: message,
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    CustomSnackbar.showError(
      context: context,
      message: message,
    );
  }

  void openMealDetails(
    BuildContext context,
    CalendarMealEntity meal,
    CalendarRestaurantEntity? restaurant,
  ) {
    final locale = context.localization;
    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.mealDetails,
        arguments: CalendarMealDetailsMapper.map(
          meal: meal,
          locale: locale,
          restaurantName: restaurant?.name.isNotEmpty == true
              ? restaurant!.name
              : locale.calendar_restaurant_name,
          restaurantLogoUrl: restaurant?.logoUrl,
          ratingValue: restaurant?.rating ?? '',
          deliveryWindow: restaurant?.deliveryWindow ?? '',
        ),
      ),
    );
  }
}
