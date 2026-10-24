import 'voice_call_status.dart';

class VoiceCallSnapshotEntity {
  const VoiceCallSnapshotEntity({
    required this.callId,
    required this.tripStopId,
    required this.protocolVersion,
    required this.sequence,
    required this.status,
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

  final String callId;
  final String tripStopId;
  final int protocolVersion;
  final int sequence;
  final VoiceCallStatus status;
  final String? endReason;
  final DateTime? startedAtUtc;
  final DateTime? acceptedAtUtc;
  final DateTime? connectedAtUtc;
  final DateTime? endedAtUtc;
  final int? durationSeconds;
  final DateTime? deadlineAtUtc;
  final String? winningDeviceSessionId;
  final String? localParticipantRole;

  bool get isExpired {
    if (deadlineAtUtc == null) return false;
    return DateTime.now().toUtc().isAfter(deadlineAtUtc!);
  }

  bool isWonBy(String? mySessionId) {
    if (winningDeviceSessionId == null) return true;
    if (mySessionId == null) return false;
    return winningDeviceSessionId == mySessionId;
  }
}
