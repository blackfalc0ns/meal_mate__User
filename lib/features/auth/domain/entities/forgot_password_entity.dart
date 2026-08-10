class ForgotPasswordEntity {
  const ForgotPasswordEntity({
    required this.success,
    required this.otpSent,
    required this.nextStep,
    required this.phone,
    required this.countryCode,
  });

  final bool success;
  final bool otpSent;
  final String nextStep;
  final String phone;
  final String countryCode;
}
