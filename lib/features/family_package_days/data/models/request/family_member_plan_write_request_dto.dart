import 'package:json_annotation/json_annotation.dart';

part 'family_member_plan_write_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyMemberPlanWriteRequestDto {
  const FamilyMemberPlanWriteRequestDto({
    this.programId,
    this.bundleId,
    this.tier,
    this.durationDays,
    this.includeFriday,
  });

  final String? programId;
  final String? bundleId;
  final int? tier;
  final int? durationDays;
  final bool? includeFriday;

  Map<String, dynamic> toJson() =>
      _$FamilyMemberPlanWriteRequestDtoToJson(this);
}
