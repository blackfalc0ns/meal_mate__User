import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_theme_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_theme_entity.dart';

extension SubscriptionTierResponseDtoMapper on SubscriptionTierResponseDto {
  SubscriptionTierEntity toEntity() {
    return SubscriptionTierEntity(
      tier: tier ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      logoUrl: logoUrl,
      descriptionAr: descriptionAr ?? '',
      descriptionEn: descriptionEn ?? '',
      restaurantCount: restaurantCount ?? 0,
      restaurants: (restaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .toList(),
      durationDays: durationDays,
      totalPrice: totalPrice,
      dailyPrice: dailyPrice,
      priceDifference: priceDifference,
      currencyCode: currencyCode ?? '',
      selectionCount: selectionCount ?? 0,
      isRecommended: isRecommended ?? false,
      includeFriday: includeFriday ?? false,
      fridayDays: fridayDays,
      totalServiceDays: totalServiceDays,
      theme: theme?.toEntity(),
    );
  }
}

extension SubscriptionTierThemeResponseDtoMapper
    on SubscriptionTierThemeResponseDto {
  SubscriptionTierThemeEntity toEntity() {
    return SubscriptionTierThemeEntity(
      designId: designId,
      designName: designName,
    );
  }
}


extension SubscriptionTierRestaurantResponseDtoMapper
    on SubscriptionTierRestaurantResponseDto {
  SubscriptionTierRestaurantEntity toEntity() {
    return SubscriptionTierRestaurantEntity(
      restaurantId: restaurantId ?? '',
      logoUrl: logoUrl,
    );
  }
}
