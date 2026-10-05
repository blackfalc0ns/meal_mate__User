enum SubscriptionCouponStatus {
  valid,
  notFound,
  inactive,
  notStarted,
  expired,
  usageExhausted,
  stackingConflict,
  ineligible,
  unknown;

  static SubscriptionCouponStatus fromRaw(String? raw) {
    return switch (raw?.trim().toLowerCase()) {
      'valid' => SubscriptionCouponStatus.valid,
      'not_found' => SubscriptionCouponStatus.notFound,
      'inactive' => SubscriptionCouponStatus.inactive,
      'not_started' => SubscriptionCouponStatus.notStarted,
      'expired' => SubscriptionCouponStatus.expired,
      'usage_exhausted' => SubscriptionCouponStatus.usageExhausted,
      'stacking_conflict' => SubscriptionCouponStatus.stackingConflict,
      'ineligible' => SubscriptionCouponStatus.ineligible,
      _ => SubscriptionCouponStatus.unknown,
    };
  }

  bool get isValid => this == SubscriptionCouponStatus.valid;
}

class SubscriptionCouponEntity {
  const SubscriptionCouponEntity({
    required this.code,
    required this.status,
    required this.rawStatus,
    this.offerId,
    required this.discountAmount,
    this.messageAr,
    this.messageEn,
  });

  final String code;
  final SubscriptionCouponStatus status;
  final String rawStatus;
  final String? offerId;
  final double discountAmount;
  final String? messageAr;
  final String? messageEn;

  bool get isValid => status == SubscriptionCouponStatus.valid;

  String message(String localeName) {
    final msg = localeName == 'ar' ? messageAr : messageEn;
    if (msg != null && msg.trim().isNotEmpty) {
      return msg.trim();
    }
    final fallback = localeName == 'ar' ? messageEn : messageAr;
    if (fallback != null && fallback.trim().isNotEmpty) {
      return fallback.trim();
    }
    return '';
  }
}
