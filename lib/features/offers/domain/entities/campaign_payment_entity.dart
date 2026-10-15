enum CampaignPaymentStatus {
  pending,
  paid,
  failed,
  expired,
  cancelled,
  unknown;

  bool get isTerminal =>
      this == paid || this == failed || this == expired || this == cancelled;

  bool get isPaid => this == paid;
  bool get isFailed => this == failed;
  bool get isExpired => this == expired;
  bool get isCancelled => this == cancelled;
  bool get isPending => this == pending;
}

class CampaignPaymentEntity {
  const CampaignPaymentEntity({
    required this.sessionId,
    required this.status,
    required this.rawStatus,
    this.paymentId,
    this.paymentUrl,
    this.amount,
    this.currency = 'KWD',
    this.expiresAtUtc,
    this.isPaid,
    this.isFailed,
    this.subscriptionId,
  });

  final String sessionId;
  final CampaignPaymentStatus status;
  final String rawStatus;
  final String? paymentId;
  final String? paymentUrl;
  final double? amount;
  final String currency;
  final DateTime? expiresAtUtc;
  final bool? isPaid;
  final bool? isFailed;
  final String? subscriptionId;

  bool get isTerminal => status.isTerminal;

  bool get isAuthoritativePaid =>
      status == CampaignPaymentStatus.paid || (isPaid == true);
}
