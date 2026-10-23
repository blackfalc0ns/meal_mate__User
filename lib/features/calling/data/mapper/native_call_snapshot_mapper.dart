import '../../domain/entities/native_call_snapshot_entity.dart';
import '../models/response/native_call_snapshot_dto.dart';

extension NativeCallerDisplayDtoMapper on NativeCallerDisplayDto {
  NativeCallerDisplayEntity toEntity() {
    return NativeCallerDisplayEntity(
      callerName: callerName ?? '',
      callerRole: callerRole,
      avatarUrl: avatarUrl,
      orderNumber: orderNumber,
      deliveryAddress: deliveryAddress,
      addressTitle: addressTitle,
    );
  }
}

extension NativeCallSnapshotDtoMapper on NativeCallSnapshotDto {
  NativeCallSnapshotEntity toEntity() {
    final version = schemaVersion ?? 1;
    if (version != 1) {
      throw FormatException('Unsupported native bridge schemaVersion: $version');
    }

    final rev = revision ?? 0;
    if (rev < 0) {
      throw FormatException('Negative revision not allowed: $rev');
    }

    final mappedPhase = _parsePhase(phase);

    if (mappedPhase != NativeCallPhase.idle &&
        (callId == null || callId!.trim().isEmpty)) {
      throw const FormatException('Non-idle call snapshot requires valid callId');
    }

    DateTime? connectedAt;
    if (connectedAtUtc != null && connectedAtUtc!.isNotEmpty) {
      connectedAt = DateTime.tryParse(connectedAtUtc!);
    }

    return NativeCallSnapshotEntity(
      schemaVersion: version,
      engineInstanceId: engineInstanceId ?? '',
      revision: rev,
      callId: callId,
      lifecycleId: lifecycleId,
      serverSequence: serverSequence ?? 0,
      negotiationGeneration: negotiationGeneration ?? 0,
      phase: mappedPhase,
      serverStatus: serverStatus,
      microphonePermission: _parsePermission(microphonePermission),
      isMuted: isMuted ?? false,
      audioRouteId: audioRouteId ?? 'earpiece',
      availableAudioRoutes: availableAudioRoutes ?? const ['earpiece', 'speaker'],
      mediaTransportConnected: mediaTransportConnected ?? false,
      audioSessionActive: audioSessionActive ?? false,
      connectedAtUtc: connectedAt,
      elapsedSeconds: elapsedSeconds ?? 0,
      errorCode: errorCode,
      callerDisplay: callerDisplay?.toEntity(),
    );
  }

  static NativeCallPhase _parsePhase(String? phaseStr) {
    switch (phaseStr?.toLowerCase().trim()) {
      case 'idle':
        return NativeCallPhase.idle;
      case 'ringing':
        return NativeCallPhase.ringing;
      case 'permissionrequired':
      case 'permission_required':
        return NativeCallPhase.permissionRequired;
      case 'answering':
        return NativeCallPhase.answering;
      case 'connecting':
        return NativeCallPhase.connecting;
      case 'connected':
        return NativeCallPhase.connected;
      case 'reconnecting':
        return NativeCallPhase.reconnecting;
      case 'ending':
        return NativeCallPhase.ending;
      case 'ended':
        return NativeCallPhase.ended;
      default:
        return NativeCallPhase.unknown;
    }
  }

  static NativeMicrophonePermission _parsePermission(String? permStr) {
    switch (permStr?.toLowerCase().trim()) {
      case 'granted':
        return NativeMicrophonePermission.granted;
      case 'denied':
        return NativeMicrophonePermission.denied;
      case 'permanentlydenied':
      case 'permanently_denied':
        return NativeMicrophonePermission.permanentlyDenied;
      case 'restricted':
        return NativeMicrophonePermission.restricted;
      default:
        return NativeMicrophonePermission.notDetermined;
    }
  }
}
