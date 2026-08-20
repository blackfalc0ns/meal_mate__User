class FamilyRelationshipResponseDto {
  final String code;
  final String nameAr;
  final String nameEn;
  final bool forDependents;
  final bool isPrimary;

  FamilyRelationshipResponseDto({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.forDependents,
    required this.isPrimary,
  });

  factory FamilyRelationshipResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilyRelationshipResponseDto(
      code: json['code'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      forDependents: json['forDependents'] as bool? ?? false,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'forDependents': forDependents,
        'isPrimary': isPrimary,
      };
}
