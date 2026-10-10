import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/services/auth_refresh_service.dart';
import '../../../../core/services/device_id_service.dart';
import '../data_source/voice_call_remote_data_source.dart';
import '../data_source/voice_device_session_storage.dart';
import '../mapper/voice_call_mapper.dart';
import '../models/request/voice_device_register_request_dto.dart';
import '../models/request/voice_media_report_request_dto.dart';
import '../../domain/entities/voice_call_display_entity.dart';
import '../../domain/entities/voice_call_event_entity.dart';
import '../../domain/entities/voice_call_history_page_entity.dart';
import '../../domain/entities/voice_call_snapshot_entity.dart';
import '../../domain/entities/voice_device_session_entity.dart';
import '../../domain/entities/voice_ice_server_entity.dart';
import '../../domain/repo/voice_call_repository.dart';

import '../../../../core/di/di.dart';

@Injectable(as: VoiceCallRepository)
class VoiceCallRepositoryImpl implements VoiceCallRepository {
  VoiceCallRepositoryImpl(
    this._remoteDataSource,
    this._sessionStorage,
    this._deviceIdService,
  );

  final VoiceCallRemoteDataSource _remoteDataSource;
  final VoiceDeviceSessionStorage _sessionStorage;
  final DeviceIdService _deviceIdService;

  AuthRefreshService get _authRefreshService => getIt<AuthRefreshService>();

  @override
  Future<VoiceDeviceSessionEntity?> getCachedDeviceSession() {
    return _sessionStorage.getSession();
  }

  @override
  Future<ApiResult<VoiceDeviceSessionEntity>> registerDevice({
    String? fcmDeviceTokenId,
    String? apnsVoipToken,
    bool force = false,
  }) {
    return safeApiCall(() async {
      if (!force) {
        final existing = await _sessionStorage.getSession();
        if (existing != null && existing.isValid) {
          return existing;
        }
      }

      final installationId = await _deviceIdService.getOrCreateDeviceId();
      final platform = defaultTargetPlatform == TargetPlatform.iOS
          ? 'ios'
          : 'android';

      final resolvedFcmTokenId =
          fcmDeviceTokenId ?? await _sessionStorage.getFcmDeviceTokenId();

      final request = VoiceDeviceRegisterRequestDto(
        installationId: installationId,
        platform: platform,
        capabilityVersion: 2,
        fcmDeviceTokenId: resolvedFcmTokenId,
        apnsVoipToken: apnsVoipToken,
      );

      final responseDto = await _remoteDataSource.registerDevice(request);
      final entity = VoiceCallMapper.toDeviceSessionEntity(
        responseDto,
        fcmDeviceTokenId: resolvedFcmTokenId,
      );

      await _sessionStorage.saveSession(entity);
      return entity;
    });
  }

  @override
  Future<ApiResult<void>> revokeDevice() {
    return safeApiCall(() async {
      final session = await _sessionStorage.getSession();
      if (session != null) {
        try {
          await _remoteDataSource.revokeDevice(
            session.deviceSessionId,
            session: session.deviceSessionId,
            proof: session.controlProof,
          );
        } catch (_) {
          // ignore network failure on revocation
        }
      }
      await _sessionStorage.clearSession();
    });
  }

  Future<VoiceDeviceSessionEntity> _getOrRegisterSession() async {
    final session = await _sessionStorage.getSession();
    if (session != null && session.isValid) {
      return session;
    }

    final regResult = await registerDevice(force: true);
    if (regResult is ApiSuccessResult<VoiceDeviceSessionEntity>) {
      return regResult.data;
    } else if (regResult is ApiErrorResult<VoiceDeviceSessionEntity>) {
      throw regResult.failure.exception;
    }
    throw StateError('Failed to obtain device session');
  }

  Future<ApiResult<T>> _executeWithAuthAndSession<T>(
    Future<T> Function(VoiceDeviceSessionEntity session) action,
  ) {
    return safeApiCall(() async {
      VoiceDeviceSessionEntity session = await _getOrRegisterSession();

      try {
        return await action(session);
      } catch (error) {
        final statusCode = _extractStatusCode(error);

        // 401 Unauthorized -> Refresh JWT and retry once
        if (statusCode == 401) {
          final refreshResult = await _authRefreshService.refreshSession();
          if (refreshResult is ApiSuccessResult) {
            return await action(session);
          }
          rethrow;
        }

        // 403 Forbidden -> Do NOT blindly rotate session during active call.
        // Only re-register if session is expired or locally invalid.
        if (statusCode == 403 && !session.isValid) {
          final regResult = await registerDevice(force: true);
          if (regResult is ApiSuccessResult<VoiceDeviceSessionEntity>) {
            session = regResult.data;
            return await action(session);
          }
        }

        rethrow;
      }
    });
  }

  int? _extractStatusCode(Object error) {
    if (error is ServerFailure) {
      return error.exception.statusCode;
    }
    try {
      final dynamic err = error;
      return err.response?.statusCode ?? err.statusCode;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ApiResult<VoiceCallSnapshotEntity?>> getActiveCall() {
    return _executeWithAuthAndSession((session) async {
      final dto = await _remoteDataSource.getActiveCall(
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
      if (dto == null) return null;
      return VoiceCallMapper.toSnapshotEntity(dto);
    });
  }

  @override
  Future<ApiResult<VoiceCallSnapshotEntity>> getCallDetails(String callId) {
    return _executeWithAuthAndSession((session) async {
      final dto = await _remoteDataSource.getCallDetails(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
      return VoiceCallMapper.toSnapshotEntity(dto);
    });
  }

  @override
  Future<ApiResult<VoiceCallHistoryPageEntity>> getCallHistory(
    String tripStopId, {
    int page = 1,
    int pageSize = 20,
  }) {
    return _executeWithAuthAndSession((session) async {
      final dto = await _remoteDataSource.getCallHistory(
        tripStopId,
        page: page,
        pageSize: pageSize,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
      return VoiceCallMapper.toHistoryPageEntity(dto);
    });
  }

  @override
  Future<ApiResult<List<VoiceCallEventEntity>>> getCallEvents(
    String callId, {
    int afterSequence = 0,
  }) {
    return _executeWithAuthAndSession((session) async {
      final dtos = await _remoteDataSource.getCallEvents(
        callId,
        afterSequence: afterSequence,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
      return dtos.map(VoiceCallMapper.toEventEntity).toList();
    });
  }

  @override
  Future<ApiResult<void>> ackRinging(String callId) {
    return _executeWithAuthAndSession((session) async {
      await _remoteDataSource.ackRinging(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
    });
  }

  @override
  Future<ApiResult<void>> answerCall(String callId) {
    return _executeWithAuthAndSession((session) async {
      await _remoteDataSource.answerCall(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
    });
  }

  @override
  Future<ApiResult<void>> rejectCall(String callId) {
    return _executeWithAuthAndSession((session) async {
      await _remoteDataSource.rejectCall(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
    });
  }

  @override
  Future<ApiResult<void>> endCall(String callId) {
    return _executeWithAuthAndSession((session) async {
      await _remoteDataSource.endCall(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
    });
  }

  @override
  Future<ApiResult<VoiceIceServersConfigEntity>> getIceServers(String callId) {
    return _executeWithAuthAndSession((session) async {
      final dto = await _remoteDataSource.getIceServers(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
      return VoiceCallMapper.toIceServersConfigEntity(dto);
    });
  }

  @override
  Future<ApiResult<void>> reportConnecting(
    String callId, {
    VoiceMediaReportRequestDto? report,
  }) {
    return _executeWithAuthAndSession((session) async {
      await _remoteDataSource.reportConnecting(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
        report: report,
      );
    });
  }

  @override
  Future<ApiResult<void>> reportConnected(
    String callId, {
    VoiceMediaReportRequestDto? report,
  }) {
    return _executeWithAuthAndSession((session) async {
      await _remoteDataSource.reportConnected(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
        report: report,
      );
    });
  }

  @override
  Future<ApiResult<void>> sendHeartbeat(String callId) {
    return _executeWithAuthAndSession((session) async {
      await _remoteDataSource.sendHeartbeat(
        callId,
        session: session.deviceSessionId,
        proof: session.controlProof,
      );
    });
  }

  @override
  Future<ApiResult<VoiceCallDisplayEntity>> getCallDisplay(
    String callId, {
    String? language,
  }) {
    return safeApiCall(() async {
      final dto = await _remoteDataSource.getCallDisplay(
        callId,
        language: language,
      );
      return VoiceCallMapper.toDisplayEntity(dto);
    });
  }
}
