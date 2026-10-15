class SubscriptionAutoRenewalDto {
  const SubscriptionAutoRenewalDto({
    required this.subscriptionId,
    this.consentActive = false,
    this.consentVersion,
    this.consentAmount,
    this.currency,
    this.consentActorUserId,
    this.withdrawnByUserId,
    this.consentedAtUtc,
    this.withdrawnAtUtc,
    this.billingStatus = 'NotConnected',
    this.requiresPaymentSetup = false,
    this.autoChargeEnabled = false,
  });

  final String subscriptionId;
  final bool consentActive;
  final String? consentVersion;
  final num? consentAmount;
  final String? currency;
  final String? consentActorUserId;
  final String? withdrawnByUserId;
  final String? consentedAtUtc;
  final String? withdrawnAtUtc;
  final String billingStatus;
  final bool requiresPaymentSetup;
  final bool autoChargeEnabled;

  factory SubscriptionAutoRenewalDto.fromJson(Map<String, dynamic> json) {
    final consentActive = json['consentActive'] as bool? ?? false;
    return SubscriptionAutoRenewalDto(
      subscriptionId: json['subscriptionId']?.toString() ?? '',
      consentActive: consentActive,
      consentVersion: json['consentVersion']?.toString(),
      consentAmount: json['consentAmount'] as num?,
      currency: json['currency']?.toString(),
      consentActorUserId: json['consentActorUserId']?.toString(),
      withdrawnByUserId: json['withdrawnByUserId']?.toString(),
      consentedAtUtc: json['consentedAtUtc']?.toString(),
      withdrawnAtUtc: json['withdrawnAtUtc']?.toString(),
      billingStatus: json['billingStatus']?.toString() ?? 'NotConnected',
      requiresPaymentSetup: json['requiresPaymentSetup'] as bool? ?? consentActive,
      autoChargeEnabled: json['autoChargeEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'subscriptionId': subscriptionId,
    'consentActive': consentActive,
    if (consentVersion != null) 'consentVersion': consentVersion,
    if (consentAmount != null) 'consentAmount': consentAmount,
    if (currency != null) 'currency': currency,
    if (consentActorUserId != null) 'consentActorUserId': consentActorUserId,
    if (withdrawnByUserId != null) 'withdrawnByUserId': withdrawnByUserId,
    if (consentedAtUtc != null) 'consentedAtUtc': consentedAtUtc,
    if (withdrawnAtUtc != null) 'withdrawnAtUtc': withdrawnAtUtc,
    'billingStatus': billingStatus,
    'requiresPaymentSetup': requiresPaymentSetup,
    'autoChargeEnabled': autoChargeEnabled,
  };
}
