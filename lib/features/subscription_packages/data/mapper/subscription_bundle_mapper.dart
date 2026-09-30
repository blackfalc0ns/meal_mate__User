import 'package:meal_meat_user/features/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';

extension SubscriptionBundleResponseDtoMapper on SubscriptionBundleResponseDto {
  SubscriptionBundleEntity toEntity() {
    return SubscriptionBundleEntity(
      bundleId: bundleId ?? '',
      programId: programId ?? '',
      code: code ?? '',
      nameAr: nameAr ?? name ?? '',
      nameEn: nameEn ?? name ?? '',
      descriptionAr: descriptionAr ?? description ?? '',
      descriptionEn: descriptionEn ?? description ?? '',
      imageUrl: imageUrl,
      mealsPerDay: mealsPerDay ?? 0,
      breakfastCount: breakfastCount ?? 0,
      lunchCount: lunchCount ?? 0,
      dinnerCount: dinnerCount ?? 0,
      snackCount: snackCount ?? 0,
      slots: (slots ?? const []).map((slot) => slot.toEntity()).toList(),
      restaurantCount: restaurantCount ?? 0,
      restaurants: (restaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .toList(),
      selectionCount: selectionCount ?? 0,
      isMostSelected: isMostSelected ?? false,
      badge: badge?.toEntity(),
    );
  }
}

extension SubscriptionProgramBundlesResponseDtoMapper
    on SubscriptionProgramBundlesResponseDto {
  SubscriptionProgramBundlesEntity toProgramBundlesEntity() {
    return SubscriptionProgramBundlesEntity(
      hasDeliveryAddress: hasDeliveryAddress ?? false,
      hasAllergies: hasAllergies ?? false,
      hasDietaryPreferences: hasDietaryPreferences ?? false,
      isProfileComplete: isProfileComplete ?? false,
      bundles: (bundles ?? const []).map((item) => item.toEntity()).toList(),
    );
  }
}

extension SubscriptionBundleSlotResponseDtoMapper
    on SubscriptionBundleSlotResponseDto {
  SubscriptionBundleSlotEntity toEntity() {
    return SubscriptionBundleSlotEntity(
      code: code ?? '',
      nameAr: nameAr ?? name ?? '',
      nameEn: nameEn ?? name ?? '',
      quantity: quantity ?? 0,
    );
  }
}

extension SubscriptionBundleRestaurantResponseDtoMapper
    on SubscriptionBundleRestaurantResponseDto {
  SubscriptionBundleRestaurantEntity toEntity() {
    return SubscriptionBundleRestaurantEntity(
      restaurantId: restaurantId ?? '',
      logoUrl: logoUrl,
    );
  }
}

extension SubscriptionBundleBadgeResponseDtoMapper
    on SubscriptionBundleBadgeResponseDto {
  SubscriptionBundleBadgeEntity toEntity() {
    return SubscriptionBundleBadgeEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}
