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
  int rejectCount = 0;
  int endCount = 0;
  int connectingReportCount = 0;
  int connectedReportCount = 0;
  int detailsCount = 0;
  int iceServersCount = 0;

  ApiResult<void> rejectResult = const ApiSuccessResult<void>(data: null);
  ApiResult<void> endResult = const ApiSuccessResult<void>(data: null);
  ApiResult<void> connectingReportResult = const ApiSuccessResult<void>(data: null);
  ApiResult<void> connectedReportResult = const ApiSuccessResult<void>(data: null);
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
  }) async =>
      ApiSuccessResult<VoiceDeviceSessionEntity>(
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
  Future<ApiResult<VoiceCallSnapshotEntity>> getCallDetails(String callId) async {
    detailsCount++;
    return ApiSuccessResult<VoiceCallSnapshotEntity>(
      data: snapshotToReturn ??
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
  }) async =>
      const ApiSuccessResult<VoiceCallHistoryPageEntity>(
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
  }) async =>
      const ApiSuccessResult<List<VoiceCallEventEntity>>(data: []);

  @override
  Future<ApiResult<void>> ackRinging(String callId) async =>
      const ApiSuccessResult<void>(data: null);

  @override
  Future<ApiResult<void>> answerCall(String callId) async =>
      const ApiSuccessResult<void>(data: null);

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
  Future<ApiResult<VoiceIceServersConfigEntity>> getIceServers(String callId) async {
    iceServersCount++;
    return iceServersResult;
  }

  @override
  Future<ApiResult<void>> reportConnecting(
    String callId, {
    VoiceMediaReportRequestDto? report,
  }) async {
    connectingReportCount++;
    return connectingReportResult;
  }

  @override
  Future<ApiResult<void>> reportConnected(
    String callId, {
    VoiceMediaReportRequestDto? report,
  }) async {
    connectedReportCount++;
    return connectedReportResult;
  }

  @override
  Future<ApiResult<void>> sendHeartbeat(String callId) async =>
      const ApiSuccessResult<void>(data: null);

  @override
  Future<ApiResult<VoiceCallDisplayEntity>> getCallDisplay(
    String callId, {
    String? language,
  }) async =>
      const ApiSuccessResult<VoiceCallDisplayEntity>(
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
  CallEventListener? onCallEvent;
  RtcOfferListener? onRtcOffer;
  RtcAnswerListener? onRtcAnswer;
  RtcIceListener? onRtcIce;
  VoidCallback? onReconnected;
  int bindCount = 0;
  String? lastBoundSessionId;
  String? lastBoundControlProof;

  @override
  Future<void> bindDeviceSession(String deviceSessionId, String controlProof) async {
    bindCount++;
    lastBoundSessionId = deviceSessionId;
    lastBoundControlProof = controlProof;
  }

  @override
  void dispose() {}
}

class FakeWebRtcService extends Fake implements VoiceWebRtcService {
  OnLocalIceCandidateCallback? onLocalIceCandidate;
  OnConnectionStateChangeCallback? onConnectionStateChange;
  int cleanupCount = 0;

  @override
  Future<void> cleanup() async {
    cleanupCount++;
  }
}

class FakeDeviceSessionStorage extends Fake implements VoiceDeviceSessionStorage {
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
    test('buffers early ICE candidates when remote description is not set', () async {
      final service = VoiceWebRtcService();
      expect(service.isRemoteDescriptionSet, isFalse);
      expect(service.bufferedCandidatesCount, equals(0));

      await service.addRemoteIceCandidate(
        candidateStr: 'candidate:1 1 UDP 2122260223 192.168.1.1 5000 typ host',
        sdpMid: '0',
        sdpMLineIndex: 0,
      );

      expect(service.bufferedCandidatesCount, equals(1));

      // Duplicate candidate string should be ignored
      await service.addRemoteIceCandidate(
        candidateStr: 'candidate:1 1 UDP 2122260223 192.168.1.1 5000 typ host',
        sdpMid: '0',
        sdpMLineIndex: 0,
      );

      expect(service.bufferedCandidatesCount, equals(1));

      // Different candidate string should be added
      await service.addRemoteIceCandidate(
        candidateStr: 'candidate:2 1 UDP 2122260223 192.168.1.2 5001 typ host',
        sdpMid: '0',
        sdpMLineIndex: 0,
      );

      expect(service.bufferedCandidatesCount, equals(2));

      await service.cleanup();
      expect(service.bufferedCandidatesCount, equals(0));
      expect(service.isRemoteDescriptionSet, isFalse);
    });
  });

  group('VoiceCallManager Receiver Actions & Transactional State', () {
    test('handleReceiverHangup routes Ringing to rejectCall and awaits result', () async {
      // Simulate incoming ringing event
      final envelope = {
        'callId': 'call-101',
        'sequence': 1,
        'payload': {
          'status': 'Ringing',
          'deadlineAtUtc': DateTime.now().toUtc().add(const Duration(seconds: 30)).toIso8601String(),
        },
      };

      manager.handleSignalRCallEventForTesting(envelope);
      await pumpEventQueue();

      expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.ringing));

      // Hangup while ringing
      final result = await manager.handleReceiverHangup('call-101');

      expect(result.isSuccess, isTrue);
      expect(repo.rejectCount, equals(1));
      expect(repo.endCount, equals(0));
      expect(callKit.endedCalls.contains('call-101'), isTrue);
    });

    test('handleReceiverHangup routes Active to endCall and awaits result', () async {
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
    });

    test('handleReceiverHangup performs idempotent local cleanup on terminal call', () async {
      // Simulate ended call event
      final envelope = {
        'callId': 'call-103',
        'sequence': 9,
        'payload': {
          'status': 'Ended',
        },
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
    });

    test('reconciles authoritative snapshot on 409 conflict during reject', () async {
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
          'deadlineAtUtc': DateTime.now().toUtc().add(const Duration(seconds: 30)).toIso8601String(),
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
    });
  });

  group('VoiceCallManager Event Deduplication and Sequence Filtering', () {
    test('discards duplicate event IDs', () async {
      final envelope = {
        'eventId': 'event-uuid-1',
        'callId': 'call-201',
        'sequence': 1,
        'payload': {
          'status': 'Ringing',
          'deadlineAtUtc': DateTime.now().toUtc().add(const Duration(seconds: 30)).toIso8601String(),
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
        'payload': {
          'status': 'Connecting',
        },
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
        'payload': {
          'status': 'Connecting',
        },
      };

      manager.handleSignalRCallEventForTesting(envelopeConnecting);
      await pumpEventQueue();

      expect(manager.currentSnapshot?.status, equals(VoiceCallStatus.connecting));
      expect(manager.currentDurationSeconds, equals(0));
    });

    test('timer starts only on authoritative Active snapshot with connectedAtUtc', () async {
      final nowUtc = DateTime.now().toUtc();
      final envelopeActive = {
        'eventId': 'ev-active',
        'callId': 'call-302',
        'sequence': 4,
        'payload': {
          'status': 'Active',
          'connectedAtUtc': nowUtc.subtract(const Duration(seconds: 5)).toIso8601String(),
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
        'payload': {
          'status': 'Ended',
        },
      };

      manager.handleSignalRCallEventForTesting(envelopeEnded);
      await pumpEventQueue();

      expect(manager.currentSnapshot, isNull);
      expect(manager.currentDurationSeconds, equals(0));
    });
  });

  group('VoiceCallManager Ring Deadline Expiration', () {
    test('expired deadline immediately dismisses UI and reconciles call without synthesizing Missed receipt', () async {
      repo.snapshotToReturn = const VoiceCallSnapshotEntity(
        callId: 'call-401',
        tripStopId: 'trip-1',
        protocolVersion: 2,
        sequence: 12,
        status: VoiceCallStatus.missed,
      );

      final pastDeadline = DateTime.now().toUtc().subtract(const Duration(seconds: 5));
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
    });
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
    test('deduplicates connecting and connected media reports per callId:generation', () async {
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
    });

    test('rebinds device session on SignalR reconnected', () async {
      await manager.initialize();
      await pumpEventQueue();

      manager.handleSignalRReconnectedForTesting();
      await pumpEventQueue();

      expect(signalR.bindCount, greaterThanOrEqualTo(1));
      expect(signalR.lastBoundSessionId, equals('dev-sess-1'));
      expect(signalR.lastBoundControlProof, equals('ctrl-proof-1'));
    });

    test('answerCall aborts media setup when getVoiceIceServers fails', () async {
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
          'deadlineAtUtc': DateTime.now().toUtc().add(const Duration(seconds: 30)).toIso8601String(),
        },
      };

      manager.handleSignalRCallEventForTesting(envelope);
      await pumpEventQueue();

      final success = await manager.answerCall('call-701');

      expect(success, isFalse);
      expect(repo.connectingReportCount, equals(0));
      expect(navigator.pushedRoutes.contains(AppRoutes.activeCall), isFalse);
    });
  });
}
