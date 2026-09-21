import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_restaurant_browse_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';

extension SubscriptionTierRestaurantBrowseResponseDtoMapper
    on SubscriptionTierRestaurantBrowseResponseDto {
  SubscriptionTierRestaurantBrowseEntity toEntity() {
    return SubscriptionTierRestaurantBrowseEntity(
      restaurantId: restaurantId ?? '',
      nameRaw: name ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      logoUrl: logoUrl,
      rating: rating,
      mealCount: mealCount ?? 0,
      bundleMealCount: bundleMealCount ?? 0,
      tier: tier ?? '',
      tierNameRaw: tierName ?? '',
      tierNameAr: tierNameAr ?? '',
      tierNameEn: tierNameEn ?? '',
      tierLogoUrl: tierLogoUrl,
      classifications: (classifications ?? const [])
          .map((classification) => classification.toEntity())
          .toList(),
    );
  }
}

extension SubscriptionTierRestaurantClassificationResponseDtoMapper
    on SubscriptionTierRestaurantClassificationResponseDto {
  SubscriptionTierRestaurantClassificationEntity toEntity() {
    return SubscriptionTierRestaurantClassificationEntity(
      logoUrl: logoUrl,
      tier: tier ?? '',
    );
  }
}
