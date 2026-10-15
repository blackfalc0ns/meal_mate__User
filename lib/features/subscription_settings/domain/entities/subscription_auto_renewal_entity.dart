class SubscriptionAutoRenewalEntity {
  const SubscriptionAutoRenewalEntity({
    required this.subscriptionId,
    required this.consentActive,
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
}
