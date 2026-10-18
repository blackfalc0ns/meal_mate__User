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
    this.remainingSpots,
    this.minSubscriptionDays,
    this.campaignId,
    this.promoCode,
    this.allowStacking = false,
    this.termsAndConditionsAr,
    this.termsAndConditionsEn,
    this.programIds = const [],
    this.bundleIds = const [],
    this.restaurantIds = const [],
    this.allowedDurationDays = const [],
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
  final int? remainingSpots;
  final int? minSubscriptionDays;
  final String? campaignId;
  final String? promoCode;
  final bool allowStacking;
  final String? termsAndConditionsAr;
  final String? termsAndConditionsEn;
  final List<String> programIds;
  final List<String> bundleIds;
  final List<String> restaurantIds;
  final List<int> allowedDurationDays;

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
    return DateTime.now().toUtc().isAfter(endsAt!);
  }

  bool get isSoldOut => remainingSpots != null && remainingSpots! <= 0;

  Duration get remainingDuration {
    if (endsAt == null) return Duration.zero;
    final diff = endsAt!.difference(DateTime.now().toUtc());
    return diff.isNegative ? Duration.zero : diff;
  }

  String formattedDiscount([String currency = 'KWD']) {
    if (discountRate != null && discountRate! > 0) {
      final percent = (discountRate! * 100).round();
      return '$percent%';
    }
    if (discountAmount != null && discountAmount! > 0) {
      return '${discountAmount!.toStringAsFixed(3)} $currency';
    }
    return '';
  }
}
