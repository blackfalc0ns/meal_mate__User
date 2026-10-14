class FamilyMemberAccessEntity {
  const FamilyMemberAccessEntity({
    required this.memberId,
    required this.hasSeparateAccount,
    required this.isPaused,
    required this.hasExistingLogin,
    this.linkedCustomerUserId,
    this.pausedAtUtc,
    this.removedAtUtc,
    this.inviteDeepLink,
    this.inviteExpiresAtUtc,
    this.phoneNumber,
    this.generatedPassword,
    this.version,
  });

  final String memberId;
  final bool hasSeparateAccount;
  final bool isPaused;
  final bool hasExistingLogin;
  final String? linkedCustomerUserId;
  final DateTime? pausedAtUtc;
  final DateTime? removedAtUtc;
  final String? inviteDeepLink;
  final DateTime? inviteExpiresAtUtc;
  final String? phoneNumber;
  final String? generatedPassword;
  final int? version;

  FamilyMemberAccessEntity clearGeneratedPassword() =>
      FamilyMemberAccessEntity(
        memberId: memberId,
        hasSeparateAccount: hasSeparateAccount,
        isPaused: isPaused,
        hasExistingLogin: hasExistingLogin,
        linkedCustomerUserId: linkedCustomerUserId,
        pausedAtUtc: pausedAtUtc,
        removedAtUtc: removedAtUtc,
        inviteDeepLink: inviteDeepLink,
        inviteExpiresAtUtc: inviteExpiresAtUtc,
        phoneNumber: phoneNumber,
        version: version,
      );
}
