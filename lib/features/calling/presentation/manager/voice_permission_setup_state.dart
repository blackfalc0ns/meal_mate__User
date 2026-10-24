import '../../domain/entities/native_call_snapshot_entity.dart';

class VoicePermissionSetupState {
  final NativeMicrophonePermission permission;
  final bool isDeferred;
  final bool isLoading;

  const VoicePermissionSetupState({
    this.permission = NativeMicrophonePermission.notDetermined,
    this.isDeferred = false,
    this.isLoading = false,
  });

  bool get isGranted => permission == NativeMicrophonePermission.granted;
  bool get isPermanentlyDenied =>
      permission == NativeMicrophonePermission.permanentlyDenied;

  VoicePermissionSetupState copyWith({
    NativeMicrophonePermission? permission,
    bool? isDeferred,
    bool? isLoading,
  }) {
    return VoicePermissionSetupState(
      permission: permission ?? this.permission,
      isDeferred: isDeferred ?? this.isDeferred,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
