class LoginEntity {
  const LoginEntity({
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.userType,
    required this.accountStatus,
    required this.restaurantId,
    required this.roles,
    required this.permissions,
    this.accessToken,
    this.accessTokenExpiresAtUtc,
    this.refreshToken,
    this.refreshTokenExpiresAtUtc,
    this.nextStep,
    this.loginChallengeToken,
    this.loginChallengeExpiresAtUtc,
    required this.recoveryCodes,
    required this.isAuthenticated,
  });

  final String userId;
  final String? email;
  final String phoneNumber;
  final String fullName;
  final String userType;
  final String accountStatus;
  final String? restaurantId;
  final List<String> roles;
  final List<String> permissions;
  final String? accessToken;
  final String? accessTokenExpiresAtUtc;
  final String? refreshToken;
  final String? refreshTokenExpiresAtUtc;
  final String? nextStep;
  final String? loginChallengeToken;
  final String? loginChallengeExpiresAtUtc;
  final List<String> recoveryCodes;
  final bool isAuthenticated;

  bool get isPendingFamilyFirstLogin =>
      !isAuthenticated &&
      (accessToken == null || accessToken!.isEmpty) &&
      nextStep == 'family_verify_otp';
}
