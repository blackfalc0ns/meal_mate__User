import 'package:json_annotation/json_annotation.dart';

part 'family_group_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FamilyGroupRequestDto {
  const FamilyGroupRequestDto({
    required this.name,
  });

  final String name;

  Map<String, dynamic> toJson() => _$FamilyGroupRequestDtoToJson(this);
}
