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
    this.labelAr,
    this.labelEn,
  });

  final String code;
  final String label;
  final List<FamilyPermissionItemEntity> permissions;
  final String? labelAr;
  final String? labelEn;

  String localizedLabel(bool isArabic) {
    if (isArabic) {
      if (labelAr != null && labelAr!.trim().isNotEmpty) return labelAr!;
      if (labelEn != null && labelEn!.trim().isNotEmpty) return labelEn!;
    } else {
      if (labelEn != null && labelEn!.trim().isNotEmpty) return labelEn!;
      if (labelAr != null && labelAr!.trim().isNotEmpty) return labelAr!;
    }
    return label;
  }
}

class FamilyPermissionItemEntity {
  const FamilyPermissionItemEntity({
    required this.key,
    required this.label,
    required this.value,
    this.labelAr,
    this.labelEn,
    this.descriptionAr,
    this.descriptionEn,
    this.isSupported = true,
    this.isManagerConfigurable = true,
    this.requiredPermissions = const [],
  });

  final String key;
  final String label;
  final bool value;
  final String? labelAr;
  final String? labelEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final bool isSupported;
  final bool isManagerConfigurable;
  final List<String> requiredPermissions;

  String localizedLabel(bool isArabic) {
    if (isArabic) {
      if (labelAr != null && labelAr!.trim().isNotEmpty) return labelAr!;
      if (labelEn != null && labelEn!.trim().isNotEmpty) return labelEn!;
    } else {
      if (labelEn != null && labelEn!.trim().isNotEmpty) return labelEn!;
      if (labelAr != null && labelAr!.trim().isNotEmpty) return labelAr!;
    }
    return label;
  }

  String localizedDescription(bool isArabic) {
    if (isArabic) {
      if (descriptionAr != null && descriptionAr!.trim().isNotEmpty) return descriptionAr!;
      if (descriptionEn != null && descriptionEn!.trim().isNotEmpty) return descriptionEn!;
    } else {
      if (descriptionEn != null && descriptionEn!.trim().isNotEmpty) return descriptionEn!;
      if (descriptionAr != null && descriptionAr!.trim().isNotEmpty) return descriptionAr!;
    }
    return '';
  }
}

