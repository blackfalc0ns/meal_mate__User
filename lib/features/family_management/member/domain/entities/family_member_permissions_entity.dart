class FamilyMemberPermissionsEntity {
  const FamilyMemberPermissionsEntity({
    required this.memberId,
    required this.values,
    required this.groups,
    this.version,
  });

  final String memberId;
  final Map<String, bool> values;
  final List<FamilyPermissionGroupEntity> groups;
  final int? version;
}

class FamilyPermissionGroupEntity {
  const FamilyPermissionGroupEntity({
    required this.code,
    required this.label,
    required this.permissions,
  });

  final String code;
  final String label;
  final List<FamilyPermissionItemEntity> permissions;
}

class FamilyPermissionItemEntity {
  const FamilyPermissionItemEntity({
    required this.key,
    required this.label,
    required this.value,
  });

  final String key;
  final String label;
  final bool value;
}
