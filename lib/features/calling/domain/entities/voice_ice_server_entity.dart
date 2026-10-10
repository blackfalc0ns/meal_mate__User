class VoiceIceServerEntity {
  const VoiceIceServerEntity({
    required this.urls,
    this.username,
    this.credential,
    this.expiresAtUtc,
  });

  final List<String> urls;
  final String? username;
  final String? credential;
  final DateTime? expiresAtUtc;
}

class VoiceIceServersConfigEntity {
  const VoiceIceServersConfigEntity({
    required this.iceServers,
    this.ttlSeconds,
  });

  final List<VoiceIceServerEntity> iceServers;
  final int? ttlSeconds;
}
