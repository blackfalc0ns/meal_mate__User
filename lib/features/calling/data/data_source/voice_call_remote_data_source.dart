import '../models/request/voice_device_register_request_dto.dart';
import '../models/request/voice_media_report_request_dto.dart';
import '../models/response/voice_call_display_dto.dart';
import '../models/response/voice_call_event_dto.dart';
import '../models/response/voice_call_history_page_dto.dart';
import '../models/response/voice_call_snapshot_dto.dart';
import '../models/response/voice_device_register_response_dto.dart';
import '../models/response/voice_ice_servers_response_dto.dart';

abstract interface class VoiceCallRemoteDataSource {
  Future<VoiceDeviceRegisterResponseDto> registerDevice(
    VoiceDeviceRegisterRequestDto request,
  );

  Future<void> revokeDevice(
    String deviceSessionId, {
    required String session,
    required String proof,
  });

  Future<VoiceCallSnapshotDto?> getActiveCall({
    required String session,
    required String proof,
  });

  Future<VoiceCallSnapshotDto> getCallDetails(
    String callId, {
    required String session,
    required String proof,
  });

  Future<VoiceCallHistoryPageDto> getCallHistory(
    String tripStopId, {
    required int page,
    required int pageSize,
    required String session,
    required String proof,
  });

  Future<List<VoiceCallEventDto>> getCallEvents(
    String callId, {
    required int afterSequence,
    required String session,
    required String proof,
  });

  Future<void> ackRinging(
    String callId, {
    required String session,
    required String proof,
  });

  Future<void> answerCall(
    String callId, {
    required String session,
    required String proof,
  });

  Future<void> rejectCall(
    String callId, {
    required String session,
    required String proof,
  });

  Future<void> endCall(
    String callId, {
    required String session,
    required String proof,
  });

  Future<VoiceIceServersResponseDto> getIceServers(
    String callId, {
    required String session,
    required String proof,
  });

  Future<void> reportConnecting(
    String callId, {
    required String session,
    required String proof,
    VoiceMediaReportRequestDto? report,
  });

  Future<void> reportConnected(
    String callId, {
    required String session,
    required String proof,
    VoiceMediaReportRequestDto? report,
  });

  Future<void> sendHeartbeat(
    String callId, {
    required String session,
    required String proof,
  });

  Future<VoiceCallDisplayDto> getCallDisplay(
    String callId, {
    String? language,
  });
}
