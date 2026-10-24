import 'package:json_annotation/json_annotation.dart';

part 'voice_call_snapshot_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VoiceCallSnapshotDto {
  const VoiceCallSnapshotDto({
    this.callId,
    this.tripStopId,
    this.protocolVersion,
    this.sequence,
    this.status,
    this.endReason,
    this.startedAtUtc,
    this.acceptedAtUtc,
    this.connectedAtUtc,
    this.endedAtUtc,
    this.durationSeconds,
    this.deadlineAtUtc,
    this.winningDeviceSessionId,
    this.localParticipantRole,
  });

  final String? callId;
  final String? tripStopId;
  final int? protocolVersion;
  final int? sequence;
  final String? status;
  final String? endReason;
  final DateTime? startedAtUtc;
  final DateTime? acceptedAtUtc;
  final DateTime? connectedAtUtc;
  final DateTime? endedAtUtc;
  final int? durationSeconds;
  final DateTime? deadlineAtUtc;
  final String? winningDeviceSessionId;
  final String? localParticipantRole;

  factory VoiceCallSnapshotDto.fromJson(Map<String, dynamic> json) =>
      _$VoiceCallSnapshotDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceCallSnapshotDtoToJson(this);
}
