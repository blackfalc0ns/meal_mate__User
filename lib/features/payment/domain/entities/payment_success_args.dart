class PaymentSuccessArgs {
  const PaymentSuccessArgs({
    required this.subscriptionId,
    this.packageName,
    this.durationDays,
    this.durationLabel,
    this.restaurantTier,
    this.paymentDate,
    this.startDate,
    this.endDate,
    this.isFamily = false,
    this.familyName,
    this.memberCount,
  });

  final String subscriptionId;
  final String? packageName;
  final int? durationDays;
  final String? durationLabel;
  final String? restaurantTier;
  final String? paymentDate;
  final String? startDate;
  final String? endDate;
  final bool isFamily;
  final String? familyName;
  final int? memberCount;
}
