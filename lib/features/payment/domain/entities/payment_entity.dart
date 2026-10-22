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
    this.fulfillmentStatus,
    this.menuPlanVersionId,
    this.paymentDate,
    this.paymentId,
    this.serverTimeUtc,
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
  final String? fulfillmentStatus;
  final String? menuPlanVersionId;
  final String? paymentDate;
  final String? paymentId;
  final DateTime? serverTimeUtc;

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
