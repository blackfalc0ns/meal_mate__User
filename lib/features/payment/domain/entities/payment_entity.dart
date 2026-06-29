/// ─────────────────────────────────────────────────────────────
/// Domain entities for the Payment feature.
/// ─────────────────────────────────────────────────────────────

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
    required this.type,
    required this.title,
    required this.subtitle,
    this.walletBalance,
  });

  final PaymentMethodType type;
  final String title;
  final String subtitle;

  /// Only relevant for [PaymentMethodType.wallet]
  final double? walletBalance;
}
