import 'package:json_annotation/json_annotation.dart';
part 'campaign_flow_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CampaignBlockingReasonResponseDto {
  const CampaignBlockingReasonResponseDto({
    this.code,
    this.messageAr,
    this.messageEn,
    this.action,
  });
  final String? code;
  final String? messageAr;
  final String? messageEn;
  final String? action;
  factory CampaignBlockingReasonResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CampaignBlockingReasonResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CampaignListItemResponseDto {
  const CampaignListItemResponseDto({
    this.campaignId,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.startsAtUtc,
    this.endsAtUtc,
    this.minPrice,
    this.minPriceCampaignBundleId,
    this.minPriceDurationDays,
    this.currencyCode,
    this.remainingSubscriberSlots,
    this.fullSequenceAvailable,
  });
  final String? campaignId;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? startsAtUtc;
  final String? endsAtUtc;
  final double? minPrice;
  final String? minPriceCampaignBundleId;
  final int? minPriceDurationDays;
  final String? currencyCode;
  final int? remainingSubscriberSlots;
  final bool? fullSequenceAvailable;
  factory CampaignListItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignListItemResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CampaignOptionResponseDto {
  const CampaignOptionResponseDto({
    this.campaignBundleId,
    this.catalogBundleId,
    this.programId,
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.bundleDescriptionAr,
    this.bundleDescriptionEn,
    this.durationDays,
    this.referencePrice,
    this.finalPrice,
    this.currencyCode,
    this.customerDiscountPercent,
    this.canShowReferencePrice,
    this.fullSequenceAvailable,
  });
  final String? campaignBundleId;
  final String? catalogBundleId;
  final String? programId;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? bundleDescriptionAr;
  final String? bundleDescriptionEn;
  final int? durationDays;
  final double? referencePrice;
  final double? finalPrice;
  final String? currencyCode;
  final double? customerDiscountPercent;
  final bool? canShowReferencePrice;
  final bool? fullSequenceAvailable;
  factory CampaignOptionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignOptionResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CampaignDetailsResponseDto {
  const CampaignDetailsResponseDto({
    this.campaignId,
    this.canCheckout,
    this.remainingSubscriberSlots,
    this.blockingReasons,
    this.options,
  });
  final String? campaignId;
  final bool? canCheckout;
  final int? remainingSubscriberSlots;
  final List<CampaignBlockingReasonResponseDto>? blockingReasons;
  final List<CampaignOptionResponseDto>? options;
  factory CampaignDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignDetailsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CampaignPriceResponseDto {
  const CampaignPriceResponseDto({
    this.referencePrice,
    this.discountAmount,
    this.finalPrice,
    this.currencyCode,
    this.customerDiscountPercent,
    this.canShowReferencePrice,
  });
  final double? referencePrice;
  final double? discountAmount;
  final double? finalPrice;
  final String? currencyCode;
  final double? customerDiscountPercent;
  final bool? canShowReferencePrice;
  factory CampaignPriceResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignPriceResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CampaignCouponResponseDto {
  const CampaignCouponResponseDto({
    this.code,
    this.status,
    this.discountAmount,
    this.messageAr,
    this.messageEn,
  });
  final String? code;
  final String? status;
  final double? discountAmount;
  final String? messageAr;
  final String? messageEn;
  factory CampaignCouponResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignCouponResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CampaignQuoteResponseDto {
  const CampaignQuoteResponseDto({
    this.quoteId,
    this.canCheckout,
    this.price,
    this.expiresAtUtc,
    this.coupon,
    this.blockingReasons,
  });
  final String? quoteId;
  final bool? canCheckout;
  final CampaignPriceResponseDto? price;
  final String? expiresAtUtc;
  final CampaignCouponResponseDto? coupon;
  final List<CampaignBlockingReasonResponseDto>? blockingReasons;
  factory CampaignQuoteResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignQuoteResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CampaignPageResponseDto {
  const CampaignPageResponseDto({this.items, this.nextCursor});
  final List<CampaignListItemResponseDto>? items;
  final String? nextCursor;
  factory CampaignPageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignPageResponseDtoFromJson(json);
}
