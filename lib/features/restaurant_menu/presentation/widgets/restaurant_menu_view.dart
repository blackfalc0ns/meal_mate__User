import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_args.dart';
import 'package:meal_meat_user/features/meal_details/presentation/mapper/calendar_meal_details_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';

part 'restaurant_menu_content.dart';
part 'restaurant_menu_frame.dart';
part 'restaurant_menu_mapping.dart';
part 'restaurant_menu_navigation.dart';
part 'restaurant_menu_sheet_handle.dart';
part 'restaurant_menu_header.dart';
part 'restaurant_menu_description.dart';
part 'restaurant_menu_source_section.dart';
part 'restaurant_menu_source_card.dart';
part 'restaurant_menu_tabs.dart';
part 'restaurant_menu_tab_label.dart';
part 'restaurant_menu_options_section.dart';
part 'restaurant_menu_section_title.dart';
part 'restaurant_menu_option_card.dart';
part 'restaurant_menu_select_button.dart';
part 'restaurant_menu_nutrition_row.dart';
part 'restaurant_menu_nutrition.dart';
part 'restaurant_menu_ingredient_row.dart';
part 'restaurant_menu_ingredient_chip.dart';
part 'restaurant_menu_loading_skeleton.dart';
part 'restaurant_menu_divider_line.dart';
part 'restaurant_menu_protein_logo.dart';

enum RestaurantMenuMode { preview, selection }

typedef RestaurantMenuOption = ({
  String id,
  String slot,
  String title,
  String imageAsset,
  String? imageUrl,
  String calories,
  String protein,
  String carbs,
  String fat,
  List<CalendarMealIngredientEntity> ingredients,
  bool selected,
  String? blockReason,
});

class RestaurantMenuView extends StatefulWidget {
  const RestaurantMenuView({
    super.key,
    required this.mode,
    this.restaurantName,
    this.restaurantLogoAsset,
    this.restaurantLogoUrl,
    this.restaurantInitials,
    this.restaurantRating,
    this.programId,
    this.bundleId,
    this.restaurantId,
    this.details,
    this.availableMeals,
    this.selectedMealIds = const [],
    this.onMealToggled,
    this.onLoadMore,
    this.onSave,
    this.canSave = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSaving = false,
    this.failure,
    this.onBackPressed,
    this.isFullPage = false,
    this.bottomContentPadding = Spacing.zero,
  });

  final RestaurantMenuMode mode;
  final String? restaurantName;
  final String? restaurantLogoAsset;
  final String? restaurantLogoUrl;
  final String? restaurantInitials;
  final String? restaurantRating;
  final String? programId;
  final String? bundleId;
  final String? restaurantId;
  final SubscriptionRestaurantDetailsEntity? details;
  final CalendarAvailableMealsEntity? availableMeals;
  final List<String> selectedMealIds;
  final ValueChanged<String>? onMealToggled;
  final ValueChanged<String>? onLoadMore;
  final VoidCallback? onSave;
  final bool canSave;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSaving;
  final Failure? failure;
  final VoidCallback? onBackPressed;
  final bool isFullPage;
  final double bottomContentPadding;

  @override
  State<RestaurantMenuView> createState() => RestaurantMenuViewState();
}

class RestaurantMenuViewState extends State<RestaurantMenuView> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final restaurantName =
        widget.restaurantName ?? locale.calendar_restaurant_name;
    final details = widget.details;
    final groups = details?.mealGroups ?? const [];
    final availableMeals = widget.availableMeals;
    final apiSlotRequirements = availableMeals?.slotRequirements ?? const [];
    final apiSlots = apiSlotRequirements
        .map((requirement) => requirement.slot)
        .where((slot) => slot.isNotEmpty)
        .toList();
    final apiSlotLabels = apiSlotRequirements
        .map((requirement) {
          final label = requirement.displayName;
          return label.isNotEmpty ? label : requirement.slot;
        })
        .where((slot) => slot.isNotEmpty)
        .toList();
    final mealTabs = apiSlotLabels.isNotEmpty
        ? apiSlotLabels
        : groups.isEmpty
        ? [
            locale.calendar_breakfast,
            locale.calendar_lunch,
            locale.calendar_dinner,
          ]
        : groups.map((group) => group.name(locale.localeName)).toList();
    final selectedTab = mealTabs.isEmpty
        ? 0
        : _selectedTab.clamp(0, mealTabs.length - 1);
    final selectedSlot = apiSlots.isNotEmpty
        ? apiSlots[selectedTab.clamp(0, apiSlots.length - 1)]
        : mealTabs[selectedTab];
    final options = availableMeals != null
        ? _optionsFromAvailableMeals(
            availableMeals.meals,
            selectedSlot,
            locale.calendar_more,
            widget.selectedMealIds,
          )
        : groups.isEmpty
        ? const <RestaurantMenuOption>[]
        : _optionsFromGroup(
            groups[selectedTab],
            locale.localeName,
            locale.calendar_more,
          );
    final resolvedRestaurantName =
        widget.restaurantName ??
        availableMeals?.restaurant?.name ??
        restaurantName;
    final restaurantLogoUrl =
        widget.restaurantLogoUrl ??
        details?.logoUrl ??
        availableMeals?.restaurant?.logoUrl;
    return RestaurantMenuFrame(
      restaurantName: restaurantName,
      coverImageUrl: details?.coverImageUrl,
      onBackPressed: widget.onBackPressed,
      child: RestaurantMenuContent(
        isFullPage: widget.isFullPage,
        isLoading: widget.isLoading,
        isLoadingMore: widget.isLoadingMore,
        isSaving: widget.isSaving,
        canSave: widget.canSave,
        failure: widget.failure,
        mode: widget.mode,
        resolvedRestaurantName: resolvedRestaurantName,
        restaurantLogoAsset: widget.restaurantLogoAsset,
        restaurantLogoUrl: restaurantLogoUrl,
        restaurantInitials: widget.restaurantInitials,
        coreIngredients: availableMeals?.coreIngredients ?? const [],
        origins: details?.ingredientOrigins ?? const [],
        mealTabs: mealTabs,
        selectedTab: selectedTab,
        selectedSlot: selectedSlot,
        options: options,
        onTabChanged: (index) {
          if (_selectedTab == index) return;
          setState(() => _selectedTab = index);
        },
        onOptionSelected:
            widget.mode == RestaurantMenuMode.selection &&
                availableMeals != null &&
                widget.onMealToggled != null
            ? (index) => widget.onMealToggled!(options[index].id)
            : null,
        onOptionDetailsSelected: availableMeals != null
            ? (index) {
                final meal = availableMeals.meals
                    .where((meal) => meal.id == options[index].id)
                    .firstOrNull;
                if (meal != null) _openMealDetailsForCalendarMeal(meal);
              }
            : groups.isEmpty
            ? null
            : (index) => _openMealDetails(groups[selectedTab].meals[index]),
        onLoadMore: widget.onLoadMore,
        onSave: widget.onSave,
        bottomContentPadding: widget.bottomContentPadding,
      ),
    );
  }
}
