class FamilyCheckoutRequestDto {
  final String callbackUrl;
  final String errorUrl;
  final int paymentMethodId;

  FamilyCheckoutRequestDto({
    required this.callbackUrl,
    required this.errorUrl,
    required this.paymentMethodId,
  });

  Map<String, dynamic> toJson() => {
        'callbackUrl': callbackUrl,
        'errorUrl': errorUrl,
        'paymentMethodId': paymentMethodId,
      };
}
