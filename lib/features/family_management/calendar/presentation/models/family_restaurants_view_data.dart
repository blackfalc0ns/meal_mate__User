import 'package:flutter/material.dart';

class FamilyRestaurantsSummaryData {
  const FamilyRestaurantsSummaryData({
    required this.selectedMeals,
    required this.selectedMealsTotal,
    required this.selectedMealsLabel,
    required this.dailyMeals,
    required this.dailyMealsLabel,
    required this.calories,
    required this.caloriesLabel,
    required this.programLabel,
  });

  final String selectedMeals;
  final String selectedMealsTotal;
  final String selectedMealsLabel;
  final String dailyMeals;
  final String dailyMealsLabel;
  final String calories;
  final String caloriesLabel;
  final String programLabel;
}

class FamilyRestaurantsMemberData {
  const FamilyRestaurantsMemberData({
    required this.name,
    this.isSelected = false,
  });

  final String name;
  final bool isSelected;
}

class FamilyRestaurantsFilterData {
  const FamilyRestaurantsFilterData({
    required this.label,
    this.icon,
    this.iconColor,
    this.isSelected = false,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
}

class FamilyRestaurantCardData {
  const FamilyRestaurantCardData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.tags,
    required this.buttonLabel,
    this.imageUrl,
    this.logoUrl,
  });

  final String id;
  final String name;
  final String subtitle;
  final String rating;
  final List<String> tags;
  final String buttonLabel;
  final String? imageUrl;
  final String? logoUrl;
}
