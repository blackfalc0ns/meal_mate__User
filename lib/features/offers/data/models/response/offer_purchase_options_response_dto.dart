import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';

part 'offer_purchase_options_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class OfferDetailsResponseDto {
  const OfferDetailsResponseDto({
    this.offer,
    this.serverNowUtc,
    this.currencyCode,
    this.moneyScale,
  });

  final OfferResponseDto? offer;
  final String? serverNowUtc;
  final String? currencyCode;
  final int? moneyScale;

  factory OfferDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OfferDetailsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OfferPurchaseOptionsResponseDto {
  const OfferPurchaseOptionsResponseDto({
    this.offerId,
    this.subscriptionType,
    this.serverNowUtc,
    this.prerequisites,
    this.blockingReasons,
    this.options,
    this.familyFlowDestination,
  });

  final String? offerId;
  final String? subscriptionType;
  final String? serverNowUtc;
  final OfferPurchasePrerequisitesDto? prerequisites;
  final List<OfferPurchaseBlockingReasonDto>? blockingReasons;
  final List<OfferPurchaseOptionDto>? options;
  final String? familyFlowDestination;

  factory OfferPurchaseOptionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OfferPurchaseOptionsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OfferPurchasePrerequisitesDto {
  const OfferPurchasePrerequisitesDto({
    this.isComplete,
    this.hasDeliveryAddress,
    this.hasAllergies,
    this.hasDietaryPreferences,
    this.deliveryRegionId,
  });

  final bool? isComplete;
  final bool? hasDeliveryAddress;
  final bool? hasAllergies;
  final bool? hasDietaryPreferences;
  final String? deliveryRegionId;

  factory OfferPurchasePrerequisitesDto.fromJson(Map<String, dynamic> json) =>
      _$OfferPurchasePrerequisitesDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OfferPurchaseBlockingReasonDto {
  const OfferPurchaseBlockingReasonDto({
    this.code,
    this.messageAr,
    this.messageEn,
    this.field,
  });

  final String? code;
  final String? messageAr;
  final String? messageEn;
  final String? field;

  factory OfferPurchaseBlockingReasonDto.fromJson(Map<String, dynamic> json) =>
      _$OfferPurchaseBlockingReasonDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OfferPurchaseOptionDto {
  const OfferPurchaseOptionDto({
    this.programId,
    this.programNameAr,
    this.programNameEn,
    this.bundleId,
    this.bundleNameAr,
    this.bundleNameEn,
    this.imageUrl,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.durationDays,
    this.startDate,
    this.endDate,
    this.includeFriday,
    this.totalServiceDays,
    this.mealsPerDay,
    this.basePrice,
    this.campaignDiscount,
    this.promoDiscount,
    this.walletCredit,
    this.gatewayFee,
    this.finalPrice,
    this.currencyCode,
    this.canCheckout,
    this.blockingReasons,
  });

  final String? programId;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleId;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? imageUrl;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final int? durationDays;
  final String? startDate;
  final String? endDate;
  final bool? includeFriday;
  final int? totalServiceDays;
  final int? mealsPerDay;
  final double? basePrice;
  final double? campaignDiscount;
  final double? promoDiscount;
  final double? walletCredit;
  final double? gatewayFee;
  final double? finalPrice;
  final String? currencyCode;
  final bool? canCheckout;
  final List<OfferPurchaseBlockingReasonDto>? blockingReasons;

  factory OfferPurchaseOptionDto.fromJson(Map<String, dynamic> json) =>
      _$OfferPurchaseOptionDtoFromJson(json);
}
