import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_theme_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_theme_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';

extension SubscriptionTierResponseDtoMapper on SubscriptionTierResponseDto {
  SubscriptionTierEntity toEntity() {
    final base = option ?? this;

    return SubscriptionTierEntity(
      tier: base.tier ?? '',
      nameAr: base.nameAr ?? '',
      nameEn: base.nameEn ?? '',
      logoUrl: base.logoUrl,
      descriptionAr: base.descriptionAr ?? '',
      descriptionEn: base.descriptionEn ?? '',
      restaurantCount: base.restaurantCount ?? 0,
      restaurants: (base.restaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .toList(),
      durationDays: base.durationDays,
      totalPrice: base.totalPrice,
      dailyPrice: base.dailyPrice,
      priceDifference: base.priceDifference,
      currencyCode: base.currencyCode ?? '',
      selectionCount: base.selectionCount ?? 0,
      isRecommended: base.isRecommended ?? false,
      includeFriday: base.includeFriday ?? false,
      fridayDays: base.fridayDays,
      totalServiceDays: base.totalServiceDays,
      theme: base.theme?.toEntity(),
      availability: (availability ?? option?.availability)?.toEntity(),
      canSelect: canSelect ?? option?.canSelect ?? true,
      isAvailable: isAvailable ?? option?.isAvailable ?? true,
      disabledReason: disabledReason ?? option?.disabledReason,
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
