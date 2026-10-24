import 'package:json_annotation/json_annotation.dart';

part 'voice_call_display_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceCallDisplayDto {
  const VoiceCallDisplayDto({
    this.callId,
    this.tripStopId,
    this.driverName,
    this.driverImageUrl,
    this.driverRole,
    this.vehicleType,
    this.plateNumber,
    this.deliveryAddress,
    this.deliveryZone,
    this.orderCode,
    this.mealSummary,
    this.slotLabel,
    this.boxCount,
    this.stopStatus,
  });

  final String? callId;
  final String? tripStopId;
  final String? driverName;
  final String? driverImageUrl;
  final String? driverRole;
  final String? vehicleType;
  final String? plateNumber;
  final String? deliveryAddress;
  final String? deliveryZone;
  final String? orderCode;
  final String? mealSummary;
  final String? slotLabel;
  final int? boxCount;
  final String? stopStatus;

  factory VoiceCallDisplayDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceCallDisplayDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceCallDisplayDtoToJson(this);
}
