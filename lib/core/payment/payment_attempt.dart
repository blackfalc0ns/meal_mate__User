/// Domain model representing a securely persisted payment attempt.
///
/// Contains minimal metadata needed to correlate callbacks and restore state.
/// Strictly never stores paymentUrl, card data, CVV, passwords, or JWTs.
class PaymentAttempt {
  const PaymentAttempt({
    this.schemaVersion = 1,
    required this.ownerCustomerId,
    required this.subscriptionId,
    required this.paymentId,
    required this.createdAtUtc,
    this.reviewRequired = false,
    this.lastPresentedFinalStatus,
  });

  final int schemaVersion;
  final String ownerCustomerId;
  final String subscriptionId;
  final String paymentId;
  final DateTime createdAtUtc;
  final bool reviewRequired;
  final String? lastPresentedFinalStatus;

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'ownerCustomerId': ownerCustomerId,
    'subscriptionId': subscriptionId,
    'paymentId': paymentId,
    'createdAtUtc': createdAtUtc.toIso8601String(),
    'reviewRequired': reviewRequired,
    if (lastPresentedFinalStatus != null)
      'lastPresentedFinalStatus': lastPresentedFinalStatus,
  };

  factory PaymentAttempt.fromJson(Map<String, dynamic> json) {
    final version = json['schemaVersion'] as int? ?? 1;
    final owner = json['ownerCustomerId'] as String? ?? '';
    final subId = json['subscriptionId'] as String? ?? '';
    final pId = json['paymentId'] as String? ?? '';
    final createdAtRaw = json['createdAtUtc'] as String?;
    final createdAt = createdAtRaw != null
        ? DateTime.tryParse(createdAtRaw)?.toUtc() ?? DateTime.now().toUtc()
        : DateTime.now().toUtc();
    final review = json['reviewRequired'] as bool? ?? false;
    final lastStatus = json['lastPresentedFinalStatus'] as String?;

    if (owner.trim().isEmpty || subId.trim().isEmpty || pId.trim().isEmpty) {
      throw const FormatException('Invalid PaymentAttempt payload');
    }

    return PaymentAttempt(
      schemaVersion: version,
      ownerCustomerId: owner,
      subscriptionId: subId,
      paymentId: pId,
      createdAtUtc: createdAt,
      reviewRequired: review,
      lastPresentedFinalStatus: lastStatus,
    );
  }

  PaymentAttempt copyWith({
    int? schemaVersion,
    String? ownerCustomerId,
    String? subscriptionId,
    String? paymentId,
    DateTime? createdAtUtc,
    bool? reviewRequired,
    String? lastPresentedFinalStatus,
  }) {
    return PaymentAttempt(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      ownerCustomerId: ownerCustomerId ?? this.ownerCustomerId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      paymentId: paymentId ?? this.paymentId,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      reviewRequired: reviewRequired ?? this.reviewRequired,
      lastPresentedFinalStatus:
          lastPresentedFinalStatus ?? this.lastPresentedFinalStatus,
    );
  }
}
