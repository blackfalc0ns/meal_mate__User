class UpdateFamilyMemberAccessRequestDto {
  const UpdateFamilyMemberAccessRequestDto({
    this.hasSeparateAccount,
    this.isPaused,
    this.removeAccess = false,
    this.generateTemporaryPassword,
    this.credentialOperationKey,
  });

  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool removeAccess;
  final bool? generateTemporaryPassword;
  final String? credentialOperationKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'removeAccess': removeAccess};
    if (hasSeparateAccount != null) {
      map['hasSeparateAccount'] = hasSeparateAccount;
    }
    if (isPaused != null) {
      map['isPaused'] = isPaused;
    }
    if (generateTemporaryPassword != null) {
      map['generateTemporaryPassword'] = generateTemporaryPassword;
    }
    if (credentialOperationKey != null) {
      map['credentialOperationKey'] = credentialOperationKey;
    }
    return map;
  }
}
