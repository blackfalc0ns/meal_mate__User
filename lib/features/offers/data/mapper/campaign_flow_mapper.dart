import 'package:meal_meat_user/features/offers/data/models/response/campaign_flow_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';

extension CampaignBlockingReasonMapper on CampaignBlockingReasonResponseDto {
  CampaignBlockingReasonEntity toEntity() => CampaignBlockingReasonEntity(
    code: code,
    messageAr: messageAr,
    messageEn: messageEn,
    action: action,
  );
}

extension CampaignListItemMapper on CampaignListItemResponseDto {
  CampaignListItemEntity toEntity() => CampaignListItemEntity(
    campaignId: campaignId,
    nameAr: nameAr,
    nameEn: nameEn,
    descriptionAr: descriptionAr,
    descriptionEn: descriptionEn,
    startsAtUtc: startsAtUtc,
    endsAtUtc: endsAtUtc,
    minPrice: minPrice,
    minPriceCampaignBundleId: minPriceCampaignBundleId,
    minPriceDurationDays: minPriceDurationDays,
    currencyCode: currencyCode,
    remainingSubscriberSlots: remainingSubscriberSlots,
    fullSequenceAvailable: fullSequenceAvailable,
  );
}

extension CampaignOptionMapper on CampaignOptionResponseDto {
  CampaignOptionEntity toEntity() => CampaignOptionEntity(
    campaignBundleId: campaignBundleId,
    catalogBundleId: catalogBundleId,
    programId: programId,
    programNameAr: programNameAr,
    programNameEn: programNameEn,
    bundleNameAr: bundleNameAr,
    bundleNameEn: bundleNameEn,
    bundleDescriptionAr: bundleDescriptionAr,
    bundleDescriptionEn: bundleDescriptionEn,
    durationDays: durationDays,
    referencePrice: referencePrice,
    finalPrice: finalPrice,
    currencyCode: currencyCode,
    customerDiscountPercent: customerDiscountPercent,
    canShowReferencePrice: canShowReferencePrice,
    fullSequenceAvailable: fullSequenceAvailable,
  );
}

extension CampaignDetailsMapper on CampaignDetailsResponseDto {
  CampaignDetailsEntity toEntity() => CampaignDetailsEntity(
    campaignId: campaignId,
    canCheckout: canCheckout,
    remainingSubscriberSlots: remainingSubscriberSlots,
    blockingReasons:
        blockingReasons?.map((item) => item.toEntity()).toList() ?? const [],
    options: options?.map((item) => item.toEntity()).toList() ?? const [],
  );
}

extension CampaignPriceMapper on CampaignPriceResponseDto {
  CampaignPriceEntity toEntity() => CampaignPriceEntity(
    referencePrice: referencePrice,
    discountAmount: discountAmount,
    finalPrice: finalPrice,
    currencyCode: currencyCode,
    customerDiscountPercent: customerDiscountPercent,
    canShowReferencePrice: canShowReferencePrice,
  );
}

extension CampaignCouponMapper on CampaignCouponResponseDto {
  CampaignCouponEntity toEntity() => CampaignCouponEntity(
    code: code,
    status: status,
    discountAmount: discountAmount,
    messageAr: messageAr,
    messageEn: messageEn,
  );
}

extension CampaignQuoteMapper on CampaignQuoteResponseDto {
  CampaignQuoteEntity toEntity() => CampaignQuoteEntity(
    quoteId: quoteId,
    canCheckout: canCheckout,
    price: price?.toEntity(),
    expiresAtUtc: expiresAtUtc,
    coupon: coupon?.toEntity(),
    blockingReasons:
        blockingReasons?.map((item) => item.toEntity()).toList() ?? const [],
  );
}

extension CampaignPageMapper on CampaignPageResponseDto {
  CampaignPageEntity toEntity() => CampaignPageEntity(
    items: items?.map((item) => item.toEntity()).toList() ?? const [],
    nextCursor: nextCursor,
  );
}
