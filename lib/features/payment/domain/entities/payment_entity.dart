/// ─────────────────────────────────────────────────────────────
/// Domain entities for the Payment feature.
/// ─────────────────────────────────────────────────────────────

library;

enum PaymentMethodType { payzah, mada, visa, applePay, wallet, unknown }

class OrderSummaryEntity {
  const OrderSummaryEntity({
    required this.planName,
    required this.planDuration,
    required this.planMeals,
    required this.basePrice,
    required this.discountAmount,
    required this.totalAfterDiscount,
    this.couponCode,
  });

  final String planName;
  final String planDuration;
  final String planMeals;
  final double basePrice;
  final double discountAmount;
  final double totalAfterDiscount;
  final String? couponCode;
}

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

class PaymentCheckoutEntity {
  const PaymentCheckoutEntity({
    required this.subscriptionId,
    required this.paymentUrl,
    required this.holdExpiresAtUtc,
    required this.chosenStartDate,
    required this.startDate,
    required this.finalPrice,
    required this.priceSnapshotId,
    required this.restaurantPoolSnapshotId,
    required this.paymentStatus,
    this.paymentId,
  });

  final String subscriptionId;
  final String paymentUrl;
  final String holdExpiresAtUtc;
  final String chosenStartDate;
  final String startDate;
  final double finalPrice;
  final String priceSnapshotId;
  final String restaurantPoolSnapshotId;
  final String paymentStatus;
  final String? paymentId;

  factory PaymentCheckoutEntity.recovery({
    required String subscriptionId,
    required String paymentId,
  }) => PaymentCheckoutEntity(
    subscriptionId: subscriptionId,
    paymentUrl: '',
    holdExpiresAtUtc: '',
    chosenStartDate: '',
    startDate: '',
    finalPrice: 0.0,
    priceSnapshotId: '',
    restaurantPoolSnapshotId: '',
    paymentStatus: '',
    paymentId: paymentId,
  );
}

class PaymentStatusEntity {
  const PaymentStatusEntity({
    required this.paymentStatus,
    required this.isPaid,
    required this.isFailed,
    required this.amount,
    required this.currencyCode,
    this.isFulfillmentReady,
    this.fulfillmentStatus,
  });

  final String paymentStatus;
  final bool isPaid;
  final bool isFailed;
  final double amount;
  final String currencyCode;
  final bool? isFulfillmentReady;
  final String? fulfillmentStatus;
}
