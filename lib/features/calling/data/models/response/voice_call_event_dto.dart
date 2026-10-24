import 'package:json_annotation/json_annotation.dart';

part 'voice_call_event_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceCallEventDto {
  const VoiceCallEventDto({
    this.eventId,
    this.protocolVersion,
    this.callId,
    this.sequence,
    this.eventType,
    this.occurredAtUtc,
    this.sentAtUtc,
    this.expiresAtUtc,
    this.payload,
  });

  final String? eventId;
  final int? protocolVersion;
  final String? callId;
  final int? sequence;
  final String? eventType;
  final DateTime? occurredAtUtc;
  final DateTime? sentAtUtc;
  final DateTime? expiresAtUtc;
  final Map<String, dynamic>? payload;

  factory VoiceCallEventDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceCallEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceCallEventDtoToJson(this);
}
