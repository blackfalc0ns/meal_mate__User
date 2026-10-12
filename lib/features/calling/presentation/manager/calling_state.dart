import '../../domain/entities/call_driver_entity.dart';
import '../../domain/entities/voice_call_display_entity.dart';
import '../../domain/entities/voice_call_snapshot_entity.dart';
import '../../domain/entities/voice_call_status.dart';

class CallingState {
  const CallingState({
    this.snapshot,
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
    if (display != null && display!.resolvedDriverName.isNotEmpty) {
      return display!.resolvedDriverName;
    }
    if (driver != null && driver!.name.isNotEmpty) {
      return driver!.name;
    }
    return fallback;
  }

  String resolvedDriverRole(String fallback) {
    if (display != null &&
        display!.driverRole != null &&
        display!.driverRole!.trim().isNotEmpty) {
      return display!.driverRole!.trim();
    }
    if (driver != null && driver!.role.isNotEmpty) {
      return driver!.role;
    }
    return fallback;
  }

  String resolvedDeliveryAddress(String fallback) {
    if (display != null && display!.resolvedAddress.isNotEmpty) {
      return display!.resolvedAddress;
    }
    if (driver != null && driver!.addressDetails.isNotEmpty) {
      return driver!.addressDetails;
    }
    return fallback;
  }

  String? resolvedDriverImageUrl(String baseUrl) {
    return display?.resolveDriverImageUrl(baseUrl);
  }

  CallingState copyWith({
    VoiceCallSnapshotEntity? Function()? snapshot,
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
