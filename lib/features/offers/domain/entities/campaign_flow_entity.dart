class CampaignBlockingReasonEntity {
  const CampaignBlockingReasonEntity({
    this.code,
    this.messageAr,
    this.messageEn,
    this.action,
  });
  final String? code;
  final String? messageAr;
  final String? messageEn;
  final String? action;
}

class CampaignListItemEntity {
  const CampaignListItemEntity({
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
}

class CampaignOptionEntity {
  const CampaignOptionEntity({
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
}

class CampaignDetailsEntity {
  const CampaignDetailsEntity({
    this.campaignId,
    this.canCheckout,
    this.remainingSubscriberSlots,
    this.blockingReasons = const [],
    this.options = const [],
  });
  final String? campaignId;
  final bool? canCheckout;
  final int? remainingSubscriberSlots;
  final List<CampaignBlockingReasonEntity> blockingReasons;
  final List<CampaignOptionEntity> options;
}

class CampaignPriceEntity {
  const CampaignPriceEntity({
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
}

class CampaignCouponEntity {
  const CampaignCouponEntity({
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
}

class CampaignQuoteEntity {
  const CampaignQuoteEntity({
    this.quoteId,
    this.canCheckout,
    this.price,
    this.expiresAtUtc,
    this.coupon,
    this.blockingReasons = const [],
  });
  final String? quoteId;
  final bool? canCheckout;
  final CampaignPriceEntity? price;
  final String? expiresAtUtc;
  final CampaignCouponEntity? coupon;
  final List<CampaignBlockingReasonEntity> blockingReasons;
  bool get isUsable =>
      canCheckout == true &&
      quoteId?.isNotEmpty == true &&
      quoteId != '00000000-0000-0000-0000-000000000000' &&
      price?.finalPrice != null &&
      expiresAtUtc != null &&
      blockingReasons.isEmpty;
}

class CampaignPageEntity {
  const CampaignPageEntity({this.items = const [], this.nextCursor});
  final List<CampaignListItemEntity> items;
  final String? nextCursor;
}
