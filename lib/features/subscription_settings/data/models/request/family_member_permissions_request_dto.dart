import 'package:json_annotation/json_annotation.dart';

part 'family_member_permissions_request_dto.g.dart';

@JsonSerializable()
class FamilyMemberPermissionsRequestDto {
  const FamilyMemberPermissionsRequestDto({
    required this.editDailyMeals,
    required this.changeDeliveryTime,
    required this.viewProgram,
    required this.changeProgram,
    required this.editMealsAndDays,
    required this.editAddress,
    required this.unitExchange,
    required this.changePassword,
  });
  final bool editDailyMeals;
  final bool changeDeliveryTime;
  final bool viewProgram;
  final bool changeProgram;
  final bool editMealsAndDays;
  final bool editAddress;
  final bool unitExchange;
  final bool changePassword;
  factory FamilyMemberPermissionsRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyMemberPermissionsRequestDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$FamilyMemberPermissionsRequestDtoToJson(this);
}
