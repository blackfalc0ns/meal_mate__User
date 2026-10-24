import '../../../../core/network/api_results.dart';
import '../../data/models/request/voice_media_report_request_dto.dart';
import '../entities/voice_call_display_entity.dart';
import '../entities/voice_call_event_entity.dart';
import '../entities/voice_call_history_page_entity.dart';
import '../entities/voice_call_snapshot_entity.dart';
import '../entities/voice_device_session_entity.dart';
import '../entities/voice_ice_server_entity.dart';

abstract interface class VoiceCallRepository {
  Future<ApiResult<VoiceDeviceSessionEntity>> registerDevice({
    String? fcmDeviceTokenId,
    String? apnsVoipToken,
    bool force = false,
  });

  Future<ApiResult<void>> revokeDevice();

  Future<ApiResult<VoiceCallSnapshotEntity?>> getActiveCall();

  Future<ApiResult<VoiceCallSnapshotEntity>> getCallDetails(String callId);

  Future<ApiResult<VoiceCallHistoryPageEntity>> getCallHistory(
    String tripStopId, {
    int page = 1,
    int pageSize = 20,
  });

  Future<ApiResult<List<VoiceCallEventEntity>>> getCallEvents(
    String callId, {
    int afterSequence = 0,
  });

  Future<ApiResult<void>> ackRinging(String callId);

  Future<ApiResult<void>> answerCall(String callId);

  Future<ApiResult<void>> rejectCall(String callId);

  Future<ApiResult<void>> endCall(String callId);

  Future<ApiResult<VoiceIceServersConfigEntity>> getIceServers(String callId);

  Future<ApiResult<void>> reportConnecting(
    String callId, {
    VoiceMediaReportRequestDto? report,
  });

  Future<ApiResult<void>> reportConnected(
    String callId, {
    VoiceMediaReportRequestDto? report,
  });

  Future<ApiResult<void>> sendHeartbeat(String callId);

  Future<ApiResult<VoiceCallDisplayEntity>> getCallDisplay(
    String callId, {
    String? language,
  });

  Future<VoiceDeviceSessionEntity?> getCachedDeviceSession();
}
