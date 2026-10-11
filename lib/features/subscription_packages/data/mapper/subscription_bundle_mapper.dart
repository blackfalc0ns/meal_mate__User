import 'package:meal_meat_user/core/network/mapper/pagination_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';
import 'package:meal_meat_user/features/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';

extension SubscriptionBundleResponseDtoMapper on SubscriptionBundleResponseDto {
  SubscriptionBundleEntity toEntity() {
    final base = option ?? this;

    return SubscriptionBundleEntity(
      bundleId: base.bundleId ?? '',
      programId: base.programId ?? '',
      code: base.code ?? '',
      nameAr: base.nameAr ?? base.name ?? '',
      nameEn: base.nameEn ?? base.name ?? '',
      descriptionAr: base.descriptionAr ?? base.description ?? '',
      descriptionEn: base.descriptionEn ?? base.description ?? '',
      imageUrl: base.imageUrl,
      mealsPerDay: base.mealsPerDay ?? 0,
      breakfastCount: base.breakfastCount ?? 0,
      lunchCount: base.lunchCount ?? 0,
      dinnerCount: base.dinnerCount ?? 0,
      snackCount: base.snackCount ?? 0,
      slots: (base.slots ?? const [])
          .whereType<SubscriptionBundleSlotResponseDto>()
          .map((slot) => slot.toEntity())
          .toList(),
      restaurantCount: base.restaurantCount ?? 0,
      restaurants: (base.restaurants ?? const [])
          .whereType<SubscriptionBundleRestaurantResponseDto>()
          .map((restaurant) => restaurant.toEntity())
          .toList(),
      selectionCount: base.selectionCount ?? 0,
      isMostSelected: base.isMostSelected ?? false,
      badge: base.badge?.toEntity(),
      isAvailable: isAvailable ?? option?.isAvailable ?? true,
      disabledReason: disabledReason ?? option?.disabledReason,
      availability: (availability ?? option?.availability)?.toEntity(),
    );
  }
}

extension SubscriptionProgramBundlesResponseDtoMapper
    on SubscriptionProgramBundlesResponseDto {
  SubscriptionProgramBundlesEntity toProgramBundlesEntity() {
    return SubscriptionProgramBundlesEntity(
      hasDeliveryAddress: hasDeliveryAddress ?? false,
      hasAllergies:
          hasAllergies ?? (allergiesCompletedAtUtc?.isNotEmpty == true),
      hasDietaryPreferences:
          hasDietaryPreferences ??
          (dietaryPreferencesCompletedAtUtc?.isNotEmpty == true),
      isProfileComplete: isProfileComplete ?? false,
      allergiesCompletedAtUtc: allergiesCompletedAtUtc,
      dietaryPreferencesCompletedAtUtc: dietaryPreferencesCompletedAtUtc,
      bundles: effectiveBundles
          .whereType<SubscriptionBundleResponseDto>()
          .map((item) => item.toEntity())
          .toList(),
      pagination: pagination?.toEntity(),
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
