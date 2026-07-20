import 'package:flutter/material.dart';

class SubscriptionPlanEntity {
  const SubscriptionPlanEntity({
    required this.title,
    required this.duration,
    required this.mealsPerDay,
    required this.description,
    required this.delivery,
    required this.periodLabel,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountLabel,
    required this.imageAsset,
    required this.accentColor,
    required this.badgeBackgroundColor,
    required this.gradientColors,
  });

  final String title;
  final String duration;
  final String mealsPerDay;
  final String description;
  final String delivery;
  final String periodLabel;
  final String originalPrice;
  final String discountedPrice;
  final String discountLabel;
  final String imageAsset;
  final Color accentColor;
  final Color badgeBackgroundColor;
  final List<Color> gradientColors;
}
