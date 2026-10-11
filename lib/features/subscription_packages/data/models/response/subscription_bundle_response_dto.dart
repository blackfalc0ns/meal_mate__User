import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';

part 'subscription_bundle_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionBundleResponseDto {
  const SubscriptionBundleResponseDto({
    this.bundleId,
    this.programId,
    this.code,
    this.nameAr,
    this.nameEn,
    this.name,
    this.description,
    this.imageUrl,
    this.mealsPerDay,
    this.breakfastCount,
    this.lunchCount,
    this.dinnerCount,
    this.snackCount,
    this.slotRequirements,
    this.sortOrder,
    this.descriptionAr,
    this.descriptionEn,
    this.slots,
    this.restaurantCount,
    this.restaurants,
    this.selectionCount,
    this.isMostSelected,
    this.badge,
    this.isAvailable,
    this.disabledReason,
    this.availability,
    this.option,
  });

  final String? bundleId;
  final String? programId;
  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final String? description;
  final String? imageUrl;
  final int? mealsPerDay;
  final int? breakfastCount;
  final int? lunchCount;
  final int? dinnerCount;
  final int? snackCount;
  final List<SubscriptionBundleSlotRequirementResponseDto>? slotRequirements;
  final int? sortOrder;
  final String? descriptionAr;
  final String? descriptionEn;
  final List<SubscriptionBundleSlotResponseDto>? slots;
  final int? restaurantCount;
  final List<SubscriptionBundleRestaurantResponseDto>? restaurants;
  final int? selectionCount;
  final bool? isMostSelected;
  final SubscriptionBundleBadgeResponseDto? badge;
  final bool? isAvailable;
  final String? disabledReason;
  final SubscriptionAvailabilityResponseDto? availability;
  final SubscriptionBundleResponseDto? option;

  factory SubscriptionBundleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionBundleResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionProgramBundlesResponseDto {
  const SubscriptionProgramBundlesResponseDto({
    this.hasDeliveryAddress,
    this.hasAllergies,
    this.hasDietaryPreferences,
    this.isProfileComplete,
    this.allergiesCompletedAtUtc,
    this.dietaryPreferencesCompletedAtUtc,
    this.bundles,
    this.items,
    this.pagination,
  });

  final bool? hasDeliveryAddress;
  final bool? hasAllergies;
  final bool? hasDietaryPreferences;
  final bool? isProfileComplete;
  final String? allergiesCompletedAtUtc;
  final String? dietaryPreferencesCompletedAtUtc;
  final List<SubscriptionBundleResponseDto>? bundles;
  final List<SubscriptionBundleResponseDto>? items;
  final PaginationResponseDto? pagination;

  List<SubscriptionBundleResponseDto> get effectiveBundles =>
      items ?? bundles ?? const [];

  factory SubscriptionProgramBundlesResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    final parsed = _$SubscriptionProgramBundlesResponseDtoFromJson(json);
    return SubscriptionProgramBundlesResponseDto(
      hasDeliveryAddress: parsed.hasDeliveryAddress,
      hasAllergies: parsed.hasAllergies,
      hasDietaryPreferences: parsed.hasDietaryPreferences,
      isProfileComplete: parsed.isProfileComplete,
      allergiesCompletedAtUtc:
          (json['allergiesCompletedAtUtc'] ?? json['AllergiesCompletedAtUtc'])
              as String?,
      dietaryPreferencesCompletedAtUtc:
          (json['dietaryPreferencesCompletedAtUtc'] ??
                  json['DietaryPreferencesCompletedAtUtc'])
              as String?,
      bundles: parsed.bundles,
      items: parsed.items,
      pagination: parsed.pagination,
    );
  }
}

@JsonSerializable(createToJson: false)
class SubscriptionBundleSlotRequirementResponseDto {
  const SubscriptionBundleSlotRequirementResponseDto({this.slot, this.count});

  final String? slot;
  final int? count;

  factory SubscriptionBundleSlotRequirementResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBundleSlotRequirementResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionBundleSlotResponseDto {
  const SubscriptionBundleSlotResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
    this.name,
    this.quantity,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final int? quantity;

  factory SubscriptionBundleSlotResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBundleSlotResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionBundleRestaurantResponseDto {
  const SubscriptionBundleRestaurantResponseDto({
    this.restaurantId,
    this.logoUrl,
  });

  final String? restaurantId;
  final String? logoUrl;

  factory SubscriptionBundleRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBundleRestaurantResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionBundleBadgeResponseDto {
  const SubscriptionBundleBadgeResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory SubscriptionBundleBadgeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionBundleBadgeResponseDtoFromJson(json);
}
