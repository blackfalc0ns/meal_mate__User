import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';

part 'calendar_response_dto.g.dart';

@JsonSerializable()
class CalendarResponseDto {
  const CalendarResponseDto({
    this.subscriptionId,
    this.serverTimeUtc,
    this.programId,
    this.bundleId,
    this.requiredCount,
    this.slotRequirements,
    this.isFulfillmentReady,
    this.days,
    this.includeFriday,
    this.operationalLeadHours,
    this.hasUnreadNotifications,
    this.unreadNotificationsCount,
  });

  final String? subscriptionId;
  final String? serverTimeUtc;
  final String? programId;
  final String? bundleId;
  final int? requiredCount;
  final List<CalendarSlotRequirementResponseDto>? slotRequirements;
  final bool? isFulfillmentReady;
  final List<CalendarDayResponseDto>? days;
  final bool? includeFriday;
  final int? operationalLeadHours;
  final bool? hasUnreadNotifications;
  final int? unreadNotificationsCount;

  factory CalendarResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarResponseDtoToJson(this);
}
