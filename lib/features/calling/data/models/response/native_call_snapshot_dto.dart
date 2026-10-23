class NativeCallerDisplayDto {
  final String? callerName;
  final String? callerRole;
  final String? avatarUrl;
  final String? orderNumber;

  const NativeCallerDisplayDto({
    this.callerName,
    this.callerRole,
    this.avatarUrl,
    this.orderNumber,
  });

  factory NativeCallerDisplayDto.fromJson(Map<String, dynamic> json) {
    return NativeCallerDisplayDto(
      callerName: json['callerName']?.toString(),
      callerRole: json['callerRole']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      orderNumber: json['orderNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'callerName': callerName,
        'callerRole': callerRole,
        'avatarUrl': avatarUrl,
        'orderNumber': orderNumber,
      };
}

class NativeCallSnapshotDto {
  final int? schemaVersion;
  final String? engineInstanceId;
  final int? revision;
  final String? callId;
  final String? lifecycleId;
  final int? serverSequence;
  final int? negotiationGeneration;
  final String? phase;
  final String? serverStatus;
  final String? microphonePermission;
  final bool? isMuted;
  final String? audioRouteId;
  final List<String>? availableAudioRoutes;
  final bool? mediaTransportConnected;
  final bool? audioSessionActive;
  final String? connectedAtUtc;
  final int? elapsedSeconds;
  final String? errorCode;
  final NativeCallerDisplayDto? callerDisplay;

  const NativeCallSnapshotDto({
    this.schemaVersion,
    this.engineInstanceId,
    this.revision,
    this.callId,
    this.lifecycleId,
    this.serverSequence,
    this.negotiationGeneration,
    this.phase,
    this.serverStatus,
    this.microphonePermission,
    this.isMuted,
    this.audioRouteId,
    this.availableAudioRoutes,
    this.mediaTransportConnected,
    this.audioSessionActive,
    this.connectedAtUtc,
    this.elapsedSeconds,
    this.errorCode,
    this.callerDisplay,
  });

  factory NativeCallSnapshotDto.fromJson(Map<String, dynamic> json) {
    List<String>? routes;
    if (json['availableAudioRoutes'] is List) {
      routes = (json['availableAudioRoutes'] as List)
          .map((e) => e.toString())
          .toList();
    }

    NativeCallerDisplayDto? display;
    if (json['callerDisplay'] is Map) {
      display = NativeCallerDisplayDto.fromJson(
        Map<String, dynamic>.from(json['callerDisplay'] as Map),
      );
    }

    return NativeCallSnapshotDto(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt(),
      engineInstanceId: json['engineInstanceId']?.toString(),
      revision: (json['revision'] as num?)?.toInt(),
      callId: json['callId']?.toString(),
      lifecycleId: json['lifecycleId']?.toString(),
      serverSequence: (json['serverSequence'] as num?)?.toInt(),
      negotiationGeneration: (json['negotiationGeneration'] as num?)?.toInt(),
      phase: json['phase']?.toString(),
      serverStatus: json['serverStatus']?.toString(),
      microphonePermission: json['microphonePermission']?.toString(),
      isMuted: json['isMuted'] as bool?,
      audioRouteId: json['audioRouteId']?.toString(),
      availableAudioRoutes: routes,
      mediaTransportConnected: json['mediaTransportConnected'] as bool?,
      audioSessionActive: json['audioSessionActive'] as bool?,
      connectedAtUtc: json['connectedAtUtc']?.toString(),
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt(),
      errorCode: json['errorCode']?.toString(),
      callerDisplay: display,
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'engineInstanceId': engineInstanceId,
        'revision': revision,
        'callId': callId,
        'lifecycleId': lifecycleId,
        'serverSequence': serverSequence,
        'negotiationGeneration': negotiationGeneration,
        'phase': phase,
        'serverStatus': serverStatus,
        'microphonePermission': microphonePermission,
        'isMuted': isMuted,
        'audioRouteId': audioRouteId,
        'availableAudioRoutes': availableAudioRoutes,
        'mediaTransportConnected': mediaTransportConnected,
        'audioSessionActive': audioSessionActive,
        'connectedAtUtc': connectedAtUtc,
        'elapsedSeconds': elapsedSeconds,
        'errorCode': errorCode,
        'callerDisplay': callerDisplay?.toJson(),
      };
}
