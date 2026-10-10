import 'package:injectable/injectable.dart';
import '../../../../core/network/api_services.dart';
import '../models/request/voice_device_register_request_dto.dart';
import '../models/request/voice_media_report_request_dto.dart';
import '../models/response/voice_call_display_dto.dart';
import '../models/response/voice_call_event_dto.dart';
import '../models/response/voice_call_history_page_dto.dart';
import '../models/response/voice_call_snapshot_dto.dart';
import '../models/response/voice_device_register_response_dto.dart';
import '../models/response/voice_ice_servers_response_dto.dart';
import 'voice_call_remote_data_source.dart';

@Injectable(as: VoiceCallRemoteDataSource)
class VoiceCallRemoteDataSourceImpl implements VoiceCallRemoteDataSource {
  VoiceCallRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<VoiceDeviceRegisterResponseDto> registerDevice(
    VoiceDeviceRegisterRequestDto request,
  ) {
    return _apiServices.registerVoiceDevice(request);
  }

  @override
  Future<void> revokeDevice(
    String deviceSessionId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.revokeVoiceDevice(deviceSessionId, session, proof);
  }

  @override
  Future<VoiceCallSnapshotDto?> getActiveCall({
    required String session,
    required String proof,
  }) async {
    final response = await _apiServices.getActiveVoiceCall(session, proof);
    if (response.response.statusCode == 204 || response.data == null) {
      return null;
    }
    return response.data;
  }

  @override
  Future<VoiceCallSnapshotDto> getCallDetails(
    String callId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.getVoiceCallDetails(callId, session, proof);
  }

  @override
  Future<VoiceCallHistoryPageDto> getCallHistory(
    String tripStopId, {
    required int page,
    required int pageSize,
    required String session,
    required String proof,
  }) {
    return _apiServices.getVoiceCallHistory(tripStopId, page, pageSize, session, proof);
  }

  @override
  Future<List<VoiceCallEventDto>> getCallEvents(
    String callId, {
    required int afterSequence,
    required String session,
    required String proof,
  }) {
    return _apiServices.getVoiceCallEvents(callId, afterSequence, session, proof);
  }

  @override
  Future<void> ackRinging(
    String callId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.ackVoiceCallRinging(callId, session, proof);
  }

  @override
  Future<void> answerCall(
    String callId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.answerVoiceCall(callId, session, proof);
  }

  @override
  Future<void> rejectCall(
    String callId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.rejectVoiceCall(callId, session, proof);
  }

  @override
  Future<void> endCall(
    String callId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.endVoiceCall(callId, session, proof);
  }

  @override
  Future<VoiceIceServersResponseDto> getIceServers(
    String callId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.getVoiceIceServers(callId, session, proof);
  }

  @override
  Future<void> reportConnecting(
    String callId, {
    required String session,
    required String proof,
    VoiceMediaReportRequestDto? report,
  }) {
    return _apiServices.reportVoiceConnecting(callId, session, proof, report);
  }

  @override
  Future<void> reportConnected(
    String callId, {
    required String session,
    required String proof,
    VoiceMediaReportRequestDto? report,
  }) {
    return _apiServices.reportVoiceConnected(callId, session, proof, report);
  }

  @override
  Future<void> sendHeartbeat(
    String callId, {
    required String session,
    required String proof,
  }) {
    return _apiServices.sendVoiceHeartbeat(callId, session, proof);
  }

  @override
  Future<VoiceCallDisplayDto> getCallDisplay(
    String callId, {
    String? language,
  }) {
    return _apiServices.getVoiceCallDisplay(callId, language);
  }
}
