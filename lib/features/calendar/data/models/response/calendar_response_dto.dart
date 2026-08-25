import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';

part 'calendar_response_dto.g.dart';

@JsonSerializable()
class CalendarResponseDto {
  const CalendarResponseDto({
    this.subscriptionId,
    this.programId,
    this.bundleId,
    this.requiredCount,
    this.slotRequirements,
    this.isFulfillmentReady,
    this.days,
  });

  final String? subscriptionId;
  final String? programId;
  final String? bundleId;
  final int? requiredCount;
  final List<CalendarSlotRequirementResponseDto>? slotRequirements;
  final bool? isFulfillmentReady;
  final List<CalendarDayResponseDto>? days;

  factory CalendarResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarResponseDtoToJson(this);
}
