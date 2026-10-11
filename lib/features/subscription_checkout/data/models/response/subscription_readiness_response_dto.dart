import 'package:json_annotation/json_annotation.dart';

part 'subscription_readiness_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionReadinessResponseDto {
  const SubscriptionReadinessResponseDto({
    this.isComplete,
    this.canOpenSummary,
    this.canCheckout,
    this.nextAction,
    this.warningAr,
    this.warningEn,
    this.checkoutBlockReason,
    this.program,
    this.address,
    this.deliveringRestaurantCount,
    this.items,
    this.restaurants,
  });

  final bool? isComplete;
  final bool? canOpenSummary;
  final bool? canCheckout;
  final String? nextAction;
  final String? warningAr;
  final String? warningEn;
  final String? checkoutBlockReason;
  final SubscriptionReadinessProgramResponseDto? program;
  final SubscriptionReadinessAddressResponseDto? address;
  final int? deliveringRestaurantCount;
  final List<SubscriptionReadinessItemResponseDto>? items;
  final List<SubscriptionReadinessRestaurantResponseDto>? restaurants;

  factory SubscriptionReadinessResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionReadinessResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionReadinessProgramResponseDto {
  const SubscriptionReadinessProgramResponseDto({
    this.programId,
    this.nameAr,
    this.nameEn,
  });

  final String? programId;
  final String? nameAr;
  final String? nameEn;

  factory SubscriptionReadinessProgramResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionReadinessProgramResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionReadinessAddressResponseDto {
  const SubscriptionReadinessAddressResponseDto({
    this.id,
    this.label,
    this.addressLine,
    this.governorate,
    this.area,
    this.block,
    this.regionId,
    this.governorateNameAr,
    this.governorateNameEn,
    this.areaNameAr,
    this.areaNameEn,
    this.blockNameAr,
    this.blockNameEn,
  });

  final String? id;
  final String? label;
  final String? addressLine;
  final String? governorate;
  final String? area;
  final String? block;
  final String? regionId;
  final String? governorateNameAr;
  final String? governorateNameEn;
  final String? areaNameAr;
  final String? areaNameEn;
  final String? blockNameAr;
  final String? blockNameEn;

  factory SubscriptionReadinessAddressResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionReadinessAddressResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionReadinessItemResponseDto {
  const SubscriptionReadinessItemResponseDto({
    this.code,
    this.isComplete,
    this.titleAr,
    this.titleEn,
    this.actionScreen,
    this.endpoint,
  });

  final String? code;
  final bool? isComplete;
  final String? titleAr;
  final String? titleEn;
  final String? actionScreen;
  final String? endpoint;

  factory SubscriptionReadinessItemResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionReadinessItemResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionReadinessRestaurantResponseDto {
  const SubscriptionReadinessRestaurantResponseDto({
    this.restaurantId,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.tier,
  });

  final String? restaurantId;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final String? tier;

  factory SubscriptionReadinessRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionReadinessRestaurantResponseDtoFromJson(json);
}
