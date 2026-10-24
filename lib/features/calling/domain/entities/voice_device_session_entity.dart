class VoiceDeviceSessionEntity {
  const VoiceDeviceSessionEntity({
    required this.deviceSessionId,
    required this.controlProof,
    required this.expiresAtUtc,
    this.fcmDeviceTokenId,
  });

  final String deviceSessionId;
  final String controlProof;
  final DateTime expiresAtUtc;
  final String? fcmDeviceTokenId;

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAtUtc);

  bool get isValid => !isExpired && deviceSessionId.isNotEmpty && controlProof.isNotEmpty;
}
