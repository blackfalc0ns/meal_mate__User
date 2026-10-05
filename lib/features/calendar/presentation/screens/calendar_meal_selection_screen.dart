import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/mapper/calendar_menu_mapper.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_save_button.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarMealSelectionScreen extends StatefulWidget {
  const CalendarMealSelectionScreen({
    super.key,
    this.saveButtonController,
    this.initialRestaurant,
  });

  final RoundedLoadingButtonController? saveButtonController;
  final CalendarRestaurantOptionEntity? initialRestaurant;

  @override
  State<CalendarMealSelectionScreen> createState() =>
      _CalendarMealSelectionScreenState();
}

class _CalendarMealSelectionScreenState
    extends State<CalendarMealSelectionScreen> {
  CalendarAvailableMealsEntity? _cachedAvailableMeals;
  String? _cachedLocaleName;
  String? _cachedRestaurantName;
  String? _cachedRestaurantLogoUrl;
  String? _cachedRestaurantRating;
  RestaurantMenuData? _cachedMenuData;

  RestaurantMenuData _getMenuData({
    required CalendarAvailableMealsEntity? availableMeals,
    required AppLocalizations locale,
    required String? restaurantName,
    required String? restaurantLogoUrl,
    required String? restaurantRating,
  }) {
    if (_cachedMenuData == null ||
        _cachedAvailableMeals != availableMeals ||
        _cachedLocaleName != locale.localeName ||
        _cachedRestaurantName != restaurantName ||
        _cachedRestaurantLogoUrl != restaurantLogoUrl ||
        _cachedRestaurantRating != restaurantRating) {
      _cachedAvailableMeals = availableMeals;
      _cachedLocaleName = locale.localeName;
      _cachedRestaurantName = restaurantName;
      _cachedRestaurantLogoUrl = restaurantLogoUrl;
      _cachedRestaurantRating = restaurantRating;
      _cachedMenuData = CalendarMenuMapper.toMenuData(
        availableMeals: availableMeals,
        selectedMealIds: const [],
        locale: locale,
        restaurantName: restaurantName,
        restaurantLogoUrl: restaurantLogoUrl,
        restaurantRating: restaurantRating,
      );
    }
    return _cachedMenuData!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<MealSelectionViewModel, MealSelectionState>(
          buildWhen: (previous, current) =>
              previous.availableMeals != current.availableMeals ||
              previous.isAvailableMealsLoading !=
                  current.isAvailableMealsLoading ||
              previous.availableMealsFailure != current.availableMealsFailure ||
              previous.saveFailure != current.saveFailure,
          builder: (context, state) {
            final locale = context.localization;
            final restaurantName =
                state.availableMeals?.restaurant?.name ??
                widget.initialRestaurant?.name;
            final restaurantLogoUrl =
                state.availableMeals?.restaurant?.logoUrl ??
                widget.initialRestaurant?.logoUrl;
            final restaurantRating =
                state.availableMeals?.restaurant?.rating ??
                widget.initialRestaurant?.rating;
            final menuData = _getMenuData(
              availableMeals: state.availableMeals,
              locale: locale,
              restaurantName: restaurantName,
              restaurantLogoUrl: restaurantLogoUrl,
              restaurantRating: restaurantRating,
            );

            return BlocSelector<
              MealSelectionViewModel,
              MealSelectionState,
              bool
            >(
              selector: (state) => state.isLoadingMoreMeals,
              builder: (context, isLoadingMoreMeals) {
                return RestaurantMenuScreen(
                  mode: RestaurantMenuMode.selection,
                  menuData: menuData,
                  onMealToggled: (mealId) {
                    context.read<MealSelectionViewModel>().toggleMeal(mealId);
                  },
                  onLoadMore: (slot) {
                    unawaited(
                      context.read<MealSelectionViewModel>().loadMore(
                        slot: slot,
                        localeName: locale.localeName,
                      ),
                    );
                  },
                  isLoadingMore: isLoadingMoreMeals,
                  onSave: null,
                  canSave: false,
                  isLoading: state.isAvailableMealsLoading,
                  isSaving: false,
                  failure: state.availableMealsFailure ?? state.saveFailure,
                  bottomContentPadding: Spacing.bottomNavHeight + Spacing.xxl,
                  selectionControlBuilder: (context, option) {
                    return BlocSelector<
                      MealSelectionViewModel,
                      MealSelectionState,
                      bool
                    >(
                      selector: (state) =>
                          state.selectedMealIds.contains(option.id),
                      builder: (context, isSelected) {
                        return RestaurantMenuSelectButton(
                          selected: isSelected,
                          enabled: !option.isBlocked,
                        );
                      },
                    );
                  },
                  isMealSelected: (mealId) => context
                      .read<MealSelectionViewModel>()
                      .state
                      .selectedMealIds
                      .contains(mealId),
                );
              },
            );
          },
        ),
        PositionedDirectional(
          start: Spacing.lg,
          end: Spacing.lg,
          bottom: Spacing.xl,
          child: CalendarMealSaveButton(
            controller: widget.saveButtonController,
          ),
        ),
        BlocSelector<MealSelectionViewModel, MealSelectionState, bool>(
          selector: (state) => state.isSaving || state.isConfirming,
          builder: (context, isSaving) {
            if (!isSaving) return const SizedBox.shrink();
            final color = context.colorScheme;
            return Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(
                  color: color.scrim.withValues(alpha: 0.35),
                  child: const Center(child: CustomProgressIndicator()),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
