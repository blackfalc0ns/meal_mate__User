class FamilyMemberResponseDto {
  final String memberId;
  final int role;
  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
  final int setupStatus;
  final String? programId;
  final String? bundleId;
  final int? selectedTier;
  final int? durationDays;
  final bool includeFriday;
  final bool isCurrentUser;

  FamilyMemberResponseDto({
    required this.memberId,
    required this.role,
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
    required this.setupStatus,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    required this.includeFriday,
    required this.isCurrentUser,
  });

  factory FamilyMemberResponseDto.fromJson(Map<String, dynamic> json) {
    int parseRole(dynamic val) {
      if (val is int) return val;
      if (val is String) {
        if (val.toLowerCase() == 'manager') return 1;
        return 2;
      }
      return 2;
    }

    int parseGender(dynamic val) {
      if (val is int) return val;
      if (val is String) {
        if (val.toLowerCase() == 'female' || val == '2') return 2;
        return 1;
      }
      return 1;
    }

    int parseSetupStatus(dynamic val) {
      if (val is int) return val;
      if (val is String) {
        final lower = val.toLowerCase();
        if (lower == 'completed' || val == '3') return 3;
        if (lower == 'inprogress' || val == '2') return 2;
        if (lower == 'notstarted' || val == '1') return 1;
        return 2;
      }
      return 1;
    }

    int? parseTier(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) {
        final lower = val.toLowerCase().trim();
        if (lower == 'basic' || lower == 'select' || lower == '1') return 1;
        if (lower == 'platinum' ||
            lower == 'plat' ||
            lower == 'plus' ||
            lower == '2') {
          return 2;
        }
        if (lower == 'elite' || lower == 'max' || lower == '3') return 3;
        return int.tryParse(val);
      }
      return null;
    }

    int? parseNullableInt(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    return FamilyMemberResponseDto(
      memberId: json['memberId'] as String? ?? '',
      role: parseRole(json['role']),
      displayName: json['displayName'] as String? ?? '',
      relationshipCode: json['relationshipCode'] as String? ?? '',
      gender: parseGender(json['gender']),
      ageYears: (json['ageYears'] as num?)?.toInt() ?? 0,
      deliveryAddressId: json['deliveryAddressId'] as String?,
      setupStatus: parseSetupStatus(json['setupStatus']),
      programId: json['programId'] as String?,
      bundleId: json['bundleId'] as String?,
      selectedTier: parseTier(json['selectedTier']),
      durationDays: parseNullableInt(json['durationDays']),
      includeFriday: json['includeFriday'] as bool? ?? false,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'memberId': memberId,
    'role': role,
    'displayName': displayName,
    'relationshipCode': relationshipCode,
    'gender': gender,
    'ageYears': ageYears,
    'deliveryAddressId': deliveryAddressId,
    'setupStatus': setupStatus,
    'programId': programId,
    'bundleId': bundleId,
    'selectedTier': selectedTier,
    'durationDays': durationDays,
    'includeFriday': includeFriday,
    'isCurrentUser': isCurrentUser,
  };
}
