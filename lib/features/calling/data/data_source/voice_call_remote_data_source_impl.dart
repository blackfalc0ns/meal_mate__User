import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/services/server_time_service.dart';
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
  VoiceCallRemoteDataSourceImpl(
    this._apiServices, [
    this._serverTimeService,
  ]);

  final ApiServices _apiServices;
  final ServerTimeService? _serverTimeService;

  ServerTimeService get _resolvedServerTimeService {
    if (_serverTimeService != null) return _serverTimeService;
    if (getIt.isRegistered<ServerTimeService>()) {
      return getIt<ServerTimeService>();
    }
    return ServerTimeService();
  }

  void _inspectHeaders(Headers? headers) {
    final date = headers?.value('date');
    if (date != null) {
      _resolvedServerTimeService.updateWithServerDateHeader(date);
    }
  }

  String _formatError(Object e) {
    if (e is DioException) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      String? backendCode;
      if (data is Map) {
        backendCode = data['errorCode']?.toString() ??
            data['code']?.toString() ??
            data['message']?.toString();
      }
      return 'HTTP $status (backendCode: $backendCode)';
    }
    return e.toString();
  }

  @override
  Future<VoiceDeviceRegisterResponseDto> registerDevice(
    VoiceDeviceRegisterRequestDto request,
  ) async {
    debugPrint('[REST:VoiceCall] registerDevice (platform: ${request.platform}, cap: ${request.capabilityVersion})');
    try {
      final res = await _apiServices.registerVoiceDevice(request);
      debugPrint('[REST:VoiceCall] registerDevice success (session: ${res.deviceSessionId})');
      return res;
    } catch (e) {
      debugPrint('[REST:VoiceCall] registerDevice error: ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> revokeDevice(
    String deviceSessionId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] revokeDevice (sessionId: $deviceSessionId)');
    try {
      await _apiServices.revokeVoiceDevice(deviceSessionId, session, proof);
      debugPrint('[REST:VoiceCall] revokeDevice success');
    } catch (e) {
      debugPrint('[REST:VoiceCall] revokeDevice error: ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<VoiceCallSnapshotDto?> getActiveCall({
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] getActiveCall');
    try {
      final response = await _apiServices.getActiveVoiceCall(session, proof);
      _inspectHeaders(response.response.headers);
      final status = response.response.statusCode;
      debugPrint('[REST:VoiceCall] getActiveCall HTTP $status (hasData: ${response.data != null})');
      if (status == 204 || response.data == null) {
        return null;
      }
      return response.data;
    } catch (e) {
      debugPrint('[REST:VoiceCall] getActiveCall error: ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<VoiceCallSnapshotDto> getCallDetails(
    String callId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] getCallDetails (callId: $callId)');
    try {
      final res = await _apiServices.getVoiceCallDetails(callId, session, proof);
      debugPrint('[REST:VoiceCall] getCallDetails success (callId: $callId, status: ${res.status}, seq: ${res.sequence})');
      return res;
    } catch (e) {
      debugPrint('[REST:VoiceCall] getCallDetails error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<VoiceCallHistoryPageDto> getCallHistory(
    String tripStopId, {
    required int page,
    required int pageSize,
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] getCallHistory (tripStopId: $tripStopId, page: $page)');
    try {
      final res = await _apiServices.getVoiceCallHistory(tripStopId, page, pageSize, session, proof);
      debugPrint('[REST:VoiceCall] getCallHistory success');
      return res;
    } catch (e) {
      debugPrint('[REST:VoiceCall] getCallHistory error: ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<List<VoiceCallEventDto>> getCallEvents(
    String callId, {
    required int afterSequence,
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] getCallEvents (callId: $callId, afterSeq: $afterSequence)');
    try {
      final res = await _apiServices.getVoiceCallEvents(callId, afterSequence, session, proof);
      debugPrint('[REST:VoiceCall] getCallEvents success (eventsCount: ${res.length})');
      return res;
    } catch (e) {
      debugPrint('[REST:VoiceCall] getCallEvents error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> ackRinging(
    String callId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] ackRinging (callId: $callId)');
    try {
      await _apiServices.ackVoiceCallRinging(callId, session, proof);
      debugPrint('[REST:VoiceCall] ackRinging success (callId: $callId)');
    } catch (e) {
      debugPrint('[REST:VoiceCall] ackRinging error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> answerCall(
    String callId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] answerCall (callId: $callId)');
    try {
      await _apiServices.answerVoiceCall(callId, session, proof);
      debugPrint('[REST:VoiceCall] answerCall success (callId: $callId)');
    } catch (e) {
      debugPrint('[REST:VoiceCall] answerCall error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> rejectCall(
    String callId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] rejectCall (callId: $callId)');
    try {
      await _apiServices.rejectVoiceCall(callId, session, proof);
      debugPrint('[REST:VoiceCall] rejectCall success (callId: $callId)');
    } catch (e) {
      debugPrint('[REST:VoiceCall] rejectCall error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> endCall(
    String callId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] endCall (callId: $callId)');
    try {
      await _apiServices.endVoiceCall(callId, session, proof);
      debugPrint('[REST:VoiceCall] endCall success (callId: $callId)');
    } catch (e) {
      debugPrint('[REST:VoiceCall] endCall error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<VoiceIceServersResponseDto> getIceServers(
    String callId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] getIceServers (callId: $callId)');
    try {
      final res = await _apiServices.getVoiceIceServers(callId, session, proof);
      debugPrint('[REST:VoiceCall] getIceServers success (callId: $callId, count: ${res.iceServers?.length})');
      return res;
    } catch (e) {
      debugPrint('[REST:VoiceCall] getIceServers error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> reportConnecting(
    String callId, {
    required String session,
    required String proof,
    VoiceMediaReportRequestDto? report,
  }) async {
    debugPrint('[REST:VoiceCall] reportConnecting (callId: $callId)');
    try {
      await _apiServices.reportVoiceConnecting(callId, session, proof, report);
      debugPrint('[REST:VoiceCall] reportConnecting success (callId: $callId)');
    } catch (e) {
      debugPrint('[REST:VoiceCall] reportConnecting error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> reportConnected(
    String callId, {
    required String session,
    required String proof,
    VoiceMediaReportRequestDto? report,
  }) async {
    debugPrint('[REST:VoiceCall] reportConnected (callId: $callId)');
    try {
      await _apiServices.reportVoiceConnected(callId, session, proof, report);
      debugPrint('[REST:VoiceCall] reportConnected success (callId: $callId)');
    } catch (e) {
      debugPrint('[REST:VoiceCall] reportConnected error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<void> sendHeartbeat(
    String callId, {
    required String session,
    required String proof,
  }) async {
    debugPrint('[REST:VoiceCall] sendHeartbeat (callId: $callId)');
    try {
      await _apiServices.sendVoiceHeartbeat(callId, session, proof);
      debugPrint('[REST:VoiceCall] sendHeartbeat success (callId: $callId)');
    } catch (e) {
      debugPrint('[REST:VoiceCall] sendHeartbeat error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }

  @override
  Future<VoiceCallDisplayDto> getCallDisplay(
    String callId, {
    String? language,
  }) async {
    debugPrint('[REST:VoiceCall] getCallDisplay (callId: $callId, lang: $language)');
    try {
      final res = await _apiServices.getVoiceCallDisplay(callId, language);
      debugPrint('[REST:VoiceCall] getCallDisplay success (callId: $callId, driver: ${res.driverName})');
      return res;
    } catch (e) {
      debugPrint('[REST:VoiceCall] getCallDisplay error (callId: $callId): ${_formatError(e)}');
      rethrow;
    }
  }
}
