import 'package:json_annotation/json_annotation.dart';

part 'offer_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class OfferResponseDto {
  const OfferResponseDto({
    this.id,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.bannerImageUrl,
    this.status,
    this.type,
    this.discountType,
    this.fundingMode,
    this.discountRate,
    this.discountAmount,
    this.discountAmountKwd,
    this.platformShareRate,
    this.restaurantShareRate,
    this.startsAtUtc,
    this.endsAtUtc,
    this.minOrderAmount,
    this.minOrderAmountKwd,
    this.minSubscriptionDays,
    this.maxSubscriptionDays,
    this.totalUsageLimit,
    this.currentUsageCount,
    this.remainingSpots,
    this.perCustomerLimit,
    this.customerSegment,
    this.allowedGovernoratesJson,
    this.campaignId,
    this.allowPromoCodeStacking,
    this.promoCode,
    this.termsAndConditionsAr,
    this.termsAndConditionsEn,
    this.programIds,
    this.bundleIds,
    this.restaurantIds,
    this.allowedDurationDays,
    this.isSaved,
    this.isAvailable,
    this.availabilityReasonCode,
    this.ineligibilityReasonCodes,
    this.eligibleProgramIds,
    this.eligibleBundleIds,
    this.eligibleRestaurantIds,
    this.purchaseMode,
    this.sourceType,
  });

  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? bannerImageUrl;
  final dynamic status;
  final dynamic type;
  final dynamic discountType;
  final dynamic fundingMode;
  final double? discountRate;
  final double? discountAmount;
  final double? discountAmountKwd;
  final double? platformShareRate;
  final double? restaurantShareRate;
  final String? startsAtUtc;
  final String? endsAtUtc;
  final double? minOrderAmount;
  final double? minOrderAmountKwd;
  final int? minSubscriptionDays;
  final int? maxSubscriptionDays;
  final int? totalUsageLimit;
  final int? currentUsageCount;
  final int? remainingSpots;
  final int? perCustomerLimit;
  final dynamic customerSegment;
  final String? allowedGovernoratesJson;
  final String? campaignId;
  final bool? allowPromoCodeStacking;
  final String? promoCode;
  final String? termsAndConditionsAr;
  final String? termsAndConditionsEn;
  final List<String>? programIds;
  final List<String>? bundleIds;
  final List<String>? restaurantIds;
  final List<int>? allowedDurationDays;
  final bool? isSaved;
  final bool? isAvailable;
  final String? availabilityReasonCode;
  final List<String>? ineligibilityReasonCodes;
  final List<String>? eligibleProgramIds;
  final List<String>? eligibleBundleIds;
  final List<String>? eligibleRestaurantIds;
  final String? purchaseMode;
  final String? sourceType;

  List<String>? get resolvedProgramIds => programIds ?? eligibleProgramIds;
  List<String>? get resolvedBundleIds => bundleIds ?? eligibleBundleIds;
  List<String>? get resolvedRestaurantIds =>
      restaurantIds ?? eligibleRestaurantIds;

  factory OfferResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OfferResponseDtoFromJson(json);
}
