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
    this.startDate,
  }) : _clear = false;

  const FamilyMemberPlanWriteRequestDto.clear()
    : programId = null,
      bundleId = null,
      tier = null,
      durationDays = null,
      includeFriday = null,
      startDate = null,
      _clear = true;

  final String? programId;
  final String? bundleId;
  final int? tier;
  final int? durationDays;
  final bool? includeFriday;
  final String? startDate;
  final bool _clear;

  Map<String, dynamic> toJson() => _clear
      ? <String, dynamic>{
          'programId': null,
          'bundleId': null,
          'tier': null,
          'durationDays': null,
        }
      : _$FamilyMemberPlanWriteRequestDtoToJson(this);
}
