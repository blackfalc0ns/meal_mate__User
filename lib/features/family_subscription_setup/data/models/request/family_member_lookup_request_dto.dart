import 'package:json_annotation/json_annotation.dart';

part 'family_member_lookup_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FamilyMemberLookupRequestDto {
  const FamilyMemberLookupRequestDto({required this.phone});

  final String phone;

  Map<String, dynamic> toJson() => _$FamilyMemberLookupRequestDtoToJson(this);
}
