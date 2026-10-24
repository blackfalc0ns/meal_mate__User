import '../models/response/voice_call_display_dto.dart';
import '../models/response/voice_call_event_dto.dart';
import '../models/response/voice_call_history_page_dto.dart';
import '../models/response/voice_call_snapshot_dto.dart';
import '../models/response/voice_device_register_response_dto.dart';
import '../models/response/voice_ice_server_dto.dart';
import '../models/response/voice_ice_servers_response_dto.dart';
import '../../domain/entities/voice_call_display_entity.dart';
import '../../domain/entities/voice_call_event_entity.dart';
import '../../domain/entities/voice_call_history_page_entity.dart';
import '../../domain/entities/voice_call_snapshot_entity.dart';
import '../../domain/entities/voice_call_status.dart';
import '../../domain/entities/voice_device_session_entity.dart';
import '../../domain/entities/voice_ice_server_entity.dart';

abstract class VoiceCallMapper {
  static VoiceDeviceSessionEntity toDeviceSessionEntity(
    VoiceDeviceRegisterResponseDto dto, {
    String? fcmDeviceTokenId,
  }) {
    return VoiceDeviceSessionEntity(
      deviceSessionId: dto.deviceSessionId ?? '',
      controlProof: dto.controlProof ?? '',
      expiresAtUtc: dto.expiresAtUtc ?? DateTime.now().toUtc().add(const Duration(hours: 24)),
      fcmDeviceTokenId: fcmDeviceTokenId,
    );
  }

  static VoiceCallSnapshotEntity toSnapshotEntity(VoiceCallSnapshotDto dto) {
    return VoiceCallSnapshotEntity(
      callId: dto.callId ?? '',
      tripStopId: dto.tripStopId ?? '',
      protocolVersion: dto.protocolVersion ?? 2,
      sequence: dto.sequence ?? 0,
      status: VoiceCallStatus.fromString(dto.status),
      endReason: dto.endReason,
      startedAtUtc: dto.startedAtUtc,
      acceptedAtUtc: dto.acceptedAtUtc,
      connectedAtUtc: dto.connectedAtUtc,
      endedAtUtc: dto.endedAtUtc,
      durationSeconds: dto.durationSeconds,
      deadlineAtUtc: dto.deadlineAtUtc,
      winningDeviceSessionId: dto.winningDeviceSessionId,
      localParticipantRole: dto.localParticipantRole,
    );
  }

  static VoiceCallEventEntity toEventEntity(VoiceCallEventDto dto) {
    VoiceCallSnapshotEntity? snapshot;
    if (dto.payload != null) {
      try {
        final snapshotDto = VoiceCallSnapshotDto.fromJson(dto.payload!);
        if (snapshotDto.callId != null && snapshotDto.callId!.isNotEmpty) {
          snapshot = toSnapshotEntity(snapshotDto);
        }
      } catch (_) {
        // payload might not be a snapshot
      }
    }

    return VoiceCallEventEntity(
      eventId: dto.eventId ?? '',
      protocolVersion: dto.protocolVersion ?? 2,
      callId: dto.callId ?? '',
      sequence: dto.sequence ?? 0,
      eventType: dto.eventType ?? '',
      occurredAtUtc: dto.occurredAtUtc ?? DateTime.now().toUtc(),
      sentAtUtc: dto.sentAtUtc,
      expiresAtUtc: dto.expiresAtUtc,
      payloadSnapshot: snapshot,
      rawPayload: dto.payload,
    );
  }

  static VoiceIceServerEntity toIceServerEntity(VoiceIceServerDto dto) {
    final urls = <String>[];
    if (dto.urls != null && dto.urls!.isNotEmpty) {
      urls.addAll(dto.urls!);
    } else if (dto.url != null && dto.url!.isNotEmpty) {
      urls.add(dto.url!);
    }

    return VoiceIceServerEntity(
      urls: urls,
      username: dto.username,
      credential: dto.credential,
      expiresAtUtc: dto.expiresAtUtc,
    );
  }

  static VoiceIceServersConfigEntity toIceServersConfigEntity(
    VoiceIceServersResponseDto dto,
  ) {
    final list = dto.iceServers?.map(toIceServerEntity).toList() ?? <VoiceIceServerEntity>[];
    return VoiceIceServersConfigEntity(
      iceServers: list,
      ttlSeconds: dto.ttlSeconds,
    );
  }

  static VoiceCallHistoryPageEntity toHistoryPageEntity(
    VoiceCallHistoryPageDto dto,
  ) {
    final items = dto.items?.map(toSnapshotEntity).toList() ?? <VoiceCallSnapshotEntity>[];
    return VoiceCallHistoryPageEntity(
      items: items,
      totalCount: dto.totalCount ?? items.length,
      page: dto.page ?? 1,
      pageSize: dto.pageSize ?? items.length,
    );
  }

  static VoiceCallDisplayEntity toDisplayEntity(VoiceCallDisplayDto dto) {
    return VoiceCallDisplayEntity(
      callId: dto.callId ?? '',
      tripStopId: dto.tripStopId,
      driverName: dto.driverName,
      driverImageUrl: dto.driverImageUrl,
      driverRole: dto.driverRole,
      vehicleType: dto.vehicleType,
      plateNumber: dto.plateNumber,
      deliveryAddress: dto.deliveryAddress,
      deliveryZone: dto.deliveryZone,
      orderCode: dto.orderCode,
      mealSummary: dto.mealSummary,
      slotLabel: dto.slotLabel,
      boxCount: dto.boxCount,
      stopStatus: dto.stopStatus,
    );
  }
}
