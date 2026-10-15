class FamilyFirstLoginResendOtpRequestDto {
  const FamilyFirstLoginResendOtpRequestDto({
    required this.loginChallengeToken,
  });

  final String loginChallengeToken;

  factory FamilyFirstLoginResendOtpRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => FamilyFirstLoginResendOtpRequestDto(
    loginChallengeToken: json['loginChallengeToken'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'loginChallengeToken': loginChallengeToken,
  };
}
