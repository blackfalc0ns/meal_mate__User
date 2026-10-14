import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_theme_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_theme_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';

extension SubscriptionTierResponseDtoMapper on SubscriptionTierResponseDto {
  SubscriptionTierEntity toEntity() {
    final base = option ?? this;

    final resolvedNameAr = (base.nameAr?.trim().isNotEmpty ?? false)
        ? base.nameAr!.trim()
        : (base.name?.trim().isNotEmpty ?? false)
            ? base.name!.trim()
            : '';
    final resolvedNameEn = (base.nameEn?.trim().isNotEmpty ?? false)
        ? base.nameEn!.trim()
        : (base.tier?.trim().isNotEmpty ?? false)
            ? base.tier!.trim()
            : (base.name?.trim().isNotEmpty ?? false)
                ? base.name!.trim()
                : '';
    final resolvedDescAr = (base.descriptionAr?.trim().isNotEmpty ?? false)
        ? base.descriptionAr!.trim()
        : (base.description?.trim().isNotEmpty ?? false)
            ? base.description!.trim()
            : '';
    final resolvedDescEn = (base.descriptionEn?.trim().isNotEmpty ?? false)
        ? base.descriptionEn!.trim()
        : (base.description?.trim().isNotEmpty ?? false)
            ? base.description!.trim()
            : '';

    return SubscriptionTierEntity(
      tier: base.tier ?? '',
      nameAr: resolvedNameAr,
      nameEn: resolvedNameEn,
      logoUrl: base.logoUrl,
      descriptionAr: resolvedDescAr,
      descriptionEn: resolvedDescEn,
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
      durationPrices: base.durationPrices
          ?.map((dp) => dp.toEntity())
          .toList(),
    );
  }
}

extension DurationPriceResponseDtoMapper on DurationPriceResponseDto {
  DurationPriceEntity toEntity() {
    return DurationPriceEntity(
      durationDays: durationDays ?? 0,
      totalPrice: totalPrice ?? 0.0,
      dailyPrice: dailyPrice ?? 0.0,
      currencyCode: currencyCode ?? '',
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
