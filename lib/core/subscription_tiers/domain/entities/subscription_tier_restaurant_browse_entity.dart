import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class SubscriptionTierRestaurantBrowseEntity {
  const SubscriptionTierRestaurantBrowseEntity({
    required this.restaurantId,
    this.nameRaw = '',
    required this.nameAr,
    required this.nameEn,
    required this.logoUrl,
    required this.rating,
    required this.mealCount,
    required this.bundleMealCount,
    required this.tier,
    this.tierNameRaw = '',
    required this.tierNameAr,
    required this.tierNameEn,
    required this.tierLogoUrl,
    required this.classifications,
  });

  final String restaurantId;
  final String nameRaw;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final double? rating;
  final int mealCount;
  final int bundleMealCount;
  final String tier;
  final String tierNameRaw;
  final String tierNameAr;
  final String tierNameEn;
  final String? tierLogoUrl;
  final List<SubscriptionTierRestaurantClassificationEntity> classifications;

  String name(String localeName) {
    if (localeName == 'ar' && nameAr.trim().isNotEmpty) return nameAr;
    if (nameRaw.trim().isNotEmpty) return nameRaw;
    if (nameEn.trim().isNotEmpty) return nameEn;
    return nameAr;
  }

  String tierName(String localeName) {
    if (tierNameRaw.trim().isNotEmpty) return tierNameRaw;
    if (localeName == 'ar' && tierNameAr.trim().isNotEmpty) return tierNameAr;
    if (tierNameEn.trim().isNotEmpty) return tierNameEn;
    if (tier.trim().isNotEmpty) return tier;
    return tierNameAr;
  }

  MonthlyRestaurantPlanEntity toRestaurantPlan({
    required String programId,
    required String bundleId,
    required String localeName,
    required Color brandColor,
  }) {
    final restaurantName = name(localeName);
    final resolvedTierName = tierName(localeName);

    return MonthlyRestaurantPlanEntity(
      programId: programId,
      bundleId: bundleId,
      restaurantId: restaurantId,
      name: restaurantName,
      subtitle: resolvedTierName,
      tierName: resolvedTierName,
      meals: mealCount.toString(),
      bundleMeals: bundleMealCount.toString(),
      rating: rating == null ? '' : rating!.toStringAsFixed(1),
      brandColor: brandColor,
      classificationLogoUrls: classifications
          .map((classification) => classification.logoUrl)
          .whereType<String>()
          .toList(),
      logoUrl: logoUrl,
      initials: restaurantName.isEmpty
          ? null
          : restaurantName.characters.take(2).toString().toUpperCase(),
    );
  }
}

class SubscriptionTierRestaurantClassificationEntity {
  const SubscriptionTierRestaurantClassificationEntity({
    required this.logoUrl,
    required this.tier,
  });

  final String? logoUrl;
  final String tier;
}
