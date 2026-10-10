enum VoiceCallStatus {
  created,
  ringing,
  accepted,
  connecting,
  active,
  rejected,
  cancelled,
  missed,
  failed,
  ended,
  unknown;

  static VoiceCallStatus fromString(String? value) {
    if (value == null) return VoiceCallStatus.unknown;
    return switch (value.trim().toLowerCase()) {
      'created' => VoiceCallStatus.created,
      'ringing' => VoiceCallStatus.ringing,
      'accepted' => VoiceCallStatus.accepted,
      'connecting' => VoiceCallStatus.connecting,
      'active' => VoiceCallStatus.active,
      'rejected' => VoiceCallStatus.rejected,
      'cancelled' => VoiceCallStatus.cancelled,
      'missed' => VoiceCallStatus.missed,
      'failed' => VoiceCallStatus.failed,
      'ended' => VoiceCallStatus.ended,
      _ => VoiceCallStatus.unknown,
    };
  }

  bool get isTerminal => switch (this) {
    VoiceCallStatus.rejected ||
    VoiceCallStatus.cancelled ||
    VoiceCallStatus.missed ||
    VoiceCallStatus.failed ||
    VoiceCallStatus.ended => true,
    _ => false,
  };

  bool get isLive => switch (this) {
    VoiceCallStatus.accepted ||
    VoiceCallStatus.connecting ||
    VoiceCallStatus.active => true,
    _ => false,
  };

  bool get isRinging => this == VoiceCallStatus.ringing;
}
