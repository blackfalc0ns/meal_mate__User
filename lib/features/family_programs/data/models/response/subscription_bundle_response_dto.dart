import 'package:json_annotation/json_annotation.dart';

part 'subscription_bundle_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyBundleResponseDto {
  const FamilyBundleResponseDto({
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
  final List<FamilyBundleSlotRequirementResponseDto>? slotRequirements;
  final int? sortOrder;
  final String? descriptionAr;
  final String? descriptionEn;
  final List<FamilyBundleSlotResponseDto>? slots;
  final int? restaurantCount;
  final List<FamilyBundleRestaurantResponseDto>? restaurants;
  final int? selectionCount;
  final bool? isMostSelected;
  final FamilyBundleBadgeResponseDto? badge;

  factory FamilyBundleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyBundleResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyProgramBundlesResponseDto {
  const FamilyProgramBundlesResponseDto({
    this.hasDeliveryAddress,
    this.hasAllergies,
    this.hasDietaryPreferences,
    this.isProfileComplete,
    this.bundles,
  });

  final bool? hasDeliveryAddress;
  final bool? hasAllergies;
  final bool? hasDietaryPreferences;
  final bool? isProfileComplete;
  final List<FamilyBundleResponseDto>? bundles;

  factory FamilyProgramBundlesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyProgramBundlesResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyBundleSlotRequirementResponseDto {
  const FamilyBundleSlotRequirementResponseDto({this.slot, this.count});

  final String? slot;
  final int? count;

  factory FamilyBundleSlotRequirementResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyBundleSlotRequirementResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyBundleSlotResponseDto {
  const FamilyBundleSlotResponseDto({
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

  factory FamilyBundleSlotResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyBundleSlotResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyBundleRestaurantResponseDto {
  const FamilyBundleRestaurantResponseDto({
    this.restaurantId,
    this.logoUrl,
  });

  final String? restaurantId;
  final String? logoUrl;

  factory FamilyBundleRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyBundleRestaurantResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyBundleBadgeResponseDto {
  const FamilyBundleBadgeResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory FamilyBundleBadgeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyBundleBadgeResponseDtoFromJson(json);
}
