import 'package:json_annotation/json_annotation.dart';

part 'family_member_write_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyMemberWriteRequestDto {
  const FamilyMemberWriteRequestDto({
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
  });

  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;

  Map<String, dynamic> toJson() => _$FamilyMemberWriteRequestDtoToJson(this);
}
