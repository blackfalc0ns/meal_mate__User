import 'package:json_annotation/json_annotation.dart';

part 'subscription_summary_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionSummaryResponseDto {
  const SubscriptionSummaryResponseDto({
    this.programId,
    this.programNameAr,
    this.programNameEn,
    this.bundleId,
    this.bundleNameAr,
    this.bundleNameEn,
    this.imageUrl,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    this.restaurantCount,
    this.tier,
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
  });

  final String? programId;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleId;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? imageUrl;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final int? restaurantCount;
  final String? tier;
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

  factory SubscriptionSummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSummaryResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummarySlotRequirementResponseDto {
  const SubscriptionSummarySlotRequirementResponseDto({this.slot, this.count});

  final String? slot;
  final int? count;

  factory SubscriptionSummarySlotRequirementResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummarySlotRequirementResponseDtoFromJson(json);
}
