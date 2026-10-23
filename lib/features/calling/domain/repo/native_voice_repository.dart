import '../../../../core/network/api_results.dart';
import '../entities/native_call_snapshot_entity.dart';

abstract class NativeVoiceRepository {
  Future<ApiResult<NativeCallSnapshotEntity>> getSnapshot();
  Future<ApiResult<void>> answer({
    required String callId,
    required String lifecycleId,
    required String requestId,
  });
  Future<ApiResult<void>> reject({
    required String callId,
    required String lifecycleId,
    required String requestId,
  });
  Future<ApiResult<void>> end({
    required String callId,
    required String lifecycleId,
    required String requestId,
  });
  Future<ApiResult<void>> setMuted({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  });
  Future<ApiResult<void>> setAudioRoute({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  });
  Future<ApiResult<NativeMicrophonePermission>> getMicrophonePermission();
  Future<ApiResult<NativeMicrophonePermission>> requestMicrophonePermission();
  Future<ApiResult<bool>> openAppSettings();
  Future<ApiResult<void>> setPresentationContext({
    required bool appVisible,
    String? localeTag,
    int? uiRevision,
  });
  Stream<NativeCallSnapshotEntity> get snapshotStream;
}
