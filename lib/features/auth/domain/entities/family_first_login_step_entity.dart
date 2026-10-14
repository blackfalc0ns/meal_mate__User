class FamilyFirstLoginStepEntity {
  const FamilyFirstLoginStepEntity({
    required this.nextStep,
    required this.loginChallengeToken,
    this.loginChallengeExpiresAtUtc,
  });

  final String nextStep;
  final String loginChallengeToken;
  final String? loginChallengeExpiresAtUtc;

  bool get isVerifyOtp => nextStep == 'family_verify_otp';
  bool get isSetPassword => nextStep == 'family_set_password';
}
