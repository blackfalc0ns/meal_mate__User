import 'package:json_annotation/json_annotation.dart';

part 'voice_media_report_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceMediaReportRequestDto {
  const VoiceMediaReportRequestDto({
    this.callId,
    this.timestampUtc,
    this.metrics,
  });

  final String? callId;
  final String? timestampUtc;
  final Map<String, dynamic>? metrics;

  factory VoiceMediaReportRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceMediaReportRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceMediaReportRequestDtoToJson(this);
}
