import '../models/response/native_call_snapshot_dto.dart';

abstract class NativeVoiceDataSource {
  Future<NativeCallSnapshotDto> getSnapshot();
  Future<void> answer({
    required String callId,
    required String lifecycleId,
    required String requestId,
  });
  Future<void> reject({
    required String callId,
    required String lifecycleId,
    required String requestId,
  });
  Future<void> end({
    required String callId,
    required String lifecycleId,
    required String requestId,
  });
  Future<void> setMuted({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  });
  Future<void> setAudioRoute({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  });
  Future<String> getMicrophonePermission();
  Future<String> requestMicrophonePermission();
  Future<bool> openAppSettings();
  Future<void> setPresentationContext({
    required bool appVisible,
    String? localeTag,
    int? uiRevision,
  });
  Stream<NativeCallSnapshotDto> get snapshotStream;
}
