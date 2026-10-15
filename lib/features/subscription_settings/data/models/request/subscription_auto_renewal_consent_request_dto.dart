class SubscriptionAutoRenewalConsentRequestDto {
  const SubscriptionAutoRenewalConsentRequestDto({
    required this.accepted,
    required this.consentVersion,
    required this.amount,
    required this.currency,
  });

  final bool accepted;
  final String consentVersion;
  final num amount;
  final String currency;

  factory SubscriptionAutoRenewalConsentRequestDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubscriptionAutoRenewalConsentRequestDto(
      accepted: json['accepted'] as bool? ?? false,
      consentVersion: json['consentVersion']?.toString() ?? '',
      amount: json['amount'] as num? ?? 0,
      currency: json['currency']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'accepted': accepted,
    'consentVersion': consentVersion,
    'amount': amount,
    'currency': currency,
  };
}
