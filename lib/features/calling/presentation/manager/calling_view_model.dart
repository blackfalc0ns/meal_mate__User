import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../../domain/entities/call_driver_entity.dart';
import '../../domain/entities/voice_call_display_entity.dart';
import '../../domain/entities/voice_call_snapshot_entity.dart';
import '../../domain/entities/voice_call_status.dart';
import '../../service/voice_call_manager.dart';
import '../../service/voice_webrtc_service.dart';
import 'calling_event.dart';
import 'calling_state.dart';

@injectable
class CallingViewModel extends Cubit<CallingState> {
  CallingViewModel(
    VoiceCallManager voiceCallManager,
    VoiceWebRtcService webrtcService,
  ) : _voiceCallManager = voiceCallManager,
      _webrtcService = webrtcService,
      super(const CallingState()) {
    _initSubscriptions();
  }

  CallingViewModel.preview({
    CallDriverEntity? driver,
    VoiceCallDisplayEntity? display,
  }) : _voiceCallManager = null,
       _webrtcService = null,
       super(CallingState(driver: driver, display: display));

  final VoiceCallManager? _voiceCallManager;
  final VoiceWebRtcService? _webrtcService;

  StreamSubscription<VoiceCallSnapshotEntity?>? _snapshotSubscription;
  StreamSubscription<VoiceCallDisplayEntity?>? _displaySubscription;
  StreamSubscription<int>? _durationSubscription;

  void _initSubscriptions() {
    final manager = _voiceCallManager;
    if (manager == null) return;

    final current = manager.currentSnapshot;
    if (current != null) {
      emit(state.copyWith(snapshot: () => current, status: current.status));
    }

    final currentDisplay = manager.currentDisplay;
    if (currentDisplay != null) {
      emit(state.copyWith(display: () => currentDisplay));
    }

    _snapshotSubscription = manager.onSnapshotChanged.listen((snapshot) {
      if (snapshot == null) {
        emit(
          state.copyWith(
            snapshot: () => null,
            display: () => null,
            status: VoiceCallStatus.ended,
            durationSeconds: 0,
            hasAudioPermissionError: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            snapshot: () => snapshot,
            status: snapshot.status,
            hasAudioPermissionError:
                _webrtcService?.hasAudioPermissionError ?? false,
          ),
        );
      }
    });

    _displaySubscription = manager.onDisplayChanged.listen((display) {
      emit(state.copyWith(display: () => display));
    });

    _durationSubscription = manager.onDurationChanged.listen((seconds) {
      emit(
        state.copyWith(
          durationSeconds: seconds,
          isMuted: _webrtcService?.isMuted ?? state.isMuted,
          isSpeakerOn: _webrtcService?.isSpeakerOn ?? state.isSpeakerOn,
          hasAudioPermissionError:
              _webrtcService?.hasAudioPermissionError ?? false,
        ),
      );
    });
  }

  Future<void> retryMicrophonePermission() async {
    final success = await _webrtcService?.retryAcquiringLocalAudio() ?? false;
    if (success) {
      emit(state.copyWith(hasAudioPermissionError: false));
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
        final callId = event.callId ?? state.snapshot?.callId;
        if (callId != null) {
          unawaited(answerCall(callId));
        } else if (_voiceCallManager == null) {
          unawaited(answerCall('preview'));
        }
      case RejectCallEvent():
        final callId = event.callId ?? state.snapshot?.callId;
        if (callId != null) {
          unawaited(rejectCall(callId));
        } else if (_voiceCallManager == null) {
          unawaited(rejectCall('preview'));
        }
      case EndCallEvent():
        final callId = event.callId ?? state.snapshot?.callId;
        if (callId != null) {
          unawaited(endCall(callId));
        } else if (_voiceCallManager == null) {
          unawaited(endCall('preview'));
        }
      case ToggleMuteEvent():
        unawaited(toggleMute());
      case ToggleSpeakerEvent():
        unawaited(toggleSpeaker());
      case SyncActiveCallEvent():
        final snapshot = _voiceCallManager?.currentSnapshot;
        if (snapshot != null) {
          emit(
            state.copyWith(snapshot: () => snapshot, status: snapshot.status),
          );
        }
      case RefreshCallDisplayEvent():
        final callId = event.callId ?? state.snapshot?.callId;
        if (callId != null) {
          unawaited(refreshDisplay(callId, language: event.language));
        }
    }
  }

  Future<void> answerCall(String callId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final manager = _voiceCallManager;
      if (manager != null) {
        final success = await manager.answerCall(callId);
        emit(
          state.copyWith(
            isLoading: false,
            status: success ? VoiceCallStatus.accepted : state.status,
          ),
        );
      } else {
        emit(
          state.copyWith(isLoading: false, status: VoiceCallStatus.accepted),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString));
    }
  }

  Future<void> rejectCall(String callId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final manager = _voiceCallManager;
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
      } else {
        emit(
          state.copyWith(isLoading: false, status: VoiceCallStatus.rejected),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString));
    }
  }

  Future<void> endCall(String callId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final manager = _voiceCallManager;
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
      } else {
        emit(state.copyWith(isLoading: false, status: VoiceCallStatus.ended));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString));
    }
  }

  Future<void> toggleMute() async {
    final manager = _voiceCallManager;
    if (manager != null) {
      await manager.toggleMute();
      emit(state.copyWith(isMuted: _webrtcService?.isMuted ?? !state.isMuted));
    } else {
      emit(state.copyWith(isMuted: !state.isMuted));
    }
  }

  Future<void> toggleSpeaker() async {
    final manager = _voiceCallManager;
    if (manager != null) {
      await manager.toggleSpeaker();
      emit(
        state.copyWith(
          isSpeakerOn: _webrtcService?.isSpeakerOn ?? !state.isSpeakerOn,
        ),
      );
    } else {
      emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
    }
  }

  Future<void> refreshDisplay(String callId, {String? language}) async {
    final manager = _voiceCallManager;
    if (manager != null) {
      await manager.fetchCallDisplay(callId, language: language);
    }
  }

  @override
  Future<void> close() async {
    await _snapshotSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _displaySubscription?.cancel();
    return super.close();
  }
}
