import 'voice_call_snapshot_entity.dart';

class VoiceCallEventEntity {
  const VoiceCallEventEntity({
    required this.eventId,
    required this.protocolVersion,
    required this.callId,
    required this.sequence,
    required this.eventType,
    required this.occurredAtUtc,
    this.sentAtUtc,
    this.expiresAtUtc,
    this.payloadSnapshot,
    this.rawPayload,
  });

  final String eventId;
  final int protocolVersion;
  final String callId;
  final int sequence;
  final String eventType;
  final DateTime occurredAtUtc;
  final DateTime? sentAtUtc;
  final DateTime? expiresAtUtc;
  final VoiceCallSnapshotEntity? payloadSnapshot;
  final Map<String, dynamic>? rawPayload;
}
