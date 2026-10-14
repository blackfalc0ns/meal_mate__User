class UpdateFamilyMemberAccessRequestDto {
  const UpdateFamilyMemberAccessRequestDto({
    this.hasSeparateAccount,
    this.isPaused,
    this.removeAccess = false,
  });

  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool removeAccess;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'removeAccess': removeAccess,
    };
    if (hasSeparateAccount != null) {
      map['hasSeparateAccount'] = hasSeparateAccount;
    }
    if (isPaused != null) {
      map['isPaused'] = isPaused;
    }
    return map;
  }
}
