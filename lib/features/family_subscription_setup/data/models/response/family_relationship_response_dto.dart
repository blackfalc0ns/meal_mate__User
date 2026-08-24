import 'package:json_annotation/json_annotation.dart';

part 'family_relationship_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyRelationshipResponseDto {
  const FamilyRelationshipResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
    this.forDependents,
    this.isPrimary,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;
  final bool? forDependents;
  final bool? isPrimary;

  factory FamilyRelationshipResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyRelationshipResponseDtoFromJson(json);
}
