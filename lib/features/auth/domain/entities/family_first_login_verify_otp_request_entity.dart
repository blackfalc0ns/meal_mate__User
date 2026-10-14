class FamilyFirstLoginVerifyOtpRequestEntity {
  const FamilyFirstLoginVerifyOtpRequestEntity({
    required this.loginChallengeToken,
    required this.otpCode,
  });

  final String loginChallengeToken;
  final String otpCode;
}
