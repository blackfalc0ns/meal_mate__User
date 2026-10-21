class UpdateFamilyMemberAccessRequestEntity {
  const UpdateFamilyMemberAccessRequestEntity({
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
}
