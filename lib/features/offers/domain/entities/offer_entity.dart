enum OfferPurchaseMode { directPurchase, couponOnly, unknown }

class OfferEntity {
  const OfferEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.bannerImageUrl,
    this.discountRate,
    this.discountAmount,
    this.startsAt,
    this.endsAt,
    this.serverNowUtc,
    this.serverObservedAtUtc,
    this.remainingSpots,
    this.minSubscriptionDays,
    this.campaignId,
    this.sourceType,
    this.promoCode,
    this.allowStacking = false,
    this.termsAndConditionsAr,
    this.termsAndConditionsEn,
    this.programIds = const [],
    this.bundleIds = const [],
    this.restaurantIds = const [],
    this.allowedDurationDays = const [],
    this.isSaved = false,
    this.isAvailable = true,
    this.purchaseMode = OfferPurchaseMode.unknown,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String? bannerImageUrl;
  final double? discountRate;
  final double? discountAmount;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? serverNowUtc;
  final DateTime? serverObservedAtUtc;
  final int? remainingSpots;
  final int? minSubscriptionDays;
  final String? campaignId;
  final String? sourceType;

  bool get isCampaign =>
      (campaignId != null && campaignId!.isNotEmpty) ||
      sourceType == 'Campaign';
  final String? promoCode;
  final bool allowStacking;
  final String? termsAndConditionsAr;
  final String? termsAndConditionsEn;
  final List<String> programIds;
  final List<String> bundleIds;
  final List<String> restaurantIds;
  final List<int> allowedDurationDays;
  final bool isSaved;
  final bool isAvailable;
  final OfferPurchaseMode purchaseMode;

  bool get isDirectPurchase => purchaseMode == OfferPurchaseMode.directPurchase;
  bool get isCouponOnly => purchaseMode == OfferPurchaseMode.couponOnly;

  OfferEntity copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    String? bannerImageUrl,
    double? discountRate,
    double? discountAmount,
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? serverNowUtc,
    DateTime? serverObservedAtUtc,
    int? remainingSpots,
    int? minSubscriptionDays,
    String? campaignId,
    String? sourceType,
    String? promoCode,
    bool? allowStacking,
    String? termsAndConditionsAr,
    String? termsAndConditionsEn,
    List<String>? programIds,
    List<String>? bundleIds,
    List<String>? restaurantIds,
    List<int>? allowedDurationDays,
    bool? isSaved,
    bool? isAvailable,
    OfferPurchaseMode? purchaseMode,
  }) {
    return OfferEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      discountRate: discountRate ?? this.discountRate,
      discountAmount: discountAmount ?? this.discountAmount,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      serverNowUtc: serverNowUtc ?? this.serverNowUtc,
      serverObservedAtUtc: serverObservedAtUtc ?? this.serverObservedAtUtc,
      remainingSpots: remainingSpots ?? this.remainingSpots,
      minSubscriptionDays: minSubscriptionDays ?? this.minSubscriptionDays,
      campaignId: campaignId ?? this.campaignId,
      sourceType: sourceType ?? this.sourceType,
      promoCode: promoCode ?? this.promoCode,
      allowStacking: allowStacking ?? this.allowStacking,
      termsAndConditionsAr: termsAndConditionsAr ?? this.termsAndConditionsAr,
      termsAndConditionsEn: termsAndConditionsEn ?? this.termsAndConditionsEn,
      programIds: programIds ?? this.programIds,
      bundleIds: bundleIds ?? this.bundleIds,
      restaurantIds: restaurantIds ?? this.restaurantIds,
      allowedDurationDays: allowedDurationDays ?? this.allowedDurationDays,
      isSaved: isSaved ?? this.isSaved,
      isAvailable: isAvailable ?? this.isAvailable,
      purchaseMode: purchaseMode ?? this.purchaseMode,
    );
  }

  String title(String languageCode) =>
      languageCode == 'ar' ? nameAr : (nameEn.isNotEmpty ? nameEn : nameAr);

  String description(String languageCode) => languageCode == 'ar'
      ? descriptionAr
      : (descriptionEn.isNotEmpty ? descriptionEn : descriptionAr);

  String? terms(String languageCode) => languageCode == 'ar'
      ? termsAndConditionsAr
      : (termsAndConditionsEn ?? termsAndConditionsAr);

  bool get isExpired {
    if (endsAt == null) return false;
    return _currentServerTime.isAfter(endsAt!);
  }

  bool get isSoldOut => remainingSpots != null && remainingSpots! <= 0;

  Duration get remainingDuration {
    if (endsAt == null) return Duration.zero;
    final diff = endsAt!.difference(_currentServerTime);
    return diff.isNegative ? Duration.zero : diff;
  }

  DateTime get _currentServerTime {
    final observed = serverObservedAtUtc;
    if (serverNowUtc == null || observed == null) return DateTime.now().toUtc();
    return serverNowUtc!.add(DateTime.now().toUtc().difference(observed));
  }

  String formattedDiscount([String currency = 'KWD']) {
    if (discountRate != null && discountRate! > 0) {
      final percent = discountRate! > 1.0
          ? discountRate!.round()
          : (discountRate! * 100).round();
      return '$percent%';
    }
    if (discountAmount != null && discountAmount! > 0) {
      return '${discountAmount!.toStringAsFixed(3)} $currency';
    }
    return '';
  }
}
