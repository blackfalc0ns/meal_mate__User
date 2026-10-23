import '../../domain/entities/call_driver_entity.dart';
import '../../domain/entities/native_call_snapshot_entity.dart';
import '../../domain/entities/voice_call_display_entity.dart';
import '../../domain/entities/voice_call_snapshot_entity.dart';
import '../../domain/entities/voice_call_status.dart';

class CallingState {
  const CallingState({
    this.snapshot,
    this.nativeSnapshot,
    this.driver,
    this.display,
    this.status = VoiceCallStatus.unknown,
    this.durationSeconds = 0,
    this.isMuted = false,
    this.isSpeakerOn = false,
    this.isLoading = false,
    this.hasAudioPermissionError = false,
    this.errorMessage,
  });

  final VoiceCallSnapshotEntity? snapshot;
  final NativeCallSnapshotEntity? nativeSnapshot;
  final CallDriverEntity? driver;
  final VoiceCallDisplayEntity? display;
  final VoiceCallStatus status;
  final int durationSeconds;
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isLoading;
  final bool hasAudioPermissionError;
  final String? errorMessage;

  String get formattedDuration {
    final minutes = (durationSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String resolvedDriverName(String fallback) {
    if (nativeSnapshot?.callerDisplay?.callerName.isNotEmpty == true &&
        nativeSnapshot!.callerDisplay!.callerName.toLowerCase() != 'null') {
      return nativeSnapshot!.callerDisplay!.callerName;
    }
    return fallback;
  }

  String resolvedDriverRole(String fallback) {
    if (nativeSnapshot?.callerDisplay?.callerRole?.trim().isNotEmpty == true &&
        nativeSnapshot!.callerDisplay!.callerRole!.trim().toLowerCase() !=
            'null') {
      return nativeSnapshot!.callerDisplay!.callerRole!.trim();
    }
    return fallback;
  }

  String resolvedDeliveryAddress(String fallback) {
    return fallback;
  }

  String? resolvedDriverImageUrl(String baseUrl) {
    if (nativeSnapshot?.callerDisplay?.avatarUrl != null &&
        nativeSnapshot!.callerDisplay!.avatarUrl!.trim().isNotEmpty) {
      final url = nativeSnapshot!.callerDisplay!.avatarUrl!.trim();
      if (url.toLowerCase() == 'null') return null;
      return Uri.parse(baseUrl).resolve(url).toString();
    }
    return null;
  }

  CallingState copyWith({
    VoiceCallSnapshotEntity? Function()? snapshot,
    NativeCallSnapshotEntity? Function()? nativeSnapshot,
    CallDriverEntity? Function()? driver,
    VoiceCallDisplayEntity? Function()? display,
    VoiceCallStatus? status,
    int? durationSeconds,
    bool? isMuted,
    bool? isSpeakerOn,
    bool? isLoading,
    bool? hasAudioPermissionError,
    String? Function()? errorMessage,
  }) {
    return CallingState(
      snapshot: snapshot != null ? snapshot() : this.snapshot,
      nativeSnapshot: nativeSnapshot != null
          ? nativeSnapshot()
          : this.nativeSnapshot,
      driver: driver != null ? driver() : this.driver,
      display: display != null ? display() : this.display,
      status: status ?? this.status,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isLoading: isLoading ?? this.isLoading,
      hasAudioPermissionError:
          hasAudioPermissionError ?? this.hasAudioPermissionError,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
