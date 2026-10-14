import 'package:json_annotation/json_annotation.dart';

part 'family_member_allergies_request_dto.g.dart';

class FamilyMemberAllergiesRequestDto {
  const FamilyMemberAllergiesRequestDto({
    this.allergies = const [],
    this.selectedCodes,
  });

  final List<FamilyMemberAllergyRequestDto> allergies;
  final List<String>? selectedCodes;

  Map<String, dynamic> toJson() {
    final rawCodes =
        selectedCodes ?? allergies.map((item) => item.code).toList();
    final codes = rawCodes.where((item) => item.trim().isNotEmpty).toList();
    return {
      'selectedCodes': codes.isEmpty ? const ['NONE'] : codes,
    };
  }
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyMemberAllergyRequestDto {
  const FamilyMemberAllergyRequestDto({required this.code, this.severity});
  final String code;
  final String? severity;
  Map<String, dynamic> toJson() => _$FamilyMemberAllergyRequestDtoToJson(this);
}
