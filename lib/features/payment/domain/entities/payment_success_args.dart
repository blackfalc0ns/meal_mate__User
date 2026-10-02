/// Arguments passed to PaymentSuccessScreen to display confirmed subscription details.
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
  });

  final String subscriptionId;
  final String? packageName;
  final int? durationDays;
  final String? durationLabel;
  final String? restaurantTier;
  final String? paymentDate;
  final String? startDate;
  final String? endDate;
}
