import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_save_button.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarMealSelectionScreen extends StatelessWidget {
  const CalendarMealSelectionScreen({
    super.key,
    required this.saveButtonController,
  });
  final RoundedLoadingButtonController saveButtonController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<CalendarViewModel, CalendarState>(
          builder: (context, state) {
            final locale = context.localization;
            final restaurant =
                state.availableMeals?.restaurant ??
                state.selectedDay?.restaurant;
            return RestaurantMenuScreen(
              mode: RestaurantMenuMode.selection,
              restaurantName: restaurant?.name,
              restaurantLogoUrl: restaurant?.logoUrl,
              restaurantInitials: (restaurant?.name ?? '')
                  .trim()
                  .split(RegExp(r'\s+'))
                  .where((word) => word.isNotEmpty)
                  .take(3)
                  .map((word) => word.characters.first)
                  .join(),
              restaurantRating: restaurant?.rating,
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
