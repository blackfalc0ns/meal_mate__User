import 'package:flutter/material.dart';

enum SubscriptionPlanViewMode { grid, list }

class MonthlyPlanDetailsEntity {
  const MonthlyPlanDetailsEntity({
    required this.titlePrefix,
    required this.titleHighlight,
    required this.duration,
    required this.mealsPerDay,
    required this.discountLabel,
    required this.subscribeLabel,
    required this.price,
    required this.currency,
    required this.filters,
    required this.restaurants,
  });

  final String titlePrefix;
  final String titleHighlight;
  final String duration;
  final String mealsPerDay;
  final String discountLabel;
  final String subscribeLabel;
  final String price;
  final String currency;
  final List<MonthlyPlanFilterEntity> filters;
  final List<MonthlyRestaurantPlanEntity> restaurants;
}

class MonthlyPlanFilterEntity {
  const MonthlyPlanFilterEntity({required this.label, required this.iconName});

  final String label;
  final String iconName;
}

class MonthlyRestaurantPlanEntity {
  const MonthlyRestaurantPlanEntity({
    required this.name,
    required this.subtitle,
    required this.meals,
    required this.rating,
    required this.brandColor,
    this.logoAsset,
    this.initials,
  });

  final String name;
  final String subtitle;
  final String meals;
  final String rating;
  final Color brandColor;
  final String? logoAsset;
  final String? initials;
}
