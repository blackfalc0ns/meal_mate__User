import 'package:json_annotation/json_annotation.dart';

part 'family_group_write_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyGroupWriteRequestDto {
  const FamilyGroupWriteRequestDto({required this.name, this.familyPackageId});

  final String name;
  final String? familyPackageId;

  Map<String, dynamic> toJson() => _$FamilyGroupWriteRequestDtoToJson(this);
}
