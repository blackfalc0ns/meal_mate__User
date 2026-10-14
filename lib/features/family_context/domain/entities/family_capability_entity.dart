class FamilyCapabilityEntity {
  const FamilyCapabilityEntity({
    required this.action,
    required this.allowed,
    this.reasonCode,
    this.requiredPermission,
  });

  final String action;
  final bool allowed;
  final String? reasonCode;
  final String? requiredPermission;
}
