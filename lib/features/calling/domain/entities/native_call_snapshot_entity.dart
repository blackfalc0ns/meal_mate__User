enum NativeCallPhase {
  idle,
  ringing,
  permissionRequired,
  answering,
  connecting,
  connected,
  reconnecting,
  ending,
  ended,
  unknown,
}

enum NativeMicrophonePermission {
  notDetermined,
  granted,
  denied,
  permanentlyDenied,
  restricted,
}

class NativeCallerDisplayEntity {
  final String callerName;
  final String? callerRole;
  final String? avatarUrl;
  final String? orderNumber;
  final String? deliveryAddress;
  final String? addressTitle;

  const NativeCallerDisplayEntity({
    required this.callerName,
    this.callerRole,
    this.avatarUrl,
    this.orderNumber,
    this.deliveryAddress,
    this.addressTitle,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NativeCallerDisplayEntity &&
          runtimeType == other.runtimeType &&
          callerName == other.callerName &&
          callerRole == other.callerRole &&
          avatarUrl == other.avatarUrl &&
          orderNumber == other.orderNumber &&
          deliveryAddress == other.deliveryAddress &&
          addressTitle == other.addressTitle;

  @override
  int get hashCode =>
      callerName.hashCode ^
      callerRole.hashCode ^
      avatarUrl.hashCode ^
      orderNumber.hashCode ^
      deliveryAddress.hashCode ^
      addressTitle.hashCode;
}

class NativeCallSnapshotEntity {
  final int schemaVersion;
  final String engineInstanceId;
  final int revision;
  final String? callId;
  final String? lifecycleId;
  final int serverSequence;
  final int negotiationGeneration;
  final NativeCallPhase phase;
  final String? serverStatus;
  final NativeMicrophonePermission microphonePermission;
  final bool isMuted;
  final String audioRouteId;
  final List<String> availableAudioRoutes;
  final bool mediaTransportConnected;
  final bool audioSessionActive;
  final DateTime? connectedAtUtc;
  final int elapsedSeconds;
  final String? errorCode;
  final NativeCallerDisplayEntity? callerDisplay;

  const NativeCallSnapshotEntity({
    required this.schemaVersion,
    required this.engineInstanceId,
    required this.revision,
    this.callId,
    this.lifecycleId,
    this.serverSequence = 0,
    this.negotiationGeneration = 0,
    required this.phase,
    this.serverStatus,
    this.microphonePermission = NativeMicrophonePermission.notDetermined,
    this.isMuted = false,
    this.audioRouteId = 'earpiece',
    this.availableAudioRoutes = const ['earpiece', 'speaker'],
    this.mediaTransportConnected = false,
    this.audioSessionActive = false,
    this.connectedAtUtc,
    this.elapsedSeconds = 0,
    this.errorCode,
    this.callerDisplay,
  });

  bool get isRinging => phase == NativeCallPhase.ringing;
  bool get isAnswering => phase == NativeCallPhase.answering;
  bool get isConnecting => phase == NativeCallPhase.connecting;
  bool get isConnected => phase == NativeCallPhase.connected;
  bool get isReconnecting => phase == NativeCallPhase.reconnecting;
  bool get isEnding => phase == NativeCallPhase.ending;
  bool get isEnded => phase == NativeCallPhase.ended;
  bool get isIdle => phase == NativeCallPhase.idle;
  bool get isTerminal => phase == NativeCallPhase.ended || phase == NativeCallPhase.idle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NativeCallSnapshotEntity &&
          runtimeType == other.runtimeType &&
          schemaVersion == other.schemaVersion &&
          engineInstanceId == other.engineInstanceId &&
          revision == other.revision &&
          callId == other.callId &&
          lifecycleId == other.lifecycleId &&
          serverSequence == other.serverSequence &&
          negotiationGeneration == other.negotiationGeneration &&
          phase == other.phase &&
          serverStatus == other.serverStatus &&
          microphonePermission == other.microphonePermission &&
          isMuted == other.isMuted &&
          audioRouteId == other.audioRouteId &&
          mediaTransportConnected == other.mediaTransportConnected &&
          audioSessionActive == other.audioSessionActive &&
          connectedAtUtc == other.connectedAtUtc &&
          elapsedSeconds == other.elapsedSeconds &&
          errorCode == other.errorCode &&
          callerDisplay == other.callerDisplay;

  @override
  int get hashCode =>
      schemaVersion.hashCode ^
      engineInstanceId.hashCode ^
      revision.hashCode ^
      (callId?.hashCode ?? 0) ^
      (lifecycleId?.hashCode ?? 0) ^
      serverSequence.hashCode ^
      negotiationGeneration.hashCode ^
      phase.hashCode ^
      (serverStatus?.hashCode ?? 0) ^
      microphonePermission.hashCode ^
      isMuted.hashCode ^
      audioRouteId.hashCode ^
      mediaTransportConnected.hashCode ^
      audioSessionActive.hashCode ^
      (connectedAtUtc?.hashCode ?? 0) ^
      elapsedSeconds.hashCode ^
      (errorCode?.hashCode ?? 0) ^
      (callerDisplay?.hashCode ?? 0);
}
