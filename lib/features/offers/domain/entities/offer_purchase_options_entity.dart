class OfferPurchaseOptionsEntity {
  const OfferPurchaseOptionsEntity({
    required this.offerId,
    required this.subscriptionType,
    required this.options,
    required this.blockingReasons,
    this.familyFlowDestination,
    this.serverNowUtc,
  });

  final String offerId;
  final String subscriptionType;
  final List<OfferPurchaseOptionEntity> options;
  final List<OfferPurchaseBlockingReasonEntity> blockingReasons;
  final String? familyFlowDestination;
  final DateTime? serverNowUtc;
  bool get isFamily => subscriptionType.toLowerCase() == 'family';
}

class OfferPurchaseBlockingReasonEntity {
  const OfferPurchaseBlockingReasonEntity({
    required this.code,
    this.messageAr,
    this.messageEn,
    this.field,
  });
  final String code;
  final String? messageAr;
  final String? messageEn;
  final String? field;
}

class OfferPurchaseOptionEntity {
  const OfferPurchaseOptionEntity({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.startDate,
    required this.includeFriday,
    required this.canCheckout,
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.tierNameAr,
    this.tierNameEn,
    this.imageUrl,
    this.endDate,
    this.totalServiceDays,
    this.mealsPerDay,
    this.basePrice,
    this.finalPrice,
    this.currencyCode,
    this.blockingReasons = const [],
  });

  final String programId;
  final String bundleId;
  final String tier;
  final int durationDays;
  final String startDate;
  final bool includeFriday;
  final bool canCheckout;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? imageUrl;
  final String? endDate;
  final int? totalServiceDays;
  final int? mealsPerDay;
  final double? basePrice;
  final double? finalPrice;
  final String? currencyCode;
  final List<OfferPurchaseBlockingReasonEntity> blockingReasons;

  String get selectionKey =>
      '$programId|$bundleId|$tier|$durationDays|$startDate|$includeFriday';
}
