class FamilyRelationshipEntity {
  final String code;
  final String nameAr;
  final String nameEn;
  final bool forDependents;
  final bool isPrimary;

  const FamilyRelationshipEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.forDependents,
    required this.isPrimary,
  });

  String name(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') && nameEn.isNotEmpty) {
      return nameEn;
    }
    return nameAr.isNotEmpty ? nameAr : nameEn;
  }
}
