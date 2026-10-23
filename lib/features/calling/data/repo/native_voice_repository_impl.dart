import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/native_call_snapshot_entity.dart';
import '../../domain/repo/native_voice_repository.dart';
import '../data_source/native_voice_data_source.dart';
import '../models/response/native_call_snapshot_dto.dart';
import '../mapper/native_call_snapshot_mapper.dart';

@LazySingleton(as: NativeVoiceRepository)
class NativeVoiceRepositoryImpl implements NativeVoiceRepository {
  final NativeVoiceDataSource _dataSource;

  NativeVoiceRepositoryImpl(this._dataSource);

  String? _lastEngineInstanceId;
  int _lastRevision = -1;
  Stream<NativeCallSnapshotEntity>? _filteredSnapshotStream;

  @override
  Future<ApiResult<NativeCallSnapshotEntity>> getSnapshot() async {
    try {
      final dto = await _dataSource.getSnapshot();
      final entity = dto.toEntity();
      _trackRevision(entity.engineInstanceId, entity.revision);
      return ApiSuccessResult(data: entity);
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.message ?? e.code,
          code: e.code,
        ),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.toString(),
          code: 'snapshot_error',
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> answer({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    try {
      await _dataSource.answer(
        callId: callId,
        lifecycleId: lifecycleId,
        requestId: requestId,
      );
      return const ApiSuccessResult(data: null);
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.message ?? e.code,
          code: e.code,
        ),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.toString(),
          code: 'answer_error',
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> reject({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    try {
      await _dataSource.reject(
        callId: callId,
        lifecycleId: lifecycleId,
        requestId: requestId,
      );
      return const ApiSuccessResult(data: null);
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.message ?? e.code,
          code: e.code,
        ),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.toString(),
          code: 'reject_error',
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> end({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    try {
      await _dataSource.end(
        callId: callId,
        lifecycleId: lifecycleId,
        requestId: requestId,
      );
      return const ApiSuccessResult(data: null);
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.message ?? e.code,
          code: e.code,
        ),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.toString(),
          code: 'end_error',
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> setMuted({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  }) async {
    try {
      await _dataSource.setMuted(
        callId: callId,
        lifecycleId: lifecycleId,
        requestId: requestId,
        muted: muted,
      );
      return const ApiSuccessResult(data: null);
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.message ?? e.code,
          code: e.code,
        ),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.toString(),
          code: 'set_muted_error',
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> setAudioRoute({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  }) async {
    try {
      await _dataSource.setAudioRoute(
        callId: callId,
        lifecycleId: lifecycleId,
        requestId: requestId,
        routeId: routeId,
      );
      return const ApiSuccessResult(data: null);
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.message ?? e.code,
          code: e.code,
        ),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: e.toString(),
          code: 'set_audio_route_error',
        ),
      );
    }
  }

  @override
  Future<ApiResult<NativeMicrophonePermission>> getMicrophonePermission() async {
    try {
      final permStr = await _dataSource.getMicrophonePermission();
      return ApiSuccessResult(data: _parsePermission(permStr));
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(errorMessage: e.message ?? e.code, code: e.code),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(errorMessage: e.toString(), code: 'perm_check_error'),
      );
    }
  }

  @override
  Future<ApiResult<NativeMicrophonePermission>> requestMicrophonePermission() async {
    try {
      final permStr = await _dataSource.requestMicrophonePermission();
      return ApiSuccessResult(data: _parsePermission(permStr));
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(errorMessage: e.message ?? e.code, code: e.code),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(errorMessage: e.toString(), code: 'perm_request_error'),
      );
    }
  }

  @override
  Future<ApiResult<bool>> openAppSettings() async {
    try {
      final opened = await _dataSource.openAppSettings();
      return ApiSuccessResult(data: opened);
    } on PlatformException catch (e) {
      return ApiErrorResult(
        failure: Failure(errorMessage: e.message ?? e.code, code: e.code),
      );
    } catch (e) {
      return ApiErrorResult(
        failure: Failure(errorMessage: e.toString(), code: 'open_settings_error'),
      );
    }
  }

  @override
  Future<ApiResult<void>> setPresentationContext({
    required bool appVisible,
    String? localeTag,
    int? uiRevision,
  }) async {
    try {
      await _dataSource.setPresentationContext(
        appVisible: appVisible,
        localeTag: localeTag,
        uiRevision: uiRevision,
      );
      return const ApiSuccessResult(data: null);
    } catch (_) {
      return const ApiSuccessResult(data: null);
    }
  }

  @override
  Stream<NativeCallSnapshotEntity> get snapshotStream {
    _filteredSnapshotStream ??= _dataSource.snapshotStream
        .transform(
          StreamTransformer<NativeCallSnapshotDto, NativeCallSnapshotEntity>.fromHandlers(
            handleData: (dto, sink) {
              try {
                final entity = dto.toEntity();
                if (_shouldEmit(entity.engineInstanceId, entity.revision)) {
                  _trackRevision(entity.engineInstanceId, entity.revision);
                  sink.add(entity);
                }
              } catch (_) {
                // Ignore malformed snapshot packets without crashing stream
              }
            },
          ),
        )
        .asBroadcastStream();
    return _filteredSnapshotStream!;
  }

  bool _shouldEmit(String engineInstanceId, int revision) {
    if (_lastEngineInstanceId == null || _lastEngineInstanceId != engineInstanceId) {
      return true;
    }
    return revision > _lastRevision;
  }

  void _trackRevision(String engineInstanceId, int revision) {
    if (_lastEngineInstanceId != engineInstanceId) {
      _lastEngineInstanceId = engineInstanceId;
      _lastRevision = revision;
    } else if (revision > _lastRevision) {
      _lastRevision = revision;
    }
  }

  NativeMicrophonePermission _parsePermission(String perm) {
    switch (perm.toLowerCase().trim()) {
      case 'granted':
        return NativeMicrophonePermission.granted;
      case 'denied':
        return NativeMicrophonePermission.denied;
      case 'permanentlydenied':
      case 'permanently_denied':
        return NativeMicrophonePermission.permanentlyDenied;
      case 'restricted':
        return NativeMicrophonePermission.restricted;
      default:
        return NativeMicrophonePermission.notDetermined;
    }
  }
}
