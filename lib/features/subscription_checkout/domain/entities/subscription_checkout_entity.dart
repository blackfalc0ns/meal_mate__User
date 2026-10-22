enum PaymentMethodType { payzah, mada, visa, applePay, wallet, unknown }

class PaymentMethodEntity {
  const PaymentMethodEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.isAvailable,
    this.code,
    this.integrationType,
    this.serviceCharge,
    this.totalAmount,
    this.currencyCode,
    this.unavailableReason,
    this.imageUrl,
    this.walletBalance,
  });

  final int? id;
  final PaymentMethodType type;
  final String title;
  final String subtitle;
  final bool isAvailable;
  final String? code;
  final String? integrationType;
  final double? serviceCharge;
  final double? totalAmount;
  final String? currencyCode;
  final String? unavailableReason;
  final String? imageUrl;

  /// Only relevant for [PaymentMethodType.wallet]
  final double? walletBalance;
}

class PaymentCheckoutRequestEntity {
  const PaymentCheckoutRequestEntity({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.startDate,
    required this.callbackUrl,
    required this.errorUrl,
    required this.includeFriday,
    required this.paymentMethodId,
    required this.correlationId,
    this.promoCode,
    this.offerId,
    this.idempotencyKey,
    this.quoteId,
  });

  final String programId;
  final String bundleId;
  final String tier;
  final int durationDays;
  final String startDate;
  final String callbackUrl;
  final String errorUrl;
  final bool includeFriday;
  final int paymentMethodId;
  final String correlationId;
  final String? promoCode;
  final String? offerId;
  final String? idempotencyKey;
  final String? quoteId;

  bool get isComplete =>
      programId.isNotEmpty &&
      bundleId.isNotEmpty &&
      tier.isNotEmpty &&
      durationDays > 0 &&
      startDate.isNotEmpty &&
      callbackUrl.isNotEmpty &&
      errorUrl.isNotEmpty &&
      paymentMethodId > 0 &&
      correlationId.isNotEmpty;
}
