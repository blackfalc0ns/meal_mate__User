class SubscriptionTierRestaurantBrowseEntity {
  const SubscriptionTierRestaurantBrowseEntity({
    required this.restaurantId,
    required this.nameAr,
    required this.nameEn,
    required this.logoUrl,
    required this.rating,
    required this.mealCount,
    required this.bundleMealCount,
    required this.tier,
    required this.tierNameAr,
    required this.tierNameEn,
    required this.tierLogoUrl,
    required this.classifications,
  });

  final String restaurantId;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;
  final double? rating;
  final int mealCount;
  final int bundleMealCount;
  final String tier;
  final String tierNameAr;
  final String tierNameEn;
  final String? tierLogoUrl;
  final List<SubscriptionTierRestaurantClassificationEntity> classifications;

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;

  String tierName(String localeName) =>
      localeName == 'ar' ? tierNameAr : tierNameEn;
}

class SubscriptionTierRestaurantClassificationEntity {
  const SubscriptionTierRestaurantClassificationEntity({
    required this.logoUrl,
    required this.tier,
  });

  final String? logoUrl;
  final String tier;
}
