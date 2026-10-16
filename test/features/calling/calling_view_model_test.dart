import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_display_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_status.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_view_model.dart';
import 'package:meal_meat_user/features/calling/service/voice_call_manager.dart';
import 'package:meal_meat_user/features/calling/service/voice_webrtc_service.dart';

class FakeVoiceCallManagerForVm extends Fake implements VoiceCallManager {
  final _snapshotController =
      StreamController<VoiceCallSnapshotEntity?>.broadcast();
  final _durationController = StreamController<int>.broadcast();

  @override
  Stream<VoiceCallSnapshotEntity?> get onSnapshotChanged =>
      _snapshotController.stream;

  @override
  Stream<VoiceCallDisplayEntity?> get onDisplayChanged => const Stream.empty();

  @override
  Stream<int> get onDurationChanged => _durationController.stream;

  VoiceCallSnapshotEntity? snapshot;
  @override
  VoiceCallSnapshotEntity? get currentSnapshot => snapshot;

  @override
  VoiceCallDisplayEntity? get currentDisplay => null;

  bool answerResult = true;
  ApiResult<void> rejectResult = const ApiSuccessResult<void>(data: null);
  ApiResult<void> endResult = const ApiSuccessResult<void>(data: null);
  bool toggleMuteCalled = false;
  bool toggleSpeakerCalled = false;

  @override
  Future<bool> answerCall(String callId) async => answerResult;

  @override
  Future<ApiResult<void>> rejectCall(String callId) async => rejectResult;

  @override
  Future<ApiResult<void>> endCall(String callId) async => endResult;

  @override
  Future<void> toggleMute() async {
    toggleMuteCalled = true;
  }

  @override
  Future<void> toggleSpeaker() async {
    toggleSpeakerCalled = true;
  }

  void emitSnapshot(VoiceCallSnapshotEntity? snap) {
    snapshot = snap;
    _snapshotController.add(snap);
  }

  void emitDuration(int duration) {
    _durationController.add(duration);
  }

  @override
  void dispose() {
    unawaited(_snapshotController.close());
    unawaited(_durationController.close());
  }
}

class FakeWebRtcServiceForVm extends Fake implements VoiceWebRtcService {
  bool muted = false;
  bool speakerOn = false;

  @override
  bool get isMuted => muted;

  @override
  bool get isSpeakerOn => speakerOn;

  @override
  bool get hasAudioPermissionError => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeVoiceCallManagerForVm fakeManager;
  late FakeWebRtcServiceForVm fakeWebRtc;
  late CallingViewModel viewModel;

  setUp(() {
    fakeManager = FakeVoiceCallManagerForVm();
    fakeWebRtc = FakeWebRtcServiceForVm();
    viewModel = CallingViewModel(fakeManager, fakeWebRtc);
  });

  tearDown(() async {
    await viewModel.close();
    fakeManager.dispose();
  });

  group('CallingViewModel Call Actions', () {
    test('answerCall updates status to accepted on success', () async {
      await viewModel.answerCall('call-1');
      expect(viewModel.state.status, equals(VoiceCallStatus.accepted));
      expect(viewModel.state.isLoading, isFalse);
    });

    test('rejectCall emits rejected on server success', () async {
      await viewModel.rejectCall('call-1');
      expect(viewModel.state.status, equals(VoiceCallStatus.rejected));
      expect(viewModel.state.isLoading, isFalse);
    });

    test(
      'rejectCall reconciles on 409 conflict and preserves honest state',
      () async {
        fakeManager.rejectResult = ApiErrorResult<void>(
          failure: Failure(
            errorMessage: 'Conflict 409',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              message: 'Conflict',
              statusCode: 409,
            ),
          ),
        );
        fakeManager.snapshot = const VoiceCallSnapshotEntity(
          callId: 'call-1',
          tripStopId: 'stop-1',
          protocolVersion: 2,
          sequence: 5,
          status: VoiceCallStatus.active,
        );

        await viewModel.rejectCall('call-1');
        expect(viewModel.state.status, equals(VoiceCallStatus.active));
        expect(viewModel.state.isLoading, isFalse);
      },
    );

    test('rejectCall emits errorMessage on non-409 server error', () async {
      fakeManager.rejectResult = ApiErrorResult<void>(
        failure: Failure(
          errorMessage: 'Server unavailable',
          exception: const ApiException(
            errorType: ApiErrorType.serverError,
            message: 'Server error',
            statusCode: 500,
          ),
        ),
      );

      await viewModel.rejectCall('call-1');
      expect(viewModel.state.errorMessage, equals('Server unavailable'));
      expect(viewModel.state.isLoading, isFalse);
    });

    test('endCall emits ended on server success', () async {
      await viewModel.endCall('call-1');
      expect(viewModel.state.status, equals(VoiceCallStatus.ended));
      expect(viewModel.state.isLoading, isFalse);
    });

    test(
      'endCall reconciles on 409 conflict and preserves honest state',
      () async {
        fakeManager.endResult = ApiErrorResult<void>(
          failure: Failure(
            errorMessage: 'Conflict 409',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              message: 'Conflict',
              statusCode: 409,
            ),
          ),
        );
        fakeManager.snapshot = const VoiceCallSnapshotEntity(
          callId: 'call-1',
          tripStopId: 'stop-1',
          protocolVersion: 2,
          sequence: 8,
          status: VoiceCallStatus.ended,
        );

        await viewModel.endCall('call-1');
        expect(viewModel.state.status, equals(VoiceCallStatus.ended));
        expect(viewModel.state.isLoading, isFalse);
      },
    );

    test('endCall emits errorMessage on non-409 server error', () async {
      fakeManager.endResult = ApiErrorResult<void>(
        failure: Failure(
          errorMessage: 'Network timeout',
          exception: const ApiException(
            errorType: ApiErrorType.requestTimeout,
            message: 'Timeout',
            statusCode: 408,
          ),
        ),
      );

      await viewModel.endCall('call-1');
      expect(viewModel.state.errorMessage, equals('Network timeout'));
      expect(viewModel.state.isLoading, isFalse);
    });

    test('toggleMute calls manager and updates state', () async {
      fakeWebRtc.muted = true;
      await viewModel.toggleMute();
      expect(fakeManager.toggleMuteCalled, isTrue);
      expect(viewModel.state.isMuted, isTrue);
    });

    test('toggleSpeaker calls manager and updates state', () async {
      fakeWebRtc.speakerOn = true;
      await viewModel.toggleSpeaker();
      expect(fakeManager.toggleSpeakerCalled, isTrue);
      expect(viewModel.state.isSpeakerOn, isTrue);
    });

    test('subscribes to duration stream from manager', () async {
      fakeManager.emitDuration(42);
      await pumpEventQueue();
      expect(viewModel.state.durationSeconds, equals(42));
      expect(viewModel.state.formattedDuration, equals('00:42'));
    });
  });
}
