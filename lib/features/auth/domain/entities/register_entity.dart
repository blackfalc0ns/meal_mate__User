class RegisterEntity {
  const RegisterEntity({
    required this.userId,
    required this.phone,
    required this.otpSent,
    required this.nextStep,
  });

  final String userId;
  final String phone;
  final bool otpSent;
  final String nextStep;
}
