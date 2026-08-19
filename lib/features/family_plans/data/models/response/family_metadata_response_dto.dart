import 'package:json_annotation/json_annotation.dart';

part 'family_metadata_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyMetadataResponseDto {
  const FamilyMetadataResponseDto({
    this.relationships,
    this.goals,
    this.activityLevels,
    this.maxMembers,
    this.discountPercent,
    this.minMembersForDiscount,
  });

  final List<FamilyRelationshipDto>? relationships;
  final List<FamilyNutritionalGoalDto>? goals;
  final List<FamilyActivityLevelDto>? activityLevels;
  final int? maxMembers;
  final double? discountPercent;
  final int? minMembersForDiscount;

  factory FamilyMetadataResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMetadataResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyRelationshipDto {
  const FamilyRelationshipDto({
    this.code,
    this.nameAr,
    this.nameEn,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory FamilyRelationshipDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyRelationshipDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyNutritionalGoalDto {
  const FamilyNutritionalGoalDto({
    this.code,
    this.nameAr,
    this.nameEn,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory FamilyNutritionalGoalDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyNutritionalGoalDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyActivityLevelDto {
  const FamilyActivityLevelDto({
    this.code,
    this.nameAr,
    this.nameEn,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory FamilyActivityLevelDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyActivityLevelDtoFromJson(json);
}
