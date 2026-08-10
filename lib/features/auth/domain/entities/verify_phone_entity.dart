class VerifyPhoneEntity {
  const VerifyPhoneEntity({
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.userType,
    required this.accountStatus,
    required this.restaurantId,
    required this.roles,
    required this.permissions,
    required this.accessToken,
    required this.accessTokenExpiresAtUtc,
    required this.refreshToken,
    required this.refreshTokenExpiresAtUtc,
    required this.nextStep,
  });

  final String userId;
  final String? email;
  final String phoneNumber;
  final String fullName;
  final int userType;
  final int accountStatus;
  final String? restaurantId;
  final List<String> roles;
  final List<String> permissions;
  final String accessToken;
  final String accessTokenExpiresAtUtc;
  final String refreshToken;
  final String refreshTokenExpiresAtUtc;
  final String nextStep;
}
