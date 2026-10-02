import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/meal_selection/calendar_meal_save_button.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarMealSelectionScreen extends StatelessWidget {
  const CalendarMealSelectionScreen({
    super.key,
    required this.saveButtonController,
    this.initialRestaurant,
  });

  final RoundedLoadingButtonController saveButtonController;
  final CalendarRestaurantOptionEntity? initialRestaurant;

  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  static String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    return name
        .trim()
        .split(_whitespaceRegex)
        .where((word) => word.isNotEmpty)
        .take(3)
        .map((word) => word.characters.first)
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<CalendarViewModel, CalendarState>(
          buildWhen: (previous, current) =>
              previous.availableMeals != current.availableMeals ||
              previous.localSelectedMealIds != current.localSelectedMealIds ||
              previous.isLoadingMoreMeals != current.isLoadingMoreMeals ||
              previous.isAvailableMealsLoading !=
                  current.isAvailableMealsLoading ||
              previous.availableMealsFailure != current.availableMealsFailure ||
              previous.saveFailure != current.saveFailure ||
              previous.selectedDay?.restaurant != current.selectedDay?.restaurant,
          builder: (context, state) {
            final locale = context.localization;
            final currentDayRestaurant = state.selectedDay?.restaurant;
            final restaurantName =
                state.availableMeals?.restaurant?.name ??
                initialRestaurant?.name ??
                currentDayRestaurant?.name;
            final restaurantLogoUrl =
                state.availableMeals?.restaurant?.logoUrl ??
                initialRestaurant?.logoUrl ??
                currentDayRestaurant?.logoUrl;
            final restaurantRating =
                state.availableMeals?.restaurant?.rating ??
                initialRestaurant?.rating ??
                currentDayRestaurant?.rating;
            final restaurantInitials = _getInitials(restaurantName);
            return RestaurantMenuScreen(
              mode: RestaurantMenuMode.selection,
              restaurantName: restaurantName,
              restaurantLogoUrl: restaurantLogoUrl,
              restaurantInitials: restaurantInitials,
              restaurantRating: restaurantRating,
              availableMeals: state.availableMeals,
              selectedMealIds: state.localSelectedMealIds,
              onMealToggled: (mealId) {
                context.read<CalendarViewModel>().doIntent(
                  ToggleCalendarMealEvent(mealId),
                );
              },
              onLoadMore: (slot) {
                context.read<CalendarViewModel>().doIntent(
                  LoadMoreCalendarMealsEvent(
                    slot: slot,
                    localeName: locale.localeName,
                  ),
                );
              },
              isLoadingMore: state.isLoadingMoreMeals,
              onSave: null,
              canSave: false,
              isLoading: state.isAvailableMealsLoading,
              isSaving: false,
              failure: state.availableMealsFailure ?? state.saveFailure,
              bottomContentPadding: Spacing.bottomNavHeight + Spacing.xxl,
            );
          },
        ),
        PositionedDirectional(
          start: Spacing.lg,
          end: Spacing.lg,
          bottom: Spacing.xl,
          child: CalendarMealSaveButton(controller: saveButtonController),
        ),
      ],
    );
  }
}
