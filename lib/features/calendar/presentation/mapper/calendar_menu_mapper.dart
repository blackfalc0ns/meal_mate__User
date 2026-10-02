import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/restaurant_menu/domain/models/restaurant_menu_models.dart';

class CalendarMenuMapper {
  static RestaurantMenuData toMenuData({
    required CalendarAvailableMealsEntity? availableMeals,
    required List<String> selectedMealIds,
    required AppLocalizations locale,
    String? restaurantName,
    String? restaurantLogoUrl,
    String? restaurantLogoAsset,
    String? restaurantInitials,
    String? restaurantRating,
  }) {
    if (availableMeals == null) {
      return RestaurantMenuData(
        restaurantName: restaurantName,
        restaurantLogoUrl: restaurantLogoUrl,
        restaurantLogoAsset: restaurantLogoAsset,
        restaurantInitials: restaurantInitials,
        restaurantRating: restaurantRating,
      );
    }

    final restaurant = availableMeals.restaurant;
    final resolvedName =
        restaurantName ?? restaurant?.name ?? locale.calendar_restaurant_name;
    final resolvedLogoUrl = restaurantLogoUrl ?? restaurant?.logoUrl;
    final resolvedRating = restaurantRating ?? restaurant?.rating;

    final origins = availableMeals.coreIngredients.map((ingredient) {
      final country = ingredient.originCountryName;
      final flag = ingredient.flagEmoji;
      final countryLabel = (flag == null || flag.isEmpty)
          ? country
          : country.isEmpty
          ? flag
          : '$flag $country';
      return RestaurantMenuOrigin(
        title: ingredient.name,
        subtitle: ingredient.isLocal
            ? locale.calendar_fresh_local
            : locale.calendar_imported,
        country: countryLabel,
        icon: Icons.eco_rounded,
        iconUrl: ingredient.iconUrl,
      );
    }).toList();

    final apiSlotRequirements = availableMeals.slotRequirements;
    final tabs = <RestaurantMenuTab>[];

    if (apiSlotRequirements.isNotEmpty) {
      for (final requirement in apiSlotRequirements) {
        final slotKey = requirement.slot;
        final slotLabel = requirement.displayName.isNotEmpty
            ? requirement.displayName
            : requirement.slot;
        final options = _optionsFromMeals(
          availableMeals.meals,
          slotKey,
          locale.calendar_more,
          selectedMealIds,
        );
        tabs.add(RestaurantMenuTab(
          key: slotKey,
          label: slotLabel,
          options: options,
        ));
      }
    } else {
      final defaultSlots = [
        (key: 'breakfast', label: locale.calendar_breakfast),
        (key: 'lunch', label: locale.calendar_lunch),
        (key: 'dinner', label: locale.calendar_dinner),
      ];
      for (final slot in defaultSlots) {
        tabs.add(RestaurantMenuTab(
          key: slot.key,
          label: slot.label,
          options: _optionsFromMeals(
            availableMeals.meals,
            slot.key,
            locale.calendar_more,
            selectedMealIds,
          ),
        ));
      }
    }

    return RestaurantMenuData(
      restaurantName: resolvedName,
      restaurantLogoUrl: resolvedLogoUrl,
      restaurantLogoAsset: restaurantLogoAsset,
      restaurantInitials: restaurantInitials,
      restaurantRating: resolvedRating,
      origins: origins,
      tabs: tabs,
    );
  }

  static List<RestaurantMenuOption> _optionsFromMeals(
    List<CalendarMealEntity> meals,
    String slot,
    String moreLabel,
    List<String> selectedMealIds,
  ) {
    return meals
        .where((meal) => meal.slot.toLowerCase() == slot.toLowerCase())
        .map((meal) {
          final visibleIngredients = _visibleIngredients(
            meal.ingredients,
            moreLabel,
          );

          return RestaurantMenuOption(
            id: meal.id,
            slot: meal.slot,
            title: meal.title,
            imageAsset: Assets.calendarMealPickerHero,
            imageUrl: meal.imageUrl,
            calories: meal.calories,
            protein: meal.protein,
            carbs: meal.carbs,
            fat: meal.fat,
            ingredients: visibleIngredients,
            selected: selectedMealIds.contains(meal.id),
            blockReason: meal.blockReason,
          );
        })
        .toList();
  }

  static List<RestaurantMenuIngredient> _visibleIngredients(
    List<CalendarMealIngredientEntity> ingredients,
    String moreLabel,
  ) {
    final list = ingredients
        .map((i) => RestaurantMenuIngredient(label: i.label, iconUrl: i.iconUrl))
        .toList();
    if (list.length <= 4) return list;
    return [
      ...list.take(4),
      RestaurantMenuIngredient(label: moreLabel),
    ];
  }
}
