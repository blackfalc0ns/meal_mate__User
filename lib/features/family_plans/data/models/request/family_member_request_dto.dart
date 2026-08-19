import 'package:json_annotation/json_annotation.dart';

part 'family_member_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FamilyMemberRequestDto {
  const FamilyMemberRequestDto({
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    required this.nutritionalGoalCode,
    required this.activityLevel,
    required this.deliveryAddressId,
  });

  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String nutritionalGoalCode;
  final int activityLevel;
  final String deliveryAddressId;

  Map<String, dynamic> toJson() => _$FamilyMemberRequestDtoToJson(this);
}
