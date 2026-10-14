class FamilyFirstLoginSetPasswordRequestEntity {
  const FamilyFirstLoginSetPasswordRequestEntity({
    required this.loginChallengeToken,
    required this.newPassword,
  });

  final String loginChallengeToken;
  final String newPassword;
}
