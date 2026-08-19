import 'package:json_annotation/json_annotation.dart';

part 'family_member_plan_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FamilyMemberPlanRequestDto {
  const FamilyMemberPlanRequestDto({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final int tier;
  final int durationDays;
  final bool includeFriday;

  Map<String, dynamic> toJson() => _$FamilyMemberPlanRequestDtoToJson(this);
}
