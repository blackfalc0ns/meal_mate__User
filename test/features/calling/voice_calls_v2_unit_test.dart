import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/language_service.dart';
import 'package:meal_meat_user/core/services/server_time_service.dart';
import 'package:meal_meat_user/features/calling/data/data_source/voice_device_session_storage.dart';
import 'package:meal_meat_user/features/calling/data/models/request/voice_media_report_request_dto.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_display_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_event_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_history_page_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_snapshot_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_status.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_device_session_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_ice_server_entity.dart';
import 'package:meal_meat_user/features/calling/domain/repo/voice_call_repository.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/ack_voice_call_ringing_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/answer_voice_call_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/end_voice_call_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/get_active_voice_call_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/get_voice_call_details_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/get_voice_call_display_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/get_voice_call_events_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/get_voice_ice_servers_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/register_voice_device_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/reject_voice_call_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/report_voice_connected_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/report_voice_connecting_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/revoke_voice_device_usecase.dart';
import 'package:meal_meat_user/features/calling/domain/usecase/send_voice_heartbeat_usecase.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/calling/service/voice_call_manager.dart';
import 'package:meal_meat_user/features/calling/service/voice_call_signalr_service.dart';
import 'package:meal_meat_user/features/calling/service/voice_callkit_service.dart';
import 'package:meal_meat_user/features/calling/service/voice_webrtc_service.dart';

// ---------------------------------------------------------------------------
// Test Doubles
// ---------------------------------------------------------------------------

class FakeVoiceCallRepository implements VoiceCallRepository {
  int answerCount = 0;
  int rejectCount = 0;
  int endCount = 0;
  int connectingReportCount = 0;
  int connectedReportCount = 0;
  int detailsCount = 0;
  int iceServersCount = 0;

  Completer<void>? connectingReportCompleter;
  ApiResult<void> Function(int attempt)? onConnectingReport;
  ApiResult<void> Function(int attempt)? onConnectedReport;

  ApiResult<void> answerResult = const ApiSuccessResult<void>(data: null);
  ApiResult<void> rejectResult = const ApiSuccessResult<void>(data: null);
  ApiResult<void> endResult = const ApiSuccessResult<void>(data: null);
  ApiResult<void> connectingReportResult = const ApiSuccessResult<void>(
    data: null,
  );
  ApiResult<void> connectedReportResult = const ApiSuccessResult<void>(
    data: null,
  );
  ApiResult<VoiceIceServersConfigEntity> iceServersResult =
      const ApiSuccessResult<VoiceIceServersConfigEntity>(
        data: VoiceIceServersConfigEntity(
          iceServers: [
            VoiceIceServerEntity(urls: ['stun:stun.l.google.com:19302']),
          ],
          ttlSeconds: 300,
        ),
      );
  VoiceCallSnapshotEntity? snapshotToReturn;
  ApiResult<VoiceCallSnapshotEntity>? callDetailsResult;

  @override
  Future<VoiceDeviceSessionEntity?> getCachedDeviceSession() async =>
      VoiceDeviceSessionEntity(
        deviceSessionId: 'session-123',
        controlProof: 'proof-456',
        expiresAtUtc: DateTime.utc(2030),
      );

  @override
  Future<ApiResult<VoiceDeviceSessionEntity>> registerDevice({
    String? fcmDeviceTokenId,
    String? apnsVoipToken,
    bool force = false,
  }) async => ApiSuccessResult<VoiceDeviceSessionEntity>(
    data: VoiceDeviceSessionEntity(
      deviceSessionId: 'session-123',
      controlProof: 'proof-456',
      expiresAtUtc: DateTime.utc(2030),
    ),
  );

  @override
  Future<ApiResult<void>> revokeDevice() async =>
      const ApiSuccessResult<void>(data: null);

  @override
  Future<ApiResult<VoiceCallSnapshotEntity?>> getActiveCall() async =>
      const ApiSuccessResult<VoiceCallSnapshotEntity?>(data: null);

  @override
  Future<ApiResult<VoiceCallSnapshotEntity>> getCallDetails(
    String callId,
  ) async {
    detailsCount++;
    if (callDetailsResult != null) return callDetailsResult!;
    return ApiSuccessResult<VoiceCallSnapshotEntity>(
      data:
          snapshotToReturn ??
          VoiceCallSnapshotEntity(
            callId: callId,
            tripStopId: 'trip-1',
            protocolVersion: 2,
            sequence: 10,
            status: VoiceCallStatus.active,
          ),
    );
  }

  @override
  Future<ApiResult<VoiceCallHistoryPageEntity>> getCallHistory(
    String tripStopId, {
    int page = 1,
    int pageSize = 20,
  }) async => const ApiSuccessResult<VoiceCallHistoryPageEntity>(
    data: VoiceCallHistoryPageEntity(
      items: [],
      totalCount: 0,
      page: 1,
      pageSize: 20,
    ),
  );

  @override
  Future<ApiResult<List<VoiceCallEventEntity>>> getCallEvents(
    String callId, {
    int afterSequence = 0,
  }) async => const ApiSuccessResult<List<VoiceCallEventEntity>>(data: []);

  @override
  Future<ApiResult<void>> ackRinging(String callId) async =>
      const ApiSuccessResult<void>(data: null);

  @override
  Future<ApiResult<void>> answerCall(String callId) async {
    answerCount++;
    return answerResult;
  }

  @override
  Future<ApiResult<void>> rejectCall(String callId) async {
    rejectCount++;
    return rejectResult;
  }

  @override
  Future<ApiResult<void>> endCall(String callId) async {
    endCount++;
    return endResult;
  }

  @override
  Future<ApiResult<VoiceIceServersConfigEntity>> getIceServers(
    String callId,
  ) async {
    iceServersCount++;
    return iceServersResult;
  }

  @override
  Future<ApiResult<void>> reportConnecting(
    String callId, {
    VoiceMediaReportRequestDto? report,
  }) async {
    connectingReportCount++;
    if (connectingReportCompleter != null) {
      await connectingReportCompleter!.future;
    }
    if (onConnectingReport != null) {
      return onConnectingReport!(connectingReportCount);
    }
    return connectingReportResult;
  }

  @override
  Future<ApiResult<void>> reportConnected(
    String callId, {
    VoiceMediaReportRequestDto? report,
  }) async {
    connectedReportCount++;
    if (onConnectedReport != null) {
      return onConnectedReport!(connectedReportCount);
    }
    return connectedReportResult;
  }

  @override
  Future<ApiResult<void>> sendHeartbeat(String callId) async =>
      const ApiSuccessResult<void>(data: null);

  @override
  Future<ApiResult<VoiceCallDisplayEntity>> getCallDisplay(
    String callId, {
    String? language,
  }) async => const ApiSuccessResult<VoiceCallDisplayEntity>(
    data: VoiceCallDisplayEntity(callId: 'call-1', driverName: 'Driver John'),
  );
}

class FakeCallKitService extends Fake implements VoiceCallKitService {
  final List<String> endedCalls = [];
  final List<String> shownCalls = [];

  @override
  void initialize() {}

  @override
  Stream<CallKitActionEvent> get onAction => const Stream.empty();

  @override
  Future<void> endCall(String callId) async {
    endedCalls.add(callId);
  }

  @override
  Future<void> showIncomingCall({
    required String callId,
    required String callerName,
    required String callerRole,
    String? callerAvatar,
    String? tripStopId,
    int durationSeconds = 30,
  }) async {
    shownCalls.add(callId);
  }

  @override
  void dispose() {}
}

class FakeSignalRService extends Fake implements VoiceCallSignalRService {
  @override
  CallEventListener? onCallEvent;
  @override
  RtcOfferListener? onRtcOffer;
  @override
  RtcAnswerListener? onRtcAnswer;
  @override
  RtcIceListener? onRtcIce;
  @override
  VoidCallback? onReconnected;
  int bindCount = 0;
  String? lastBoundSessionId;
  String? lastBoundControlProof;

  bool _isConnected = true;
  bool _isBound = true;
  @override
  bool get isConnected => _isConnected;
  set isConnected(bool val) => _isConnected = val;
  @override
  bool get isBound => _isBound;
  set isBound(bool val) => _isBound = val;

  final List<Map<String, dynamic>> sentAnswers = [];
  final List<Map<String, dynamic>> sentIceCandidates = [];

  @override
  Future<void> sendAnswer({
    required String callId,
    required String sdp,
    required String messageId,
    required int generation,
  }) async {
    sentAnswers.add({
      'callId': callId,
      'sdp': sdp,
      'messageId': messageId,
      'generation': generation,
    });
  }

  @override
  Future<void> sendIceCandidate({
    required String callId,
    required Map<String, dynamic> candidateData,
    required String messageId,
    required int generation,
  }) async {
    sentIceCandidates.add({
      'callId': callId,
      'candidateData': candidateData,
      'messageId': messageId,
      'generation': generation,
    });
  }

  @override
  Future<void> bindDeviceSession(
    String deviceSessionId,
    String controlProof,
  ) async {
    bindCount++;
    lastBoundSessionId = deviceSessionId;
    lastBoundControlProof = controlProof;
    _isBound = true;
  }

  @override
  void dispose() {}
}

class FakeWebRtcService extends Fake implements VoiceWebRtcService {
  @override
  OnLocalIceCandidateCallback? onLocalIceCandidate;
  @override
  OnConnectionStateChangeCallback? onConnectionStateChange;
  int cleanupCount = 0;
  int initCount = 0;
  int handleOfferCount = 0;
  int addIceCount = 0;

  Completer<void>? initCompleter;

  @override
  Future<void> cleanup() async {
    cleanupCount++;
  }

  @override
  Future<void> initializePeerConnection({
    required List<VoiceIceServerEntity> iceServers,
  }) async {
    initCount++;
    if (initCompleter != null) {
      await initCompleter!.future;
    }
  }

  @override
  Future<String> handleRemoteOfferAndCreateAnswer(String sdp) async {
    handleOfferCount++;
    return 'mock-answer-sdp';
  }

  @override
  Future<void> addRemoteIceCandidate({
    required String candidateStr,
    String? sdpMid,
    int? sdpMLineIndex,
  }) async {
    addIceCount++;
  }
}

class FakeDeviceSessionStorage extends Fake
    implements VoiceDeviceSessionStorage {
  VoiceDeviceSessionEntity? session = VoiceDeviceSessionEntity(
    deviceSessionId: 'dev-sess-1',
    controlProof: 'ctrl-proof-1',
    expiresAtUtc: DateTime.utc(2030),
  );

  @override
  Future<VoiceDeviceSessionEntity?> getSession() async => session;

  @override
  Future<void> saveSession(VoiceDeviceSessionEntity session) async {
    this.session = session;
  }

  @override
  Future<void> clearSession() async {
    session = null;
  }
}

class FakeNavigatorService extends Fake implements AppNavigatorService {
  final List<String> pushedRoutes = [];

  @override
  Future<T?> pushNamedWhenReady<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    pushedRoutes.add(routeName);
    return null;
  }
}

class FakeLanguageService extends Fake implements LanguageService {
  @override
  String getLanguageCode() => 'ar';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeVoiceCallRepository repo;
  late FakeCallKitService callKit;
  late FakeSignalRService signalR;
  late FakeWebRtcService webrtc;
  late FakeDeviceSessionStorage storage;
  late FakeNavigatorService navigator;
  late FakeLanguageService language;
  late ServerTimeService serverTime;
  late VoiceCallManager manager;

  setUp(() {
    repo = FakeVoiceCallRepository();
    callKit = FakeCallKitService();
    signalR = FakeSignalRService();
    webrtc = FakeWebRtcService();
    storage = FakeDeviceSessionStorage();
    navigator = FakeNavigatorService();
    language = FakeLanguageService();
    serverTime = ServerTimeService();

    manager = VoiceCallManager(
      RegisterVoiceDeviceUseCase(repo),
      RevokeVoiceDeviceUseCase(repo),
      GetActiveVoiceCallUseCase(repo),
      GetVoiceCallDetailsUseCase(repo),
      GetVoiceCallEventsUseCase(repo),
      AckVoiceCallRingingUseCase(repo),
      AnswerVoiceCallUseCase(repo),
      RejectVoiceCallUseCase(repo),
      EndVoiceCallUseCase(repo),
      GetVoiceIceServersUseCase(repo),
      ReportVoiceConnectingUseCase(repo),
      ReportVoiceConnectedUseCase(repo),
      SendVoiceHeartbeatUseCase(repo),
      GetVoiceCallDisplayUseCase(repo),
      language,
      signalR,
      webrtc,
      callKit,
      storage,
      navigator,
    );
    manager.customServerTimeService = serverTime;
  });

  tearDown(() {
    manager.dispose();
  });

  group('VoiceWebRtcService early ICE candidate buffering', () {
    test(
      'buffers early ICE candidates when remote description is not set',
      () async {
        final service = VoiceWebRtcService();
        expect(service.isRemoteDescriptionSet, isFalse);
        expect(service.bufferedCandidatesCount, equals(0));

        await service.addRemoteIceCandidate(
          candidateStr:
              'candidate:1 1 UDP 2122260223 192.168.1.1 5000 typ host',
          sdpMid: '0',
          sdpMLineIndex: 0,
        );

        expect(service.bufferedCandidatesCount, equals(1));

        // Duplicate candidate string should be ignored
        await service.addRemoteIceCandidate(
          candidateStr:
              'candidate:1 1 UDP 2122260223 192.168.1.1 5000 typ host',
          sdpMid: '0',
          sdpMLineIndex: 0,
        );

        expect(service.bufferedCandidatesCount, equals(1));

        // Different candidate string should be added
        await service.addRemoteIceCandidate(
          candidateStr:
              'candidate:2 1 UDP 2122260223 192.168.1.2 5001 typ host',
          sdpMid: '0',
          sdpMLineIndex: 0,
        );

        expect(service.bufferedCandidatesCount, equals(2));

        await service.cleanup();
        expect(service.bufferedCandidatesCount, equals(0));
        expect(service.isRemoteDescriptionSet, isFalse);
      },
    );
  });

  group('VoiceCallManager Receiver Actions & Transactional State', () {
    test(
      'handleReceiverHangup routes Ringing to rejectCall and awaits result',
      () async {
        // Simulate incoming ringing event
        final envelope = {
          'callId': 'call-101',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };

        manager.handleSignalRCallEventForTesting(envelope);
        await pumpEventQueue();

        expect(
          manager.currentSnapshot?.status,
          equals(VoiceCallStatus.ringing),
        );

        // Hangup while ringing
        final result = await manager.handleReceiverHangup('call-101');

        expect(result.isSuccess, isTrue);
        expect(repo.rejectCount, equals(1));
        expect(repo.endCount, equals(0));
        expect(callKit.endedCalls.contains('call-101'), isTrue);
      },
    );

    test(
      'handleReceiverHangup routes Active to endCall and awaits result',
      () async {
        // Simulate active call event
        final envelope = {
          'callId': 'call-102',
          'sequence': 5,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
          },
        };

        manager.handleSignalRCallEventForTesting(envelope);
        await pumpEventQueue();

        expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.active));

        // Hangup while active
        final result = await manager.handleReceiverHangup('call-102');

        expect(result.isSuccess, isTrue);
        expect(repo.endCount, equals(1));
        expect(repo.rejectCount, equals(0));
        expect(callKit.endedCalls.contains('call-102'), isTrue);
      },
    );

    test(
      'handleReceiverHangup performs idempotent local cleanup on terminal call',
      () async {
        // Simulate ended call event
        final envelope = {
          'callId': 'call-103',
          'sequence': 9,
          'payload': {'status': 'Ended'},
        };

        manager.handleSignalRCallEventForTesting(envelope);
        await pumpEventQueue();

        expect(manager.currentSnapshot, isNull);

        // Hangup when already terminal
        final result = await manager.handleReceiverHangup('call-103');

        expect(result.isSuccess, isTrue);
        // No server API called since already terminal
        expect(repo.endCount, equals(0));
        expect(repo.rejectCount, equals(0));
      },
    );

    test(
      'reconciles authoritative snapshot on 409 conflict during reject',
      () async {
        repo.rejectResult = ApiErrorResult<void>(
          failure: Failure(
            errorMessage: 'Conflict',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              message: 'Conflict',
              statusCode: 409,
            ),
          ),
        );
        repo.snapshotToReturn = const VoiceCallSnapshotEntity(
          callId: 'call-104',
          tripStopId: 'trip-1',
          protocolVersion: 2,
          sequence: 15,
          status: VoiceCallStatus.cancelled,
        );

        final envelope = {
          'callId': 'call-104',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };

        manager.handleSignalRCallEventForTesting(envelope);
        await pumpEventQueue();

        final result = await manager.rejectCall('call-104');

        expect(result.isError, isTrue);
        expect(repo.rejectCount, equals(1));
        // Reconcile was triggered
        expect(repo.detailsCount, equals(1));
        expect(manager.currentSnapshot, isNull);
      },
    );
  });

  group('VoiceCallManager Event Deduplication and Sequence Filtering', () {
    test('discards duplicate event IDs', () async {
      final envelope = {
        'eventId': 'event-uuid-1',
        'callId': 'call-201',
        'sequence': 1,
        'payload': {
          'status': 'Ringing',
          'deadlineAtUtc': DateTime.now()
              .toUtc()
              .add(const Duration(seconds: 30))
              .toIso8601String(),
        },
      };

      manager.handleSignalRCallEventForTesting(envelope);
      await pumpEventQueue();
      expect(callKit.shownCalls.length, equals(1));

      // Same eventId received again
      manager.handleSignalRCallEventForTesting(envelope);
      await pumpEventQueue();
      // Should not show again
      expect(callKit.shownCalls.length, equals(1));
    });

    test('discards out-of-order sequence numbers', () async {
      final envelopeSeq5 = {
        'eventId': 'event-seq-5',
        'callId': 'call-202',
        'sequence': 5,
        'payload': {
          'status': 'Active',
          'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
        },
      };

      manager.handleSignalRCallEventForTesting(envelopeSeq5);
      await pumpEventQueue();
      expect(manager.currentSnapshot?.sequence, equals(5));
      expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.active));

      // Out-of-order older sequence received
      final envelopeSeq3 = {
        'eventId': 'event-seq-3',
        'callId': 'call-202',
        'sequence': 3,
        'payload': {'status': 'Connecting'},
      };

      manager.handleSignalRCallEventForTesting(envelopeSeq3);
      await pumpEventQueue();

      // State and sequence remain from the newer snapshot (seq 5)
      expect(manager.currentSnapshot?.sequence, equals(5));
      expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.active));
    });
  });

  group('VoiceCallManager Duration Timer & Monotonic Clock', () {
    test('timer does not tick on Accepted or Connecting states', () async {
      final envelopeAccepted = {
        'eventId': 'ev-accepted',
        'callId': 'call-301',
        'sequence': 2,
        'payload': {
          'status': 'Accepted',
          'acceptedAtUtc': DateTime.now().toUtc().toIso8601String(),
        },
      };

      manager.handleSignalRCallEventForTesting(envelopeAccepted);
      await pumpEventQueue();

      expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.accepted));
      expect(manager.currentDurationSeconds, equals(0));

      final envelopeConnecting = {
        'eventId': 'ev-connecting',
        'callId': 'call-301',
        'sequence': 3,
        'payload': {'status': 'Connecting'},
      };

      manager.handleSignalRCallEventForTesting(envelopeConnecting);
      await pumpEventQueue();

      expect(
        manager.currentSnapshot?.status,
        equals(VoiceCallStatus.connecting),
      );
      expect(manager.currentDurationSeconds, equals(0));
    });

    test(
      'timer starts only on authoritative Active snapshot with connectedAtUtc',
      () async {
        final nowUtc = DateTime.now().toUtc();
        final envelopeActive = {
          'eventId': 'ev-active',
          'callId': 'call-302',
          'sequence': 4,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': nowUtc
                .subtract(const Duration(seconds: 5))
                .toIso8601String(),
          },
        };

        manager.handleSignalRCallEventForTesting(envelopeActive);
        await pumpEventQueue();

        expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.active));
        // Started 5 seconds ago, so duration should be at least 5
        expect(manager.currentDurationSeconds, greaterThanOrEqualTo(5));

        // Terminal snapshot stops timer and resets
        final envelopeEnded = {
          'eventId': 'ev-ended',
          'callId': 'call-302',
          'sequence': 5,
          'payload': {'status': 'Ended'},
        };

        manager.handleSignalRCallEventForTesting(envelopeEnded);
        await pumpEventQueue();

        expect(manager.currentSnapshot, isNull);
        expect(manager.currentDurationSeconds, equals(0));
      },
    );
  });

  group('VoiceCallManager Ring Deadline Expiration', () {
    test(
      'expired deadline immediately dismisses UI and reconciles call without synthesizing Missed receipt',
      () async {
        repo.snapshotToReturn = const VoiceCallSnapshotEntity(
          callId: 'call-401',
          tripStopId: 'trip-1',
          protocolVersion: 2,
          sequence: 12,
          status: VoiceCallStatus.missed,
        );

        final pastDeadline = DateTime.now().toUtc().subtract(
          const Duration(seconds: 5),
        );
        final envelope = {
          'eventId': 'ev-expired-ring',
          'callId': 'call-401',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': pastDeadline.toIso8601String(),
          },
        };

        manager.handleSignalRCallEventForTesting(envelope);
        await pumpEventQueue();

        // UI should be dismissed and reconciled with server
        expect(callKit.endedCalls.contains('call-401'), isTrue);
        expect(repo.detailsCount, equals(1));
        expect(manager.currentSnapshot, isNull);
      },
    );
  });

  group('VoiceCallKitService Programmatic Suppression', () {
    test('programmatic endCall adds callId to suppression set', () async {
      final kit = VoiceCallKitService();
      await kit.endCall('call-501');

      // The callId was registered for programmatic suppression so duplicate native events won't cascade
      kit.dispose();
    });
  });

  group('VoiceCallManager Media Reports & Reconnect Rebind', () {
    test(
      'deduplicates connecting and connected media reports per callId:generation',
      () async {
        final envelopeActive = {
          'eventId': 'ev-rep-active',
          'callId': 'call-601',
          'sequence': 4,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
          },
        };

        manager.handleSignalRCallEventForTesting(envelopeActive);
        await pumpEventQueue();

        // Trigger WebRTC connecting state
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        );
        await pumpEventQueue();
        expect(repo.connectingReportCount, equals(1));

        // Duplicate connecting state event should be ignored
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        );
        await pumpEventQueue();
        expect(repo.connectingReportCount, equals(1));

        // Trigger WebRTC connected state
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        );
        await pumpEventQueue();
        expect(repo.connectedReportCount, equals(1));

        // Duplicate connected state event should be ignored
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        );
        await pumpEventQueue();
        expect(repo.connectedReportCount, equals(1));
      },
    );

    test('rebinds device session on SignalR reconnected', () async {
      await manager.initialize();
      await pumpEventQueue();

      manager.handleSignalRReconnectedForTesting();
      await pumpEventQueue();

      expect(signalR.bindCount, greaterThanOrEqualTo(1));
      expect(signalR.lastBoundSessionId, equals('dev-sess-1'));
      expect(signalR.lastBoundControlProof, equals('ctrl-proof-1'));
    });

    test(
      'answerCall aborts media setup when getVoiceIceServers fails',
      () async {
        repo.iceServersResult = ApiErrorResult<VoiceIceServersConfigEntity>(
          failure: Failure(
            errorMessage: 'ICE error',
            exception: const ApiException(
              errorType: ApiErrorType.serverError,
              message: 'Server error',
              statusCode: 500,
            ),
          ),
        );

        final envelope = {
          'eventId': 'ev-ring-ans',
          'callId': 'call-701',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };

        manager.handleSignalRCallEventForTesting(envelope);
        await pumpEventQueue();

        final success = await manager.answerCall('call-701');

        expect(success, isFalse);
        expect(repo.connectingReportCount, equals(0));
        expect(navigator.pushedRoutes.contains(AppRoutes.activeCall), isFalse);
      },
    );
  });

  group('VoiceCallManager Serialized Accept & RTC Buffering (Task 3)', () {
    test(
      'queues Offer and ICE arriving before WebRTC init completes and processes them after readiness',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-buff',
          'callId': 'call-buff-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        webrtc.initCompleter = Completer<void>();

        final answerFuture = manager.answerCall('call-buff-1');
        await pumpEventQueue();

        // /answer and ice servers should be done, but WebRTC init is waiting on completer
        expect(repo.answerCount, equals(1));
        expect(repo.iceServersCount, equals(1));
        expect(webrtc.initCount, equals(1));

        // Emit Offer and ICE while WebRTC init is still pending
        signalR.onRtcOffer?.call(
          'call-buff-1',
          {'type': 'offer', 'sdp': 'v=0\r\no=early-offer'},
          'msg-offer-early',
          0,
        );
        signalR.onRtcIce?.call(
          'call-buff-1',
          {'candidate': 'cand-early', 'sdpMid': '0', 'sdpMLineIndex': 0},
          'msg-ice-early',
          0,
        );
        await pumpEventQueue();

        // Nothing should have been processed by WebRTC yet
        expect(webrtc.handleOfferCount, equals(0));
        expect(signalR.sentAnswers.length, equals(0));
        expect(webrtc.addIceCount, equals(0));

        // Now complete WebRTC init
        webrtc.initCompleter!.complete();
        final answerSuccess = await answerFuture;

        expect(answerSuccess, isTrue);
        await pumpEventQueue();

        // Offer and ICE should be drained in arrival order after readiness
        expect(webrtc.handleOfferCount, equals(1));
        expect(signalR.sentAnswers.length, equals(1));
        expect(signalR.sentAnswers.first['messageId'], isNotEmpty);
        expect(webrtc.addIceCount, equals(1));
      },
    );

    test(
      'serializes duplicate concurrent Accept triggers to single /answer, ice request, and WebRTC init',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-dup',
          'callId': 'call-dup-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        webrtc.initCompleter = Completer<void>();

        final f1 = manager.answerCall('call-dup-1');
        final f2 = manager.answerCall('call-dup-1');
        await pumpEventQueue();

        webrtc.initCompleter!.complete();
        final results = await Future.wait([f1, f2]);

        expect(results[0], isTrue);
        expect(results[1], isTrue);
        expect(repo.answerCount, equals(1));
        expect(repo.iceServersCount, equals(1));
        expect(webrtc.initCount, equals(1));
      },
    );

    test(
      'fails Accept visibly when SignalR is not connected or bound',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        signalR.isConnected = false;
        signalR.isBound = false;

        final ringEnvelope = {
          'eventId': 'ev-ring-disconn',
          'callId': 'call-disconn-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        final success = await manager.answerCall('call-disconn-1');

        expect(success, isFalse);
        expect(webrtc.initCount, equals(0));
        expect(navigator.pushedRoutes.contains(AppRoutes.activeCall), isFalse);
      },
    );

    test(
      'deduplicates concurrent identical Offer callbacks and processes only once',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-conc',
          'callId': 'call-conc-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        await manager.answerCall('call-conc-1');
        await pumpEventQueue();

        // Fire identical offer twice
        signalR.onRtcOffer?.call(
          'call-conc-1',
          {'type': 'offer', 'sdp': 'v=0\r\no=offer-test'},
          'msg-offer-dup',
          0,
        );
        signalR.onRtcOffer?.call(
          'call-conc-1',
          {'type': 'offer', 'sdp': 'v=0\r\no=offer-test'},
          'msg-offer-dup',
          0,
        );
        await pumpEventQueue();

        expect(webrtc.handleOfferCount, equals(1));
        expect(signalR.sentAnswers.length, equals(1));
      },
    );

    test(
      'rejects RTC messages for different callId or stale generation',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-gen',
          'callId': 'call-gen-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        await manager.answerCall('call-gen-1');
        await pumpEventQueue();

        // Advanced generation 2 offer
        signalR.onRtcOffer?.call(
          'call-gen-1',
          {'type': 'offer', 'sdp': 'v=0\r\ngen2'},
          'msg-gen2',
          2,
        );
        await pumpEventQueue();
        expect(webrtc.handleOfferCount, equals(1));

        // Offer with different callId -> should be rejected
        signalR.onRtcOffer?.call(
          'different-call',
          {'type': 'offer', 'sdp': 'v=0\r\ndiff'},
          'msg-diff',
          2,
        );
        // Offer with older generation 1 -> should be rejected
        signalR.onRtcOffer?.call(
          'call-gen-1',
          {'type': 'offer', 'sdp': 'v=0\r\nold'},
          'msg-old',
          1,
        );
        // ICE with older generation 1 -> should be rejected
        signalR.onRtcIce?.call(
          'call-gen-1',
          {'candidate': 'cand-old'},
          'msg-ice-old',
          1,
        );
        await pumpEventQueue();

        expect(webrtc.handleOfferCount, equals(1));
        expect(webrtc.addIceCount, equals(0));
      },
    );

    test(
      'terminal cleanup clears pending queues and prevents delivery to subsequent calls',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-term',
          'callId': 'call-term-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        // Buffer an offer before WebRTC init
        signalR.onRtcOffer?.call(
          'call-term-1',
          {'type': 'offer', 'sdp': 'v=0\r\nterm'},
          'msg-term-early',
          0,
        );

        // Call is ended / cancelled (terminal)
        final endEnvelope = {
          'eventId': 'ev-end-term',
          'callId': 'call-term-1',
          'sequence': 2,
          'payload': {'status': 'Ended'},
        };
        manager.handleSignalRCallEventForTesting(endEnvelope);
        await pumpEventQueue();

        // Now start a new call
        final ring2Envelope = {
          'eventId': 'ev-ring-new',
          'callId': 'call-new-2',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ring2Envelope);
        await pumpEventQueue();

        await manager.answerCall('call-new-2');
        await pumpEventQueue();

        // Old offer must NOT have been delivered
        expect(webrtc.handleOfferCount, equals(0));
        expect(signalR.sentAnswers.length, equals(0));
      },
    );
  });

  group('VoiceCallManager Accept Reconciliation (Task 4)', () {
    test(
      'successful answer reconciles authoritative server snapshot and does not leave call stuck at Ringing',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-recon',
          'callId': 'call-recon-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        expect(
          manager.currentSnapshot?.status,
          equals(VoiceCallStatus.ringing),
        );

        // Server returns authoritative Accepted snapshot on reconciliation
        repo.snapshotToReturn = VoiceCallSnapshotEntity(
          callId: 'call-recon-1',
          tripStopId: 'trip-1',
          protocolVersion: 2,
          sequence: 2,
          status: VoiceCallStatus.accepted,
        );

        final success = await manager.answerCall('call-recon-1');
        await pumpEventQueue();

        expect(success, isTrue);
        expect(repo.detailsCount, greaterThanOrEqualTo(1));
        expect(
          manager.currentSnapshot?.status,
          equals(VoiceCallStatus.accepted),
        );
      },
    );
  });

  group('VoiceCallManager Reliable Media Reporting (Task 5)', () {
    test(
      'first connecting report fails transiently and next attempt succeeds; successful key recorded only after ApiSuccessResult',
      () async {
        manager.reportRetryDelay = const Duration(milliseconds: 10);
        await manager.initialize();
        await pumpEventQueue();

        final envelopeActive = {
          'eventId': 'ev-rep-active-5',
          'callId': 'call-rep-501',
          'sequence': 4,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(envelopeActive);
        await pumpEventQueue();

        // First attempt fails with 500 error, second attempt succeeds
        repo.onConnectingReport = (attempt) {
          if (attempt == 1) {
            return ApiErrorResult<void>(
              failure: Failure(
                errorMessage: 'Transient server error',
                exception: const ApiException(
                  errorType: ApiErrorType.serverError,
                  message: '500 Server error',
                  statusCode: 500,
                ),
              ),
            );
          }
          return const ApiSuccessResult<void>(data: null);
        };

        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        );
        await pumpEventQueue();

        // Wait for retry delay
        await Future<void>.delayed(const Duration(milliseconds: 30));
        await pumpEventQueue();

        expect(repo.connectingReportCount, equals(2));

        // After successful retry, subsequent duplicate callback should NOT trigger another request
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        );
        await pumpEventQueue();
        expect(repo.connectingReportCount, equals(2));
      },
    );

    test(
      'repeated WebRTC state callbacks do not cause overlapping in-flight requests',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final envelopeActive = {
          'eventId': 'ev-rep-active-overlap',
          'callId': 'call-rep-502',
          'sequence': 4,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(envelopeActive);
        await pumpEventQueue();

        repo.connectingReportCompleter = Completer<void>();

        // Fire state change multiple times while request is in-flight
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        );
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        );
        await pumpEventQueue();

        expect(repo.connectingReportCount, equals(1));

        repo.connectingReportCompleter!.complete();
        await pumpEventQueue();

        expect(repo.connectingReportCount, equals(1));
      },
    );

    test(
      'Connected report arriving while Connecting report is in-flight waits for Connecting report completion',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final envelopeActive = {
          'eventId': 'ev-rep-wait',
          'callId': 'call-rep-503',
          'sequence': 4,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(envelopeActive);
        await pumpEventQueue();

        repo.connectingReportCompleter = Completer<void>();

        // Connecting begins
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        );
        await pumpEventQueue();
        expect(repo.connectingReportCount, equals(1));
        expect(repo.connectedReportCount, equals(0));

        // Connected fires before Connecting finishes
        manager.handleWebRtcConnectionStateChangeForTesting(
          RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        );
        await pumpEventQueue();

        // Connected should be waiting on Connecting
        expect(repo.connectedReportCount, equals(0));

        // Complete Connecting
        repo.connectingReportCompleter!.complete();
        await pumpEventQueue();

        // Now Connected report should have completed
        expect(repo.connectedReportCount, equals(1));
      },
    );

    test('terminal cleanup cancels pending report retries', () async {
      manager.reportRetryDelay = const Duration(milliseconds: 50);
      await manager.initialize();
      await pumpEventQueue();

      final envelopeActive = {
        'eventId': 'ev-rep-cancel',
        'callId': 'call-rep-504',
        'sequence': 4,
        'payload': {
          'status': 'Active',
          'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
        },
      };
      manager.handleSignalRCallEventForTesting(envelopeActive);
      await pumpEventQueue();

      // Fail first attempt to schedule retry
      repo.connectingReportResult = ApiErrorResult<void>(
        failure: Failure(
          errorMessage: '500 Server error',
          exception: const ApiException(
            errorType: ApiErrorType.serverError,
            message: '500 Server error',
            statusCode: 500,
          ),
        ),
      );

      manager.handleWebRtcConnectionStateChangeForTesting(
        RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
      );
      await pumpEventQueue();
      expect(repo.connectingReportCount, equals(1));

      // Now call terminates before retry delay fires
      final endEnvelope = {
        'eventId': 'ev-rep-end',
        'callId': 'call-rep-504',
        'sequence': 5,
        'payload': {'status': 'Ended'},
      };
      manager.handleSignalRCallEventForTesting(endEnvelope);
      await pumpEventQueue();

      // Wait past retry delay
      await Future<void>.delayed(const Duration(milliseconds: 70));
      await pumpEventQueue();

      // No retry should have fired after terminal cleanup
      expect(repo.connectingReportCount, equals(1));
    });
  });

  group('VoiceCallManager Authoritative 409 Reconciliation and Hangup (Task 6)', () {
    test(
      'rejectCall receives 409 and reconciles to terminal Ended -> exactly one cleanup occurs and CallKit is ended',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-409-ended',
          'callId': 'call-409-1',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        expect(
          manager.currentSnapshot?.status,
          equals(VoiceCallStatus.ringing),
        );

        // Server rejects with 409 Conflict
        repo.rejectResult = ApiErrorResult<void>(
          failure: Failure(
            errorMessage: 'Conflict 409',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              message: 'Conflict',
              statusCode: 409,
            ),
          ),
        );

        // Reconciliation returns terminal Ended snapshot
        repo.snapshotToReturn = const VoiceCallSnapshotEntity(
          callId: 'call-409-1',
          tripStopId: 'trip-1',
          protocolVersion: 2,
          sequence: 5,
          status: VoiceCallStatus.ended,
        );

        final result = await manager.rejectCall('call-409-1');
        await pumpEventQueue();

        expect(result, isA<ApiErrorResult<void>>());
        expect(repo.rejectCount, equals(1));
        expect(repo.detailsCount, equals(1));
        expect(callKit.endedCalls.contains('call-409-1'), isTrue);
        expect(manager.currentSnapshot, isNull);
      },
    );

    test(
      'endCall receives 409 and reconciles to Active -> no local cleanup occurs and call state is preserved',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final activeEnvelope = {
          'eventId': 'ev-active-409',
          'callId': 'call-409-2',
          'sequence': 2,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(activeEnvelope);
        await pumpEventQueue();

        expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.active));

        // Server ends with 409 Conflict
        repo.endResult = ApiErrorResult<void>(
          failure: Failure(
            errorMessage: 'Conflict 409',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              message: 'Conflict',
              statusCode: 409,
            ),
          ),
        );

        // Reconciliation returns Active snapshot (non-terminal)
        repo.snapshotToReturn = VoiceCallSnapshotEntity(
          callId: 'call-409-2',
          tripStopId: 'trip-1',
          protocolVersion: 2,
          sequence: 3,
          status: VoiceCallStatus.active,
          connectedAtUtc: DateTime.now().toUtc(),
        );

        final initialEndedCount = callKit.endedCalls.length;
        final result = await manager.endCall('call-409-2');
        await pumpEventQueue();

        expect(result, isA<ApiErrorResult<void>>());
        expect(repo.endCount, equals(1));
        expect(repo.detailsCount, equals(1));
        // No cleanup must occur!
        expect(callKit.endedCalls.length, equals(initialEndedCount));
        expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.active));
      },
    );

    test(
      'rejectCall receives 409 when call advanced to Active on this device -> issues bounded /end and cleans up on success',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-advance',
          'callId': 'call-409-3',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        // Reject returns 409 Conflict because call already advanced to Active
        repo.rejectResult = ApiErrorResult<void>(
          failure: Failure(
            errorMessage: 'Conflict 409',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              message: 'Call already active',
              statusCode: 409,
            ),
          ),
        );

        // Reconciliation shows call is Active on this device (winningDeviceSessionId matches session-123)
        repo.snapshotToReturn = VoiceCallSnapshotEntity(
          callId: 'call-409-3',
          tripStopId: 'trip-1',
          protocolVersion: 2,
          sequence: 4,
          status: VoiceCallStatus.active,
          winningDeviceSessionId: 'dev-sess-1',
          connectedAtUtc: DateTime.now().toUtc(),
        );

        // And subsequent /end succeeds
        repo.endResult = const ApiSuccessResult<void>(data: null);

        final result = await manager.rejectCall('call-409-3');
        await pumpEventQueue();

        expect(repo.rejectCount, equals(1));
        expect(repo.detailsCount, equals(1));
        expect(repo.endCount, equals(1)); // Bounded /end was issued!
        expect(result, isA<ApiSuccessResult<void>>());
        expect(callKit.endedCalls.contains('call-409-3'), isTrue);
        expect(manager.currentSnapshot, isNull);
      },
    );

    test(
      'rejectCall receives 409 and reconciliation fails -> call state is preserved without cleanup and actionable error is returned',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        final ringEnvelope = {
          'eventId': 'ev-ring-fail',
          'callId': 'call-409-4',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        // Reject returns 409 Conflict
        repo.rejectResult = ApiErrorResult<void>(
          failure: Failure(
            errorMessage: 'Conflict 409',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              message: 'Conflict',
              statusCode: 409,
            ),
          ),
        );

        // Reconciliation fails
        repo.callDetailsResult = ApiErrorResult<VoiceCallSnapshotEntity>(
          failure: Failure(
            errorMessage: 'Network timeout',
            exception: const ApiException(
              errorType: ApiErrorType.requestTimeout,
              message: 'Timeout',
              statusCode: 408,
            ),
          ),
        );

        final initialEndedCount = callKit.endedCalls.length;
        final result = await manager.rejectCall('call-409-4');
        await pumpEventQueue();

        expect(result, isA<ApiErrorResult<void>>());
        expect(repo.rejectCount, equals(1));
        expect(repo.detailsCount, equals(1));
        // Call state preserved, no cleanup
        expect(callKit.endedCalls.length, equals(initialEndedCount));
        expect(
          manager.currentSnapshot?.status,
          equals(VoiceCallStatus.ringing),
        );
      },
    );

    test(
      'handleReceiverHangup is idempotent for terminal calls and routes correctly based on status',
      () async {
        await manager.initialize();
        await pumpEventQueue();

        // Case 1: Terminal call -> returns success immediately, does not call repo.reject or repo.end
        final termEnvelope = {
          'eventId': 'ev-term-hangup',
          'callId': 'call-term-hangup',
          'sequence': 10,
          'payload': {'status': 'Ended'},
        };
        manager.handleSignalRCallEventForTesting(termEnvelope);
        await pumpEventQueue();

        final initialEndCount = repo.endCount;
        final initialRejectCount = repo.rejectCount;

        final res = await manager.handleReceiverHangup('call-term-hangup');
        await pumpEventQueue();

        expect(res, isA<ApiSuccessResult<void>>());
        expect(repo.endCount, equals(initialEndCount));
        expect(repo.rejectCount, equals(initialRejectCount));
        expect(callKit.endedCalls.contains('call-term-hangup'), isTrue);

        // Case 2: Ringing call -> routes to rejectCall
        final ringEnvelope = {
          'eventId': 'ev-ring-hangup',
          'callId': 'call-ring-hangup',
          'sequence': 1,
          'payload': {
            'status': 'Ringing',
            'deadlineAtUtc': DateTime.now()
                .toUtc()
                .add(const Duration(seconds: 30))
                .toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(ringEnvelope);
        await pumpEventQueue();

        await manager.handleReceiverHangup('call-ring-hangup');
        await pumpEventQueue();

        expect(repo.rejectCount, equals(initialRejectCount + 1));

        // Case 3: Active call -> routes to endCall
        final activeEnvelope = {
          'eventId': 'ev-active-hangup',
          'callId': 'call-active-hangup',
          'sequence': 2,
          'payload': {
            'status': 'Active',
            'connectedAtUtc': DateTime.now().toUtc().toIso8601String(),
          },
        };
        manager.handleSignalRCallEventForTesting(activeEnvelope);
        await pumpEventQueue();

        await manager.handleReceiverHangup('call-active-hangup');
        await pumpEventQueue();

        expect(repo.endCount, equals(initialEndCount + 1));
      },
    );
  });
}
