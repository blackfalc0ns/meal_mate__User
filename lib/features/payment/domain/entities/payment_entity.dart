/// ─────────────────────────────────────────────────────────────
/// Domain entities for the Payment feature.
/// ─────────────────────────────────────────────────────────────

library;

enum PaymentMethodType { mada, visa, applePay, wallet }

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
    this.walletBalance,
  });

  final int id;
  final PaymentMethodType type;
  final String title;
  final String subtitle;

  /// Only relevant for [PaymentMethodType.wallet]
  final double? walletBalance;
}

class PaymentCheckoutRequestEntity {
  const PaymentCheckoutRequestEntity({
    required this.restaurantId,
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.startDate,
    required this.regionId,
    required this.deliveryAddress,
    required this.callbackUrl,
    required this.errorUrl,
    required this.includeFriday,
    required this.paymentMethodId,
    required this.correlationId,
  });

  final String restaurantId;
  final String programId;
  final String bundleId;
  final String tier;
  final int durationDays;
  final String startDate;
  final String regionId;
  final String deliveryAddress;
  final String callbackUrl;
  final String errorUrl;
  final bool includeFriday;
  final int paymentMethodId;
  final String correlationId;

  bool get isComplete =>
      restaurantId.isNotEmpty &&
      programId.isNotEmpty &&
      bundleId.isNotEmpty &&
      tier.isNotEmpty &&
      durationDays > 0 &&
      startDate.isNotEmpty &&
      regionId.isNotEmpty &&
      deliveryAddress.isNotEmpty &&
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
    required this.finalPrice,
    required this.priceSnapshotId,
    required this.restaurantPoolSnapshotId,
  });

  final String subscriptionId;
  final String paymentUrl;
  final String holdExpiresAtUtc;
  final double finalPrice;
  final String priceSnapshotId;
  final String restaurantPoolSnapshotId;
}
