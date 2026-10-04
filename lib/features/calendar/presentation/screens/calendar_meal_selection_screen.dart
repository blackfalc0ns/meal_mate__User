import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/mapper/calendar_menu_mapper.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_save_button.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarMealSelectionScreen extends StatelessWidget {
  const CalendarMealSelectionScreen({
    super.key,
    this.saveButtonController,
    this.initialRestaurant,
  });

  final RoundedLoadingButtonController? saveButtonController;
  final CalendarRestaurantOptionEntity? initialRestaurant;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<MealSelectionCubit, MealSelectionState>(
          buildWhen: (previous, current) =>
              previous.availableMeals != current.availableMeals ||
              previous.selectedMealIds != current.selectedMealIds ||
              previous.isLoadingMoreMeals != current.isLoadingMoreMeals ||
              previous.isAvailableMealsLoading !=
                  current.isAvailableMealsLoading ||
              previous.availableMealsFailure != current.availableMealsFailure ||
              previous.saveFailure != current.saveFailure,
          builder: (context, state) {
            final locale = context.localization;
            final restaurantName =
                state.availableMeals?.restaurant?.name ??
                initialRestaurant?.name;
            final restaurantLogoUrl =
                state.availableMeals?.restaurant?.logoUrl ??
                initialRestaurant?.logoUrl;
            final restaurantRating =
                state.availableMeals?.restaurant?.rating ??
                initialRestaurant?.rating;
            final menuData = CalendarMenuMapper.toMenuData(
              availableMeals: state.availableMeals,
              selectedMealIds: state.selectedMealIds,
              locale: locale,
              restaurantName: restaurantName,
              restaurantLogoUrl: restaurantLogoUrl,
              restaurantRating: restaurantRating,
            );

            return RestaurantMenuScreen(
              mode: RestaurantMenuMode.selection,
              menuData: menuData,
              onMealToggled: (mealId) {
                context.read<MealSelectionCubit>().toggleMeal(mealId);
              },
              onLoadMore: (slot) {
                unawaited(
                  context.read<MealSelectionCubit>().loadMore(
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
          child: CalendarMealSaveButton(
            controller: saveButtonController,
          ),
        ),
      ],
    );
  }
}
