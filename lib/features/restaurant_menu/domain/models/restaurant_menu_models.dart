import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class RestaurantMenuIngredient {
  const RestaurantMenuIngredient({
    required this.label,
    this.iconUrl,
  });

  final String label;
  final String? iconUrl;
}

class RestaurantMenuOption {
  const RestaurantMenuOption({
    required this.id,
    required this.slot,
    required this.title,
    this.imageAsset = Assets.calendarMealPickerHero,
    this.imageUrl,
    this.calories = '',
    this.protein = '',
    this.carbs = '',
    this.fat = '',
    this.ingredients = const [],
    this.selected = false,
    this.blockReason,
  });

  final String id;
  final String slot;
  final String title;
  final String imageAsset;
  final String? imageUrl;
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  final List<RestaurantMenuIngredient> ingredients;
  final bool selected;
  final String? blockReason;

  RestaurantMenuOption copyWith({
    String? id,
    String? slot,
    String? title,
    String? imageAsset,
    String? imageUrl,
    String? calories,
    String? protein,
    String? carbs,
    String? fat,
    List<RestaurantMenuIngredient>? ingredients,
    bool? selected,
    String? blockReason,
  }) {
    return RestaurantMenuOption(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      title: title ?? this.title,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      ingredients: ingredients ?? this.ingredients,
      selected: selected ?? this.selected,
      blockReason: blockReason ?? this.blockReason,
    );
  }
}

class RestaurantMenuOrigin {
  const RestaurantMenuOrigin({
    required this.title,
    required this.subtitle,
    required this.country,
    this.icon = Icons.eco_rounded,
    this.iconUrl,
  });

  final String title;
  final String subtitle;
  final String country;
  final IconData icon;
  final String? iconUrl;
}

class RestaurantMenuTab {
  const RestaurantMenuTab({
    required this.key,
    required this.label,
    this.options = const [],
  });

  final String key;
  final String label;
  final List<RestaurantMenuOption> options;
}

class RestaurantMenuData {
  const RestaurantMenuData({
    this.restaurantName,
    this.restaurantLogoUrl,
    this.restaurantLogoAsset,
    this.restaurantInitials,
    this.restaurantRating,
    this.coverImageUrl,
    this.origins = const [],
    this.tabs = const [],
  });

  final String? restaurantName;
  final String? restaurantLogoUrl;
  final String? restaurantLogoAsset;
  final String? restaurantInitials;
  final String? restaurantRating;
  final String? coverImageUrl;
  final List<RestaurantMenuOrigin> origins;
  final List<RestaurantMenuTab> tabs;
}
