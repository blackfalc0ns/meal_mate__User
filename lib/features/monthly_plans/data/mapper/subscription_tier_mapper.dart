import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';

extension SubscriptionTierResponseDtoMapper on SubscriptionTierResponseDto {
  SubscriptionTierEntity toEntity() {
    final resolvedNameAr = (nameAr?.trim().isNotEmpty ?? false)
        ? nameAr!.trim()
        : (name?.trim().isNotEmpty ?? false)
            ? name!.trim()
            : '';
    final resolvedNameEn = (nameEn?.trim().isNotEmpty ?? false)
        ? nameEn!.trim()
        : (tier?.trim().isNotEmpty ?? false)
            ? tier!.trim()
            : (name?.trim().isNotEmpty ?? false)
                ? name!.trim()
                : '';
    final resolvedDescAr = (descriptionAr?.trim().isNotEmpty ?? false)
        ? descriptionAr!.trim()
        : (description?.trim().isNotEmpty ?? false)
            ? description!.trim()
            : '';
    final resolvedDescEn = (descriptionEn?.trim().isNotEmpty ?? false)
        ? descriptionEn!.trim()
        : (description?.trim().isNotEmpty ?? false)
            ? description!.trim()
            : '';

    return SubscriptionTierEntity(
      tier: tier ?? '',
      nameAr: resolvedNameAr,
      nameEn: resolvedNameEn,
      logoUrl: logoUrl,
      descriptionAr: resolvedDescAr,
      descriptionEn: resolvedDescEn,
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
