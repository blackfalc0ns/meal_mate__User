import 'package:json_annotation/json_annotation.dart';

part 'family_member_allergies_request_dto.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class FamilyMemberAllergiesRequestDto {
  const FamilyMemberAllergiesRequestDto({required this.allergies});
  final List<FamilyMemberAllergyRequestDto> allergies;
  Map<String, dynamic> toJson() =>
      _$FamilyMemberAllergiesRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyMemberAllergyRequestDto {
  const FamilyMemberAllergyRequestDto({required this.code, this.severity});
  final String code;
  final String? severity;
  Map<String, dynamic> toJson() => _$FamilyMemberAllergyRequestDtoToJson(this);
}
