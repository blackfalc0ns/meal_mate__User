import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calling/domain/entities/native_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_status.dart';
import 'package:meal_meat_user/features/calling/domain/repo/native_voice_repository.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/answer_native_call_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/end_native_call_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/reject_native_call_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/set_native_call_audio_route_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/set_native_call_muted_usecase.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_event.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_view_model.dart';

class FakeNativeVoiceRepository implements NativeVoiceRepository {
  final StreamController<NativeCallSnapshotEntity> _controller =
      StreamController<NativeCallSnapshotEntity>.broadcast();

  NativeCallSnapshotEntity current = const NativeCallSnapshotEntity(
    schemaVersion: 1,
    engineInstanceId: 'eng_1',
    revision: 1,
    phase: NativeCallPhase.idle,
  );

  String? lastAnswerCallId;
  String? lastRejectCallId;
  String? lastEndCallId;
  bool? lastMuted;
  ApiResult<void> muteResult = const ApiSuccessResult(data: null);
  String? lastAudioRoute;

  void emitSnapshot(NativeCallSnapshotEntity snapshot) {
    current = snapshot;
    _controller.add(snapshot);
  }

  @override
  Future<ApiResult<NativeCallSnapshotEntity>> getSnapshot() async {
    return ApiSuccessResult(data: current);
  }

  @override
  Future<ApiResult<void>> answer({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    lastAnswerCallId = callId;
    return const ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<void>> reject({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    lastRejectCallId = callId;
    return const ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<void>> end({
    required String callId,
    required String lifecycleId,
    required String requestId,
  }) async {
    lastEndCallId = callId;
    return const ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<void>> setMuted({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required bool muted,
  }) async {
    lastMuted = muted;
    return muteResult;
  }

  @override
  Future<ApiResult<void>> setAudioRoute({
    required String callId,
    required String lifecycleId,
    required String requestId,
    required String routeId,
  }) async {
    lastAudioRoute = routeId;
    return const ApiSuccessResult(data: null);
  }

  @override
  Future<ApiResult<NativeMicrophonePermission>>
  getMicrophonePermission() async {
    return const ApiSuccessResult(data: NativeMicrophonePermission.granted);
  }

  @override
  Future<ApiResult<NativeMicrophonePermission>>
  requestMicrophonePermission() async {
    return const ApiSuccessResult(data: NativeMicrophonePermission.granted);
  }

  @override
  Future<ApiResult<bool>> openAppSettings() async {
    return const ApiSuccessResult(data: true);
  }

  @override
  Future<ApiResult<void>> setPresentationContext({
    required bool appVisible,
    String? localeTag,
    int? uiRevision,
  }) async {
    return const ApiSuccessResult(data: null);
  }

  @override
  Stream<NativeCallSnapshotEntity> get snapshotStream => _controller.stream;
}

void main() {
  late FakeNativeVoiceRepository fakeRepo;
  late AnswerNativeCallUseCase answerUseCase;
  late RejectNativeCallUseCase rejectUseCase;
  late EndNativeCallUseCase endUseCase;
  late SetNativeCallMutedUseCase setMutedUseCase;
  late SetNativeCallAudioRouteUseCase setAudioRouteUseCase;
  late CallingViewModel viewModel;

  setUp(() {
    fakeRepo = FakeNativeVoiceRepository();
    answerUseCase = AnswerNativeCallUseCase(fakeRepo);
    rejectUseCase = RejectNativeCallUseCase(fakeRepo);
    endUseCase = EndNativeCallUseCase(fakeRepo);
    setMutedUseCase = SetNativeCallMutedUseCase(fakeRepo);
    setAudioRouteUseCase = SetNativeCallAudioRouteUseCase(fakeRepo);

    viewModel = CallingViewModel(
      answerUseCase,
      rejectUseCase,
      endUseCase,
      setMutedUseCase,
      setAudioRouteUseCase,
      fakeRepo,
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  test(
    'Snapshot stream updates status, elapsedSeconds, isMuted, and speaker',
    () async {
      expect(viewModel.state.status, VoiceCallStatus.unknown);

      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_1',
          revision: 2,
          callId: 'call_101',
          lifecycleId: 'life_101',
          phase: NativeCallPhase.connected,
          elapsedSeconds: 42,
          isMuted: true,
          audioRouteId: 'speaker',
        ),
      );

      await pumpEventQueue();

      expect(viewModel.state.status, VoiceCallStatus.active);
      expect(viewModel.state.durationSeconds, 42);
      expect(viewModel.state.isMuted, true);
      expect(viewModel.state.isSpeakerOn, true);
      expect(viewModel.state.formattedDuration, '00:42');
    },
  );

  test('AnswerCallEvent dispatches AnswerNativeCallUseCase', () async {
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_1',
        revision: 2,
        callId: 'call_202',
        lifecycleId: 'life_202',
        phase: NativeCallPhase.ringing,
      ),
    );
    await pumpEventQueue();

    viewModel.doIntent(const AnswerCallEvent());
    await pumpEventQueue();

    expect(fakeRepo.lastAnswerCallId, 'call_202');
  });

  test('RejectCallEvent dispatches RejectNativeCallUseCase', () async {
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_1',
        revision: 2,
        callId: 'call_303',
        lifecycleId: 'life_303',
        phase: NativeCallPhase.ringing,
      ),
    );
    await pumpEventQueue();

    viewModel.doIntent(const RejectCallEvent());
    await pumpEventQueue();

    expect(fakeRepo.lastRejectCallId, 'call_303');
  });

  test('EndCallEvent dispatches EndNativeCallUseCase', () async {
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_1',
        revision: 3,
        callId: 'call_404',
        lifecycleId: 'life_404',
        phase: NativeCallPhase.connected,
      ),
    );
    await pumpEventQueue();

    viewModel.doIntent(const EndCallEvent());
    await pumpEventQueue();

    expect(fakeRepo.lastEndCallId, 'call_404');
  });

  test('ToggleMuteEvent dispatches SetNativeCallMutedUseCase', () async {
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_1',
        revision: 4,
        callId: 'call_505',
        lifecycleId: 'life_505',
        phase: NativeCallPhase.connected,
        isMuted: false,
      ),
    );
    await pumpEventQueue();

    viewModel.doIntent(const ToggleMuteEvent());
    await pumpEventQueue();

    expect(fakeRepo.lastMuted, true);
    expect(viewModel.state.isMuted, true);
  });

  test(
    'native mute rejection is surfaced without showing a muted microphone',
    () async {
      fakeRepo.emitSnapshot(
        const NativeCallSnapshotEntity(
          schemaVersion: 1,
          engineInstanceId: 'eng_1',
          revision: 5,
          callId: 'call-mute',
          lifecycleId: 'life-mute',
          phase: NativeCallPhase.connected,
        ),
      );
      await pumpEventQueue();
      fakeRepo.muteResult = ApiErrorResult(
        failure: Failure(errorMessage: 'native-denied'),
      );
      await viewModel.toggleMute();
      expect(viewModel.state.isMuted, false);
      expect(viewModel.state.errorMessage, 'native-denied');
    },
  );

  test('an older snapshot cannot revert connected media to ringing', () async {
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_1',
        revision: 10,
        callId: 'call',
        lifecycleId: 'life',
        phase: NativeCallPhase.connected,
      ),
    );
    await pumpEventQueue();
    fakeRepo.emitSnapshot(
      const NativeCallSnapshotEntity(
        schemaVersion: 1,
        engineInstanceId: 'eng_1',
        revision: 2,
        callId: 'call',
        lifecycleId: 'life',
        phase: NativeCallPhase.ringing,
      ),
    );
    await pumpEventQueue();
    expect(viewModel.state.status, VoiceCallStatus.active);
  });

  test(
    'native answer with no live call does not pretend it was accepted',
    () async {
      expect(viewModel.state.status, VoiceCallStatus.unknown);
      viewModel.doIntent(const AnswerCallEvent());
      await pumpEventQueue();

      expect(viewModel.state.status, VoiceCallStatus.unknown);
      expect(fakeRepo.lastAnswerCallId, isNull);
    },
  );

  test(
    'native reject with no live call does not report a fake rejection',
    () async {
      expect(viewModel.state.status, VoiceCallStatus.unknown);
      viewModel.doIntent(const RejectCallEvent());
      await pumpEventQueue();

      expect(viewModel.state.status, VoiceCallStatus.unknown);
    },
  );

  test('native end with no live call does not invent a call', () async {
    expect(viewModel.state.status, VoiceCallStatus.unknown);
    viewModel.doIntent(const EndCallEvent());
    await pumpEventQueue();

    expect(viewModel.state.status, VoiceCallStatus.unknown);
  });
}
