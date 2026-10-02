import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';
import 'package:meal_meat_user/features/restaurant_menu/domain/models/restaurant_menu_models.dart';

class SubscriptionMenuMapper {
  static RestaurantMenuData toMenuData({
    required SubscriptionRestaurantDetailsEntity? details,
    required AppLocalizations locale,
    String? restaurantName,
    String? restaurantLogoUrl,
    String? restaurantLogoAsset,
    String? restaurantInitials,
    String? restaurantRating,
  }) {
    if (details == null) {
      return RestaurantMenuData(
        restaurantName: restaurantName,
        restaurantLogoUrl: restaurantLogoUrl,
        restaurantLogoAsset: restaurantLogoAsset,
        restaurantInitials: restaurantInitials,
        restaurantRating: restaurantRating,
      );
    }

    final localeName = locale.localeName;
    final resolvedName = details.name(localeName).isNotEmpty
        ? details.name(localeName)
        : (restaurantName ?? locale.calendar_restaurant_name);
    final resolvedLogoUrl = details.logoUrl ?? restaurantLogoUrl;

    final orderedOrigins = [...details.ingredientOrigins]
      ..sort((a, b) {
        const order = ['meat', 'poultry', 'seafood', 'oils'];
        final aIndex = order.indexOf(a.category);
        final bIndex = order.indexOf(b.category);
        return (aIndex == -1 ? order.length : aIndex).compareTo(
          bIndex == -1 ? order.length : bIndex,
        );
      });

    final origins = orderedOrigins.map((origin) {
      return RestaurantMenuOrigin(
        icon: _iconFor(origin.category),
        iconUrl: origin.iconUrl,
        title: origin.name(localeName),
        subtitle: origin.source(localeName),
        country: origin.originCountryName(localeName),
      );
    }).toList();

    final tabs = details.mealGroups.map((group) {
      final options = group.meals.map((meal) {
        final ingredients = meal.ingredients
            .map(
              (ingredient) => RestaurantMenuIngredient(
                label: ingredient.name(localeName),
                iconUrl: ingredient.iconUrl,
              ),
            )
            .where((i) => i.label.isNotEmpty)
            .toList();

        final visibleIngredients = ingredients.length <= 4
            ? ingredients
            : [
                ...ingredients.take(4),
                RestaurantMenuIngredient(label: locale.calendar_more),
              ];

        return RestaurantMenuOption(
          id: meal.mealId,
          slot: group.name(localeName),
          title: meal.name(localeName),
          imageAsset: Assets.calendarMealPickerHero,
          imageUrl: meal.imageUrl,
          calories: meal.calories?.toString() ?? '',
          protein: meal.proteinG?.toString() ?? '',
          carbs: meal.carbsG?.toString() ?? '',
          fat: meal.fatG?.toString() ?? '',
          ingredients: visibleIngredients,
          selected: false,
          blockReason: null,
        );
      }).toList();

      return RestaurantMenuTab(
        key: group.slot,
        label: group.name(localeName),
        options: options,
      );
    }).toList();

    return RestaurantMenuData(
      restaurantName: resolvedName,
      restaurantLogoUrl: resolvedLogoUrl,
      restaurantLogoAsset: restaurantLogoAsset,
      restaurantInitials: restaurantInitials,
      restaurantRating: restaurantRating,
      coverImageUrl: details.coverImageUrl,
      origins: origins,
      tabs: tabs,
    );
  }

  static IconData _iconFor(String category) {
    return switch (category) {
      'meat' => Icons.set_meal_rounded,
      'poultry' => Icons.egg_alt_rounded,
      'seafood' => Icons.phishing_rounded,
      'oils' => Icons.energy_savings_leaf_rounded,
      'grains' => Icons.rice_bowl_rounded,
      'produce' => Icons.spa_rounded,
      'dairy' => Icons.local_drink_rounded,
      _ => Icons.eco_rounded,
    };
  }
}
