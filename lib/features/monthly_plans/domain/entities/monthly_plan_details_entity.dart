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
    required this.heroImageAsset,
    required this.description,
    required this.features,
    required this.packageTiers,
    required this.filters,
    required this.restaurants,
    required this.meals,
  });

  final String titlePrefix;
  final String titleHighlight;
  final String duration;
  final String mealsPerDay;
  final String discountLabel;
  final String subscribeLabel;
  final String price;
  final String currency;
  final String heroImageAsset;
  final String description;
  final List<MonthlyPlanFeatureEntity> features;
  final List<MonthlyPackageTierEntity> packageTiers;
  final List<MonthlyPlanFilterEntity> filters;
  final List<MonthlyRestaurantPlanEntity> restaurants;
  final List<MonthlyMealEntity> meals;
}

class MonthlyPlanFilterEntity {
  const MonthlyPlanFilterEntity({required this.label, required this.iconName});

  final String label;
  final String iconName;
}

class MonthlyRestaurantPlanEntity {
  const MonthlyRestaurantPlanEntity({
    required this.programId,
    required this.bundleId,
    required this.restaurantId,
    required this.name,
    required this.subtitle,
    required this.meals,
    required this.bundleMeals,
    required this.rating,
    required this.brandColor,
    this.classificationLogoUrls = const [],
    this.logoAsset,
    this.logoUrl,
    this.initials,
    this.tierName = '',
  });

  final String programId;
  final String bundleId;
  final String restaurantId;
  final String name;
  final String subtitle;
  final String meals;
  final String bundleMeals;
  final String rating;
  final Color brandColor;
  final List<String?> classificationLogoUrls;
  final String? logoAsset;
  final String? logoUrl;
  final String? initials;
  final String tierName;
}

class MonthlyPlanFeatureEntity {
  const MonthlyPlanFeatureEntity({required this.title, required this.iconName});

  final String title;
  final String iconName;
}

class MonthlyPackageTierEntity {
  const MonthlyPackageTierEntity({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.currency,
    required this.period,
    required this.bullets,
    required this.iconName,
    required this.logoUrl,
    required this.restaurantCount,
    required this.restaurantLogoUrls,
    this.isPopular = false,
    this.canSelect = true,
    this.isAvailable = true,
    this.disabledReason,
  });

  final String title;
  final String subtitle;
  final String price;
  final String currency;
  final String period;
  final List<String> bullets;
  final String iconName;
  final String? logoUrl;
  final int restaurantCount;
  final List<String?> restaurantLogoUrls;
  final bool isPopular;
  final bool canSelect;
  final bool isAvailable;
  final String? disabledReason;
}

class MonthlyMealEntity {
  const MonthlyMealEntity({
    required this.name,
    required this.subtitle,
    required this.calories,
    required this.protein,
    required this.imageAsset,
  });

  final String name;
  final String subtitle;
  final String calories;
  final String protein;
  final String imageAsset;
}
