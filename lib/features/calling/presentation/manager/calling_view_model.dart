import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/services/voice_permission_service.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../../domain/entities/call_driver_entity.dart';
import '../../domain/entities/native_call_snapshot_entity.dart';
import '../../domain/entities/voice_call_display_entity.dart';
import '../../domain/entities/voice_call_snapshot_entity.dart';
import '../../domain/entities/voice_call_status.dart';
import '../../domain/repo/native_voice_repository.dart';
import '../../domain/usecase/answer_native_call_usecase.dart';
import '../../domain/usecase/end_native_call_usecase.dart';
import '../../domain/usecase/reject_native_call_usecase.dart';
import '../../domain/usecase/set_native_call_audio_route_usecase.dart';
import '../../domain/usecase/set_native_call_muted_usecase.dart';
import '../../domain/usecase/get_voice_call_display_usecase.dart';
import '../../service/voice_call_manager.dart';
import 'calling_event.dart';
import 'calling_state.dart';

@injectable
class CallingViewModel extends Cubit<CallingState> {
  CallingViewModel(
    this._answerNativeCallUseCase,
    this._rejectNativeCallUseCase,
    this._endNativeCallUseCase,
    this._setNativeCallMutedUseCase,
    this._setNativeCallAudioRouteUseCase,
    this._nativeVoiceRepository, [
    this._getVoiceCallDisplayUseCase,
    VoiceCallManager? voiceCallManager,
  ]) : _voiceCallManager =
           voiceCallManager ??
           (GetIt.instance.isRegistered<VoiceCallManager>()
               ? GetIt.instance<VoiceCallManager>()
               : null),
       super(const CallingState()) {
    _initSubscriptions();
  }

  CallingViewModel.legacy(
    VoiceCallManager voiceCallManager, [
    dynamic webrtcService,
  ]) : _answerNativeCallUseCase = null,
       _rejectNativeCallUseCase = null,
       _endNativeCallUseCase = null,
       _setNativeCallMutedUseCase = null,
       _setNativeCallAudioRouteUseCase = null,
       _nativeVoiceRepository = null,
       _getVoiceCallDisplayUseCase = null,
       _voiceCallManager = voiceCallManager,
       super(const CallingState()) {
    _initSubscriptions();
  }

  CallingViewModel.preview({
    CallDriverEntity? driver,
    VoiceCallDisplayEntity? display,
  }) : _answerNativeCallUseCase = null,
       _rejectNativeCallUseCase = null,
       _endNativeCallUseCase = null,
       _setNativeCallMutedUseCase = null,
       _setNativeCallAudioRouteUseCase = null,
       _nativeVoiceRepository = null,
       _getVoiceCallDisplayUseCase = null,
       _voiceCallManager = null,
       super(CallingState(driver: driver, display: display));

  final AnswerNativeCallUseCase? _answerNativeCallUseCase;
  final RejectNativeCallUseCase? _rejectNativeCallUseCase;
  final EndNativeCallUseCase? _endNativeCallUseCase;
  final SetNativeCallMutedUseCase? _setNativeCallMutedUseCase;
  final SetNativeCallAudioRouteUseCase? _setNativeCallAudioRouteUseCase;
  final NativeVoiceRepository? _nativeVoiceRepository;
  final VoiceCallManager? _voiceCallManager;
  final GetVoiceCallDisplayUseCase? _getVoiceCallDisplayUseCase;

  StreamSubscription<NativeCallSnapshotEntity>? _nativeSnapshotSubscription;
  StreamSubscription<VoiceCallSnapshotEntity?>? _legacySnapshotSubscription;
  StreamSubscription<VoiceCallDisplayEntity?>? _displaySubscription;
  StreamSubscription<int>? _durationSubscription;

  final Random _random = Random();

  String _generateRequestId() {
    return '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(100000)}';
  }

  @override
  void emit(CallingState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void _initSubscriptions() {
    final nativeRepo = _nativeVoiceRepository;
    if (nativeRepo != null) {
      // Reconcile initial native snapshot
      unawaited(_fetchInitialNativeSnapshot());

      _nativeSnapshotSubscription = nativeRepo.snapshotStream.listen(
        _applyNativeSnapshot,
      );
    }

    final manager = _voiceCallManager;
    if (manager != null) {
      final currentDisplay = manager.currentDisplay;
      if (currentDisplay != null) {
        emit(state.copyWith(display: () => currentDisplay));
      }

      _displaySubscription = manager.onDisplayChanged.listen((display) {
        emit(state.copyWith(display: () => display));
      });

      _legacySnapshotSubscription = manager.onSnapshotChanged.listen((
        snapshot,
      ) {
        if (snapshot == null) {
          if (state.nativeSnapshot == null ||
              state.nativeSnapshot?.isTerminal == true) {
            emit(
              state.copyWith(
                snapshot: () => null,
                display: () => null,
                status: VoiceCallStatus.ended,
                durationSeconds: 0,
                hasAudioPermissionError: false,
              ),
            );
          }
        } else {
          final isNativeActive =
              state.nativeSnapshot != null &&
              state.nativeSnapshot!.phase != NativeCallPhase.idle &&
              state.nativeSnapshot!.phase != NativeCallPhase.ended;
          if (!isNativeActive) {
            emit(
              state.copyWith(snapshot: () => snapshot, status: snapshot.status),
            );
          }
        }
      });

      _durationSubscription = manager.onDurationChanged.listen((seconds) {
        final isNativeActive =
            state.nativeSnapshot != null &&
            state.nativeSnapshot!.phase != NativeCallPhase.idle &&
            state.nativeSnapshot!.phase != NativeCallPhase.ended;
        if (!isNativeActive) {
          emit(state.copyWith(durationSeconds: seconds));
        }
      });
    }
  }

  int _nativeUpdates = 0;
  int _displayRequest = 0;

  void _applyNativeSnapshot(NativeCallSnapshotEntity snapshot) {
    final previous = state.nativeSnapshot;
    if (previous != null &&
        previous.engineInstanceId == snapshot.engineInstanceId &&
        snapshot.revision <= previous.revision) {
      return;
    }
    _nativeUpdates++;
    final changedCall = previous?.callId != snapshot.callId;
    emit(
      state.copyWith(
        nativeSnapshot: () => snapshot,
        display: changedCall ? () => null : null,
        status: _mapPhaseToStatus(snapshot.phase),
        durationSeconds: snapshot.elapsedSeconds,
        isMuted: snapshot.isMuted,
        isSpeakerOn: snapshot.audioRouteId == 'speaker',
        hasAudioPermissionError:
            snapshot.phase == NativeCallPhase.permissionRequired,
      ),
    );
  }

  Future<void> _fetchInitialNativeSnapshot() async {
    final nativeRepo = _nativeVoiceRepository;
    if (nativeRepo == null) return;
    final updates = _nativeUpdates;
    final result = await nativeRepo.getSnapshot();
    if (result is ApiSuccessResult<NativeCallSnapshotEntity>) {
      if (updates != _nativeUpdates &&
          result.data.engineInstanceId !=
              state.nativeSnapshot?.engineInstanceId) {
        return;
      }
      _applyNativeSnapshot(result.data);
    }
  }

  Future<void> _runNativeCommand(
    String callId,
    Future<ApiResult<void>> Function(NativeCallSnapshotEntity) command, {
    void Function()? onSuccess,
  }) async {
    try {
      if (state.nativeSnapshot == null) await _fetchInitialNativeSnapshot();
      final snapshot = state.nativeSnapshot;
      if (snapshot == null ||
          snapshot.callId != callId ||
          snapshot.lifecycleId == null ||
          snapshot.isTerminal) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: () => 'No active native call',
          ),
        );
        return;
      }
      final result = await command(snapshot);
      if (state.nativeSnapshot?.lifecycleId != snapshot.lifecycleId) return;
      if (result is ApiSuccessResult<void>) onSuccess?.call();
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: result is ApiErrorResult<void>
              ? () => result.failure.errorMessage
              : () => null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString));
    }
  }

  VoiceCallStatus _mapPhaseToStatus(NativeCallPhase phase) {
    switch (phase) {
      case NativeCallPhase.idle:
        return VoiceCallStatus.unknown;
      case NativeCallPhase.ringing:
      case NativeCallPhase.permissionRequired:
        return VoiceCallStatus.ringing;
      case NativeCallPhase.answering:
        return VoiceCallStatus.accepted;
      case NativeCallPhase.connecting:
        return VoiceCallStatus.connecting;
      case NativeCallPhase.connected:
      case NativeCallPhase.reconnecting:
        return VoiceCallStatus.active;
      case NativeCallPhase.ending:
      case NativeCallPhase.ended:
        return VoiceCallStatus.ended;
      case NativeCallPhase.unknown:
        return VoiceCallStatus.unknown;
    }
  }

  Future<void> retryMicrophonePermission() async {
    final nativeRepo = _nativeVoiceRepository;
    if (nativeRepo != null) {
      final result = await nativeRepo.requestMicrophonePermission();
      if (result is ApiSuccessResult<NativeMicrophonePermission>) {
        if (result.data == NativeMicrophonePermission.granted) {
          emit(state.copyWith(hasAudioPermissionError: false));
        }
      }
    }
  }

  void setDriver(CallDriverEntity? driver) {
    if (driver != null) {
      emit(state.copyWith(driver: () => driver));
    }
  }

  void doIntent(CallingEvent event) {
    switch (event) {
      case AnswerCallEvent():
        final callId =
            event.callId ??
            state.nativeSnapshot?.callId ??
            state.snapshot?.callId ??
            _voiceCallManager?.currentSnapshot?.callId;
        if (callId != null && callId.isNotEmpty) {
          unawaited(answerCall(callId));
        } else if (state.status == VoiceCallStatus.ringing ||
            state.driver != null ||
            state.display != null) {
          unawaited(answerCall('preview'));
        }
      case RejectCallEvent():
        final callId =
            event.callId ??
            state.nativeSnapshot?.callId ??
            state.snapshot?.callId ??
            _voiceCallManager?.currentSnapshot?.callId;
        if (callId != null && callId.isNotEmpty) {
          unawaited(rejectCall(callId));
        } else if (state.status == VoiceCallStatus.ringing ||
            state.driver != null ||
            state.display != null) {
          unawaited(rejectCall('preview'));
        }
      case EndCallEvent():
        final callId =
            event.callId ??
            state.nativeSnapshot?.callId ??
            state.snapshot?.callId ??
            _voiceCallManager?.currentSnapshot?.callId;
        if (callId != null && callId.isNotEmpty) {
          unawaited(endCall(callId));
        } else {
          unawaited(endCall('preview'));
        }
      case ToggleMuteEvent():
        unawaited(toggleMute());
      case ToggleSpeakerEvent():
        unawaited(toggleSpeaker());
      case SyncActiveCallEvent():
        unawaited(_fetchInitialNativeSnapshot());
      case RefreshCallDisplayEvent():
        break;
    }
  }

  Future<void> answerCall(String callId) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (callId == 'preview') {
        if (state.status == VoiceCallStatus.unknown &&
            state.driver == null &&
            state.display == null) {
          emit(state.copyWith(isLoading: false));
          return;
        }
        emit(
          state.copyWith(isLoading: false, status: VoiceCallStatus.accepted),
        );
        return;
      }

      // Check / request microphone permission
      if (GetIt.instance.isRegistered<VoicePermissionService>()) {
        final permissionService = GetIt.instance<VoicePermissionService>();
        final hasMic = await permissionService.isMicrophoneGranted();
        if (!hasMic) {
          final granted = await permissionService.requestMicrophone();
          if (!granted) {
            emit(
              state.copyWith(
                isLoading: false,
                hasAudioPermissionError: true,
                errorMessage: () => 'Microphone permission required',
              ),
            );
            return;
          }
        }
      }

      final isNativeCall =
          state.nativeSnapshot?.callId == callId &&
          state.nativeSnapshot?.isTerminal != true;

      if (_nativeVoiceRepository != null &&
          _answerNativeCallUseCase != null &&
          isNativeCall) {
        await _runNativeCommand(
          callId,
          (snapshot) => _answerNativeCallUseCase(
            callId: callId,
            lifecycleId: snapshot.lifecycleId!,
            requestId: _generateRequestId(),
          ),
          onSuccess: () {
            emit(
              state.copyWith(
                isLoading: false,
                status: VoiceCallStatus.accepted,
              ),
            );
          },
        );
        return;
      }

      final manager =
          _voiceCallManager ??
          (GetIt.instance.isRegistered<VoiceCallManager>()
              ? GetIt.instance<VoiceCallManager>()
              : null);

      if (manager != null) {
        final success = await manager.answerCall(callId);
        emit(
          state.copyWith(
            isLoading: false,
            status: success ? VoiceCallStatus.accepted : state.status,
          ),
        );
        return;
      }

      if (state.status == VoiceCallStatus.ringing ||
          state.driver != null ||
          state.display != null) {
        emit(
          state.copyWith(isLoading: false, status: VoiceCallStatus.accepted),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString));
    }
  }

  Future<void> rejectCall(String callId) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (callId == 'preview') {
        if (state.status == VoiceCallStatus.unknown &&
            state.driver == null &&
            state.display == null) {
          emit(state.copyWith(isLoading: false));
          return;
        }
        emit(
          state.copyWith(isLoading: false, status: VoiceCallStatus.rejected),
        );
        return;
      }

      final isNativeCall =
          state.nativeSnapshot?.callId == callId &&
          state.nativeSnapshot?.isTerminal != true;

      if (_nativeVoiceRepository != null &&
          _rejectNativeCallUseCase != null &&
          isNativeCall) {
        await _runNativeCommand(
          callId,
          (snapshot) => _rejectNativeCallUseCase(
            callId: callId,
            lifecycleId: snapshot.lifecycleId!,
            requestId: _generateRequestId(),
          ),
          onSuccess: () {
            emit(
              state.copyWith(
                isLoading: false,
                status: VoiceCallStatus.rejected,
              ),
            );
          },
        );
        return;
      }

      final manager =
          _voiceCallManager ??
          (GetIt.instance.isRegistered<VoiceCallManager>()
              ? GetIt.instance<VoiceCallManager>()
              : null);

      if (manager != null) {
        final result = await manager.rejectCall(callId);
        if (result is ApiSuccessResult) {
          emit(
            state.copyWith(isLoading: false, status: VoiceCallStatus.rejected),
          );
        } else if (result is ApiErrorResult) {
          final statusCode = result.failure.exception.statusCode;
          if (statusCode == 409) {
            final currentStatus = manager.currentSnapshot?.status;
            emit(
              state.copyWith(
                isLoading: false,
                status: currentStatus ?? VoiceCallStatus.rejected,
                errorMessage: currentStatus != null && !currentStatus.isTerminal
                    ? () => result.failure.errorMessage
                    : null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: () => result.failure.errorMessage,
              ),
            );
          }
        }
        return;
      }

      if (state.status == VoiceCallStatus.ringing ||
          state.driver != null ||
          state.display != null) {
        emit(
          state.copyWith(isLoading: false, status: VoiceCallStatus.rejected),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString));
    }
  }

  Future<void> endCall(String callId) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (callId == 'preview') {
        emit(state.copyWith(isLoading: false, status: VoiceCallStatus.ended));
        return;
      }

      final isNativeCall = state.nativeSnapshot?.callId == callId;

      if (_nativeVoiceRepository != null &&
          _endNativeCallUseCase != null &&
          isNativeCall) {
        await _runNativeCommand(
          callId,
          (snapshot) => _endNativeCallUseCase(
            callId: callId,
            lifecycleId: snapshot.lifecycleId!,
            requestId: _generateRequestId(),
          ),
          onSuccess: () {
            emit(
              state.copyWith(isLoading: false, status: VoiceCallStatus.ended),
            );
          },
        );
        return;
      }

      final manager =
          _voiceCallManager ??
          (GetIt.instance.isRegistered<VoiceCallManager>()
              ? GetIt.instance<VoiceCallManager>()
              : null);

      if (manager != null) {
        final result = await manager.endCall(callId);
        if (result is ApiSuccessResult) {
          emit(state.copyWith(isLoading: false, status: VoiceCallStatus.ended));
        } else if (result is ApiErrorResult) {
          final statusCode = result.failure.exception.statusCode;
          if (statusCode == 409) {
            final currentStatus = manager.currentSnapshot?.status;
            emit(
              state.copyWith(
                isLoading: false,
                status: currentStatus ?? VoiceCallStatus.ended,
                errorMessage: currentStatus != null && !currentStatus.isTerminal
                    ? () => result.failure.errorMessage
                    : null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: () => result.failure.errorMessage,
              ),
            );
          }
        }
        return;
      }

      if (state.status != VoiceCallStatus.unknown && !state.status.isTerminal) {
        emit(state.copyWith(isLoading: false, status: VoiceCallStatus.ended));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString));
    }
  }

  Future<void> toggleMute() async {
    final nextMuted = !state.isMuted;
    final callId = state.nativeSnapshot?.callId;
    final lifecycleId = state.nativeSnapshot?.lifecycleId;
    if (_nativeVoiceRepository != null) {
      await _runNativeCommand(
        callId ?? '',
        (snapshot) => _setNativeCallMutedUseCase!(
          callId: snapshot.callId!,
          lifecycleId: snapshot.lifecycleId!,
          requestId: _generateRequestId(),
          muted: nextMuted,
        ),
        onSuccess: () => emit(state.copyWith(isMuted: nextMuted)),
      );
      return;
    }

    if (_setNativeCallMutedUseCase != null &&
        callId != null &&
        lifecycleId != null) {
      unawaited(
        _setNativeCallMutedUseCase(
          callId: callId,
          lifecycleId: lifecycleId,
          requestId: _generateRequestId(),
          muted: nextMuted,
        ),
      );
      emit(state.copyWith(isMuted: nextMuted));
    } else if (_voiceCallManager != null) {
      await _voiceCallManager.toggleMute();
      emit(state.copyWith(isMuted: nextMuted));
    } else {
      emit(state.copyWith(isMuted: nextMuted));
    }
  }

  Future<void> toggleSpeaker() async {
    final nextSpeaker = !state.isSpeakerOn;
    final targetRoute = nextSpeaker ? 'speaker' : 'earpiece';
    final callId = state.nativeSnapshot?.callId;
    final lifecycleId = state.nativeSnapshot?.lifecycleId;
    if (_nativeVoiceRepository != null) {
      await _runNativeCommand(
        callId ?? '',
        (snapshot) => _setNativeCallAudioRouteUseCase!(
          callId: snapshot.callId!,
          lifecycleId: snapshot.lifecycleId!,
          requestId: _generateRequestId(),
          routeId: targetRoute,
        ),
        onSuccess: () => emit(state.copyWith(isSpeakerOn: nextSpeaker)),
      );
      return;
    }

    if (_setNativeCallAudioRouteUseCase != null &&
        callId != null &&
        lifecycleId != null) {
      unawaited(
        _setNativeCallAudioRouteUseCase(
          callId: callId,
          lifecycleId: lifecycleId,
          requestId: _generateRequestId(),
          routeId: targetRoute,
        ),
      );
      emit(state.copyWith(isSpeakerOn: nextSpeaker));
    } else if (_voiceCallManager != null) {
      await _voiceCallManager.toggleSpeaker();
      emit(state.copyWith(isSpeakerOn: nextSpeaker));
    } else {
      emit(state.copyWith(isSpeakerOn: nextSpeaker));
    }
  }

  Future<void> refreshDisplay(String callId, {String? language}) async {
    final displayUseCase = _getVoiceCallDisplayUseCase;
    if (displayUseCase != null) {
      final request = ++_displayRequest;
      final result = await displayUseCase(callId, language: language);
      if (request != _displayRequest ||
          state.nativeSnapshot?.callId != callId) {
        return;
      }
      if (result is ApiSuccessResult<VoiceCallDisplayEntity>) {
        emit(state.copyWith(display: () => result.data));
      }
      return;
    }
    final manager = _voiceCallManager;
    if (manager != null) {
      await manager.fetchCallDisplay(callId, language: language);
    }
  }

  @override
  Future<void> close() async {
    await _nativeSnapshotSubscription?.cancel();
    await _legacySnapshotSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _displaySubscription?.cancel();
    return super.close();
  }
}
