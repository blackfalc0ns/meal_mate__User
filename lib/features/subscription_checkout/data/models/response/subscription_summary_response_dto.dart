import 'package:json_annotation/json_annotation.dart';

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
    this.startDate,
    this.endDate,
    this.serviceDates,
    this.slotRequirements,
    this.basePrice,
    this.campaignDiscount,
    this.promoDiscount,
    this.walletCredit,
    this.gatewayFee,
    this.finalPrice,
    this.currencyCode,
    this.termsAcceptanceRequired,
    this.checkoutEndpoint,
    this.includeFriday,
    this.fridayDays,
    this.totalServiceDays,
    this.includes,
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
  final String? startDate;
  final String? endDate;
  final List<String>? serviceDates;
  final List<SubscriptionSummarySlotRequirementResponseDto>? slotRequirements;
  final double? basePrice;
  final double? campaignDiscount;
  final double? promoDiscount;
  final double? walletCredit;
  final double? gatewayFee;
  final double? finalPrice;
  final String? currencyCode;
  final bool? termsAcceptanceRequired;
  final String? checkoutEndpoint;
  final bool? includeFriday;
  final int? fridayDays;
  final int? totalServiceDays;
  final SubscriptionSummaryIncludesResponseDto? includes;

  factory SubscriptionSummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSummaryResponseDtoFromJson(json);
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
