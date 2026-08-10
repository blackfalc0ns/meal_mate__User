class ResendPhoneOtpEntity {
  const ResendPhoneOtpEntity({
    required this.success,
    required this.otpSent,
    required this.nextStep,
  });

  final bool success;
  final bool otpSent;
  final String nextStep;
}
