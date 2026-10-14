class UpdateFamilyMemberAccessRequestDto {
  const UpdateFamilyMemberAccessRequestDto({
    this.hasSeparateAccount,
    this.isPaused,
    this.removeAccess = false,
    this.generateTemporaryPassword,
  });

  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool removeAccess;
  final bool? generateTemporaryPassword;

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
    return map;
  }
}
