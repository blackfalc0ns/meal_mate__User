class FamilyMetadataEntity {
  const FamilyMetadataEntity({
    required this.relationships,
    required this.goals,
    required this.activityLevels,
    required this.maxMembers,
    required this.discountPercent,
    required this.minMembersForDiscount,
  });

  final List<FamilyRelationshipEntity> relationships;
  final List<FamilyNutritionalGoalEntity> goals;
  final List<FamilyActivityLevelEntity> activityLevels;
  final int maxMembers;
  final double discountPercent;
  final int minMembersForDiscount;
}

class FamilyRelationshipEntity {
  const FamilyRelationshipEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  final String code;
  final String nameAr;
  final String nameEn;
}

class FamilyNutritionalGoalEntity {
  const FamilyNutritionalGoalEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  final String code;
  final String nameAr;
  final String nameEn;
}

class FamilyActivityLevelEntity {
  const FamilyActivityLevelEntity({
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  final String code;
  final String nameAr;
  final String nameEn;
}
