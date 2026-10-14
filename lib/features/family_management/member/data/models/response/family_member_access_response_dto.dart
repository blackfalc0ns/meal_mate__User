class FamilyMemberAccessResponseDto {
  const FamilyMemberAccessResponseDto({
    required this.memberId,
    this.hasSeparateAccount = false,
    this.isPaused = false,
    this.hasExistingLogin = false,
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
  final String? pausedAtUtc;
  final String? removedAtUtc;
  final String? inviteDeepLink;
  final String? inviteExpiresAtUtc;
  final String? phoneNumber;
  final String? generatedPassword;
  final int? version;

  factory FamilyMemberAccessResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberAccessResponseDto(
      memberId: json['memberId']?.toString() ?? '',
      hasSeparateAccount: json['hasSeparateAccount'] as bool? ?? false,
      isPaused: json['isPaused'] as bool? ?? false,
      hasExistingLogin: json['hasExistingLogin'] as bool? ?? false,
      linkedCustomerUserId: json['linkedCustomerUserId']?.toString(),
      pausedAtUtc: json['pausedAtUtc']?.toString(),
      removedAtUtc: json['removedAtUtc']?.toString(),
      inviteDeepLink: json['inviteDeepLink']?.toString(),
      inviteExpiresAtUtc: json['inviteExpiresAtUtc']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      generatedPassword: json['generatedPassword']?.toString(),
      version: (json['version'] as num?)?.toInt(),
    );
  }
}
