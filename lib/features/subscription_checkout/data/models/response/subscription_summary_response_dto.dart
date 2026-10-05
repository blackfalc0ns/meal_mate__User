import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_coupon_response_dto.dart';

part 'subscription_summary_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionSummaryResponseDto {
  const SubscriptionSummaryResponseDto({
    this.programId,
    this.programNameAr,
    this.programNameEn,
    this.programImageUrl,
    this.bundleId,
    this.bundleNameAr,
    this.bundleNameEn,
    this.imageUrl,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    this.restaurantCount,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.durationDays,
    this.chosenStartDate,
    this.startDate,
    this.endDate,
    this.serviceDates,
    this.restaurantRepetition,
    this.slotRequirements,
    this.basePrice,
    this.campaignDiscount,
    this.promoDiscount,
    this.walletCredit,
    this.gatewayFee,
    this.finalPrice,
    this.currencyCode,
    this.canCheckout,
    this.checkoutBlockReason,
    this.address,
    this.restaurants,
    this.termsAcceptanceRequired,
    this.checkoutEndpoint,
    this.includeFriday,
    this.fridayDays,
    this.totalServiceDays,
    this.includes,
    this.coupon,
    this.restaurantsPagination,
  });

  final String? programId;
  final String? programNameAr;
  final String? programNameEn;
  final String? programImageUrl;
  final String? bundleId;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? imageUrl;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final int? restaurantCount;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final int? durationDays;
  final String? chosenStartDate;
  final String? startDate;
  final String? endDate;
  final List<String>? serviceDates;
  final SubscriptionSummaryRestaurantRepetitionResponseDto?
  restaurantRepetition;
  final List<SubscriptionSummarySlotRequirementResponseDto>? slotRequirements;
  final double? basePrice;
  final double? campaignDiscount;
  final double? promoDiscount;
  final double? walletCredit;
  final double? gatewayFee;
  final double? finalPrice;
  final String? currencyCode;
  final bool? canCheckout;
  final String? checkoutBlockReason;
  final SubscriptionSummaryAddressResponseDto? address;
  final List<SubscriptionSummaryRestaurantResponseDto>? restaurants;
  final bool? termsAcceptanceRequired;
  final String? checkoutEndpoint;
  final bool? includeFriday;
  final int? fridayDays;
  final int? totalServiceDays;
  final SubscriptionSummaryIncludesResponseDto? includes;
  final SubscriptionCouponResponseDto? coupon;
  final PaginationResponseDto? restaurantsPagination;

  factory SubscriptionSummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSummaryResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryRestaurantRepetitionResponseDto {
  const SubscriptionSummaryRestaurantRepetitionResponseDto({
    this.limit,
    this.restaurantCount,
    this.durationDays,
  });

  final int? limit;
  final int? restaurantCount;
  final int? durationDays;

  factory SubscriptionSummaryRestaurantRepetitionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryRestaurantRepetitionResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryAddressResponseDto {
  const SubscriptionSummaryAddressResponseDto({
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

  factory SubscriptionSummaryAddressResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryAddressResponseDtoFromJson(json);

}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryRestaurantResponseDto {
  const SubscriptionSummaryRestaurantResponseDto({
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

  factory SubscriptionSummaryRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryRestaurantResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummarySlotRequirementResponseDto {
  const SubscriptionSummarySlotRequirementResponseDto({
    this.slot,
    this.nameAr,
    this.nameEn,
    this.count,
  });

  final String? slot;
  final String? nameAr;
  final String? nameEn;
  final int? count;

  factory SubscriptionSummarySlotRequirementResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummarySlotRequirementResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryIncludesResponseDto {
  const SubscriptionSummaryIncludesResponseDto({
    this.titleAr,
    this.titleEn,
    this.items,
  });

  final String? titleAr;
  final String? titleEn;
  final List<SubscriptionSummaryIncludeItemResponseDto>? items;

  factory SubscriptionSummaryIncludesResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryIncludesResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryIncludeItemResponseDto {
  const SubscriptionSummaryIncludeItemResponseDto({
    this.code,
    this.textAr,
    this.textEn,
  });

  final String? code;
  final String? textAr;
  final String? textEn;

  factory SubscriptionSummaryIncludeItemResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryIncludeItemResponseDtoFromJson(json);
}
