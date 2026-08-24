import 'package:json_annotation/json_annotation.dart';

part 'family_convert_from_individual_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyConvertFromIndividualRequestDto {
  const FamilyConvertFromIndividualRequestDto({
    this.name,
    this.familyPackageId,
  });

  final String? name;
  final String? familyPackageId;

  Map<String, dynamic> toJson() =>
      _$FamilyConvertFromIndividualRequestDtoToJson(this);
}
