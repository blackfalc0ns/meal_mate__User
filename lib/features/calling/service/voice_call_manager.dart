import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/di.dart';
import '../../../../core/network/api_results.dart';
import '../../../../core/services/app_navigator_service.dart';
import '../../../../core/services/language_service.dart';
import '../../../../core/services/server_time_service.dart';
import '../../../../config/routing/app_routes.dart';
import '../data/data_source/voice_device_session_storage.dart';
import '../data/models/request/voice_media_report_request_dto.dart';
import '../domain/entities/voice_call_display_entity.dart';
import '../domain/entities/voice_call_event_entity.dart';
import '../domain/entities/voice_call_snapshot_entity.dart';
import '../domain/entities/voice_call_status.dart';
import '../domain/entities/voice_device_session_entity.dart';
import '../domain/entities/voice_ice_server_entity.dart';
import '../domain/usecase/ack_voice_call_ringing_usecase.dart';
import '../domain/usecase/answer_voice_call_usecase.dart';
import '../domain/usecase/end_voice_call_usecase.dart';
import '../domain/usecase/get_active_voice_call_usecase.dart';
import '../domain/usecase/get_voice_call_details_usecase.dart';
import '../domain/usecase/get_voice_call_display_usecase.dart';
import '../domain/usecase/get_voice_call_events_usecase.dart';
import '../domain/usecase/get_voice_ice_servers_usecase.dart';
import '../domain/usecase/register_voice_device_usecase.dart';
import '../domain/usecase/reject_voice_call_usecase.dart';
import '../domain/usecase/report_voice_connected_usecase.dart';
import '../domain/usecase/report_voice_connecting_usecase.dart';
import '../domain/usecase/revoke_voice_device_usecase.dart';
import '../domain/usecase/send_voice_heartbeat_usecase.dart';
import 'voice_callkit_service.dart';
import 'voice_call_signalr_service.dart';
import 'voice_webrtc_service.dart';

abstract class _PendingRtcRecord {
  final String callId;
  final String messageId;
  final int generation;

  _PendingRtcRecord({
    required this.callId,
    required this.messageId,
    required this.generation,
  });
}

class _PendingOfferRecord extends _PendingRtcRecord {
  final Map<String, dynamic> offer;

  _PendingOfferRecord({
    required super.callId,
    required super.messageId,
    required super.generation,
    required this.offer,
  });
}

class _PendingIceRecord extends _PendingRtcRecord {
  final Map<String, dynamic> candidateData;

  _PendingIceRecord({
    required super.callId,
    required super.messageId,
    required super.generation,
    required this.candidateData,
  });
}

@lazySingleton
class VoiceCallManager with WidgetsBindingObserver {
  VoiceCallManager(
    this._registerVoiceDeviceUseCase,
    this._revokeVoiceDeviceUseCase,
    this._getActiveVoiceCallUseCase,
    this._getVoiceCallDetailsUseCase,
    this._getVoiceCallEventsUseCase,
    this._ackVoiceCallRingingUseCase,
    this._answerVoiceCallUseCase,
    this._rejectVoiceCallUseCase,
    this._endVoiceCallUseCase,
    this._getVoiceIceServersUseCase,
    this._reportVoiceConnectingUseCase,
    this._reportVoiceConnectedUseCase,
    this._sendVoiceHeartbeatUseCase,
    this._getVoiceCallDisplayUseCase,
    this._languageService,
    this._signalRService,
    this._webrtcService,
    this._callKitService,
    this._sessionStorage,
    this._navigatorService,
  );

  final RegisterVoiceDeviceUseCase _registerVoiceDeviceUseCase;
  final RevokeVoiceDeviceUseCase _revokeVoiceDeviceUseCase;
  final GetActiveVoiceCallUseCase _getActiveVoiceCallUseCase;
  final GetVoiceCallDetailsUseCase _getVoiceCallDetailsUseCase;
  final GetVoiceCallEventsUseCase _getVoiceCallEventsUseCase;
  final AckVoiceCallRingingUseCase _ackVoiceCallRingingUseCase;
  final AnswerVoiceCallUseCase _answerVoiceCallUseCase;
  final RejectVoiceCallUseCase _rejectVoiceCallUseCase;
  final EndVoiceCallUseCase _endVoiceCallUseCase;
  final GetVoiceIceServersUseCase _getVoiceIceServersUseCase;
  final ReportVoiceConnectingUseCase _reportVoiceConnectingUseCase;
  final ReportVoiceConnectedUseCase _reportVoiceConnectedUseCase;
  final SendVoiceHeartbeatUseCase _sendVoiceHeartbeatUseCase;
  final GetVoiceCallDisplayUseCase _getVoiceCallDisplayUseCase;
  final LanguageService _languageService;
  final VoiceCallSignalRService _signalRService;
  final VoiceWebRtcService _webrtcService;
  final VoiceCallKitService _callKitService;
  final VoiceDeviceSessionStorage _sessionStorage;
  final AppNavigatorService _navigatorService;

  @visibleForTesting
  ServerTimeService? customServerTimeService;

  ServerTimeService get _serverTimeService =>
      customServerTimeService ??
      (getIt.isRegistered<ServerTimeService>()
          ? getIt<ServerTimeService>()
          : ServerTimeService());

  static const _uuid = Uuid();

  VoiceCallSnapshotEntity? _currentSnapshot;
  VoiceCallSnapshotEntity? get currentSnapshot => _currentSnapshot;

  VoiceDeviceSessionEntity? _currentDeviceSession;
  VoiceDeviceSessionEntity? get currentDeviceSession => _currentDeviceSession;

  VoiceCallDisplayEntity? _currentDisplay;
  VoiceCallDisplayEntity? get currentDisplay => _currentDisplay;

  String? _currentDisplayLanguage;

  final Set<String> _processedEventIds = {};
  final Set<String> _processingMessageIds = {};
  final Set<String> _processedMessageIds = {};
  int _lastCommittedSequence = 0;
  int _currentGeneration = 0;

  static const int _maxPendingRtcRecords = 50;
  final List<_PendingRtcRecord> _pendingRtcQueue = [];
  final Map<String, Future<bool>> _inFlightAccepts = {};
  bool _isWebRtcReady = false;

  Timer? _heartbeatTimer;
  Timer? _durationTimer;
  Timer? _ringDeadlineTimer;
  final Stopwatch _durationStopwatch = Stopwatch();
  int _baseDurationSeconds = 0;
  int _secondsElapsed = 0;

  final Set<String> _inFlightConnectingKeys = {};
  final Set<String> _successfullyReportedConnectingKeys = {};
  final Set<String> _inFlightConnectedKeys = {};
  final Set<String> _successfullyReportedConnectedKeys = {};
  final Map<String, Future<void>> _inFlightConnectingFutures = {};
  final Map<String, Timer> _pendingReportRetryTimers = {};

  @visibleForTesting
  Duration reportRetryDelay = const Duration(milliseconds: 500);

  final _snapshotController =
      StreamController<VoiceCallSnapshotEntity?>.broadcast();
  Stream<VoiceCallSnapshotEntity?> get onSnapshotChanged =>
      _snapshotController.stream;

  final _displayController =
      StreamController<VoiceCallDisplayEntity?>.broadcast();
  Stream<VoiceCallDisplayEntity?> get onDisplayChanged =>
      _displayController.stream;

  final _durationController = StreamController<int>.broadcast();
  Stream<int> get onDurationChanged => _durationController.stream;
  int get currentDurationSeconds => _secondsElapsed;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    WidgetsBinding.instance.addObserver(this);

    _callKitService.initialize();
    _callKitService.onAction.listen(_handleCallKitAction);

    _signalRService.onCallEvent = _handleSignalRCallEvent;
    _signalRService.onRtcOffer = _handleSignalROffer;
    _signalRService.onRtcIce = _handleSignalRIce;
    _signalRService.onReconnected = _handleSignalRReconnected;

    _webrtcService.onLocalIceCandidate = _handleLocalIceCandidate;
    _webrtcService.onConnectionStateChange = _handleWebRtcConnectionStateChange;

    await ensureDeviceRegistered();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint(
        '[VoiceCallManager] App resumed. Reconciling voice call state...',
      );
      unawaited(_reconcileAfterResume());
    }
  }

  Future<void> _reconcileAfterResume() async {
    final activeResult = await _getActiveVoiceCallUseCase();
    if (activeResult is ApiSuccessResult<VoiceCallSnapshotEntity?>) {
      final active = activeResult.data;
      if (active == null) {
        if (_currentSnapshot != null && !_currentSnapshot!.status.isTerminal) {
          debugPrint(
            '[VoiceCallManager] Resume reconciliation: server reports no active call',
          );
          await _callKitService.endAllCalls();
          await _cleanupCall();
        }
      } else {
        await _applySnapshot(active);
      }
    }
  }

  Future<VoiceDeviceSessionEntity?> ensureDeviceRegistered({
    String? fcmDeviceTokenId,
    String? apnsVoipToken,
    bool force = false,
  }) async {
    final existing = await _sessionStorage.getSession();
    if (!force && existing != null && existing.isValid) {
      _currentDeviceSession = existing;
      unawaited(_connectSignalR());
      return existing;
    }

    final result = await _registerVoiceDeviceUseCase(
      fcmDeviceTokenId: fcmDeviceTokenId,
      apnsVoipToken: apnsVoipToken,
      force: force,
    );

    if (result is ApiSuccessResult<VoiceDeviceSessionEntity>) {
      _currentDeviceSession = result.data;
      unawaited(_connectSignalR());
      return result.data;
    }

    return null;
  }

  Future<void> _connectSignalR() async {
    final session = _currentDeviceSession;
    if (session == null || !session.isValid) return;

    try {
      await _signalRService.connectAndBind(
        deviceSessionId: session.deviceSessionId,
        controlProof: session.controlProof,
      );
    } catch (e) {
      debugPrint('[VoiceCallManager] SignalR connect failed: $e');
    }
  }

  Future<void> handleFcmPushMessage(Map<String, dynamic> data) async {
    final envelopeStr = data['envelope']?.toString();
    if (envelopeStr == null || envelopeStr.isEmpty) {
      final type = data['type']?.toString();
      if (type == 'voice-call' && data.containsKey('callId')) {
        await _reconcileCall(data['callId'].toString());
      }
      return;
    }

    try {
      final decoded = jsonDecode(envelopeStr);
      if (decoded is Map<String, dynamic>) {
        await _processLifecycleEnvelope(decoded);
      }
    } catch (e) {
      debugPrint('[VoiceCallManager] Failed to decode envelope JSON: $e');
    }
  }

  Future<void> _processLifecycleEnvelope(Map<String, dynamic> envelope) async {
    final eventId = envelope['eventId']?.toString() ?? '';
    if (eventId.isNotEmpty && _processedEventIds.contains(eventId)) {
      debugPrint(
        '[VoiceCallManager] Discarding duplicate envelope event: $eventId',
      );
      return;
    }
    if (eventId.isNotEmpty) {
      _processedEventIds.add(eventId);
    }

    final callId = envelope['callId']?.toString() ?? '';
    final envelopeSequence = (envelope['sequence'] as num?)?.toInt() ?? 0;
    final payload = envelope['payload'] is Map
        ? Map<String, dynamic>.from(envelope['payload'] as Map)
        : <String, dynamic>{};

    final payloadSequence =
        (payload['sequence'] as num?)?.toInt() ?? envelopeSequence;
    final authoritativeSequence = payloadSequence >= envelopeSequence
        ? payloadSequence
        : envelopeSequence;

    if (_currentSnapshot != null &&
        _currentSnapshot!.callId == callId &&
        authoritativeSequence < _currentSnapshot!.sequence) {
      debugPrint(
        '[VoiceCallManager] Discarding outdated sequence: $authoritativeSequence < ${_currentSnapshot!.sequence}',
      );
      return;
    }

    _lastCommittedSequence = authoritativeSequence;

    VoiceCallSnapshotEntity? snapshot;
    if (payload.isNotEmpty && payload.containsKey('status')) {
      snapshot = VoiceCallSnapshotEntity(
        callId: callId,
        tripStopId:
            payload['tripStopId']?.toString() ??
            _currentSnapshot?.tripStopId ??
            '',
        protocolVersion: (payload['protocolVersion'] as num?)?.toInt() ?? 2,
        sequence: authoritativeSequence,
        status: VoiceCallStatus.fromString(payload['status']?.toString()),
        endReason: payload['endReason']?.toString(),
        startedAtUtc: DateTime.tryParse(
          payload['startedAtUtc']?.toString() ?? '',
        )?.toUtc(),
        acceptedAtUtc: DateTime.tryParse(
          payload['acceptedAtUtc']?.toString() ?? '',
        )?.toUtc(),
        connectedAtUtc: DateTime.tryParse(
          payload['connectedAtUtc']?.toString() ?? '',
        )?.toUtc(),
        endedAtUtc: DateTime.tryParse(
          payload['endedAtUtc']?.toString() ?? '',
        )?.toUtc(),
        durationSeconds: (payload['durationSeconds'] as num?)?.toInt(),
        deadlineAtUtc: DateTime.tryParse(
          payload['deadlineAtUtc']?.toString() ?? '',
        )?.toUtc(),
        winningDeviceSessionId: payload['winningDeviceSessionId']?.toString(),
        localParticipantRole: payload['localParticipantRole']?.toString(),
      );
    } else {
      final detailsRes = await _getVoiceCallDetailsUseCase(callId);
      if (detailsRes is ApiSuccessResult<VoiceCallSnapshotEntity>) {
        snapshot = detailsRes.data;
      }
    }

    if (snapshot == null) return;
    await _applySnapshot(snapshot);
  }

  Future<void> _applySnapshot(VoiceCallSnapshotEntity snapshot) async {
    debugPrint(
      '[VoiceCallManager] Applying snapshot: callId=${snapshot.callId}, status=${snapshot.status}, seq=${snapshot.sequence}',
    );
    if (_currentSnapshot != null &&
        _currentSnapshot!.callId != snapshot.callId) {
      debugPrint(
        '[VoiceCallManager] Call changed from ${_currentSnapshot!.callId} to ${snapshot.callId}; resetting call buffers',
      );
      _cancelAllReportRetries();
      _inFlightConnectingKeys.clear();
      _successfullyReportedConnectingKeys.clear();
      _inFlightConnectedKeys.clear();
      _successfullyReportedConnectedKeys.clear();
      _inFlightConnectingFutures.clear();
      _pendingRtcQueue.clear();
      _processingMessageIds.clear();
      _processedMessageIds.clear();
      _inFlightAccepts.clear();
      _isWebRtcReady = false;
      _currentGeneration = 0;
    }
    _currentSnapshot = snapshot;
    _snapshotController.add(snapshot);

    if (snapshot.callId.isNotEmpty &&
        (_currentDisplay == null ||
            _currentDisplay?.callId != snapshot.callId)) {
      unawaited(fetchCallDisplay(snapshot.callId));
    }

    final mySessionId = _currentDeviceSession?.deviceSessionId;

    if (snapshot.winningDeviceSessionId != null &&
        snapshot.winningDeviceSessionId != mySessionId) {
      debugPrint(
        '[VoiceCallManager] Call answered on another device. Dismissing UI.',
      );
      _ringDeadlineTimer?.cancel();
      _ringDeadlineTimer = null;
      await _callKitService.endCall(snapshot.callId);
      await _cleanupCall();
      return;
    }

    if (snapshot.status.isTerminal) {
      debugPrint(
        '[VoiceCallManager] Terminal call state: ${snapshot.status} for call ${snapshot.callId}',
      );
      _ringDeadlineTimer?.cancel();
      _ringDeadlineTimer = null;
      await _callKitService.endCall(snapshot.callId);
      await _cleanupCall();
      return;
    }

    if (snapshot.status == VoiceCallStatus.ringing) {
      final nowServer = _serverTimeService.nowUtc;
      final deadline = snapshot.deadlineAtUtc;

      if (deadline != null && !deadline.isAfter(nowServer)) {
        debugPrint(
          '[VoiceCallManager] Call ring deadline already expired at $deadline (nowServer: $nowServer). Dismissing & reconciling.',
        );
        _ringDeadlineTimer?.cancel();
        _ringDeadlineTimer = null;
        await _callKitService.endCall(snapshot.callId);
        await _reconcileCall(snapshot.callId);
        await _cleanupCall();
        return;
      }

      final remaining = deadline != null
          ? deadline.difference(nowServer)
          : const Duration(seconds: 30);
      final durationSec = remaining.inSeconds > 0 ? remaining.inSeconds : 30;

      _ringDeadlineTimer?.cancel();
      _ringDeadlineTimer = Timer(remaining, () async {
        debugPrint(
          '[VoiceCallManager] Ring deadline timer reached for call ${snapshot.callId}. Dismissing UI & reconciling.',
        );
        _ringDeadlineTimer?.cancel();
        _ringDeadlineTimer = null;
        await _callKitService.endCall(snapshot.callId);
        await _reconcileCall(snapshot.callId);
        if (_currentSnapshot?.status == VoiceCallStatus.ringing) {
          await _cleanupCall();
        }
      });

      await _callKitService.showIncomingCall(
        callId: snapshot.callId,
        callerName: 'مندوب التوصيل',
        callerRole: 'مندوب التوصيل',
        tripStopId: snapshot.tripStopId,
        durationSeconds: durationSec,
      );

      // Acknowledge ringing ONLY after native UI starts
      await _ackVoiceCallRingingUseCase(snapshot.callId);

      await _navigatorService.pushNamedWhenReady(AppRoutes.incomingCall);
    } else if (snapshot.status == VoiceCallStatus.accepted ||
        snapshot.status == VoiceCallStatus.connecting ||
        snapshot.status == VoiceCallStatus.active) {
      _ringDeadlineTimer?.cancel();
      _ringDeadlineTimer = null;
      _startHeartbeatTimer(snapshot.callId);
      if (snapshot.status == VoiceCallStatus.active) {
        if (snapshot.connectedAtUtc != null) {
          _startOrUpdateDurationTimer(
            snapshot.connectedAtUtc!,
            snapshot.durationSeconds,
          );
        }
      } else {
        _stopDurationTimer();
      }
    }
  }

  void _handleCallKitAction(CallKitActionEvent event) {
    debugPrint(
      '[VoiceCallManager] CallKit action: ${event.type} for callId: ${event.callId}',
    );
    switch (event.type) {
      case CallKitActionType.accept:
        unawaited(answerCall(event.callId));
      case CallKitActionType.decline:
        unawaited(handleReceiverHangup(event.callId));
      case CallKitActionType.ended:
        unawaited(handleReceiverHangup(event.callId));
      case CallKitActionType.timeout:
        unawaited(_handleRingTimeout(event.callId));
      case CallKitActionType.other:
        break;
    }
  }

  Future<void> _handleRingTimeout(String callId) async {
    debugPrint('[VoiceCallManager] CallKit ring timeout for $callId');
    _ringDeadlineTimer?.cancel();
    _ringDeadlineTimer = null;
    await _reconcileCall(callId);
    if (_currentSnapshot?.status == VoiceCallStatus.ringing) {
      await _cleanupCall();
    }
  }

  Future<ApiResult<void>> handleReceiverHangup(String callId) async {
    final current = _currentSnapshot;
    if (current == null || current.status.isTerminal) {
      debugPrint(
        '[VoiceCallManager] Hangup on terminal or null call; performing idempotent cleanup',
      );
      await _callKitService.endCall(callId);
      await _cleanupCall();
      return const ApiSuccessResult<void>(data: null);
    }

    if (current.status == VoiceCallStatus.ringing) {
      debugPrint(
        '[VoiceCallManager] Hangup while Ringing -> routing to rejectCall',
      );
      return rejectCall(callId);
    } else {
      debugPrint(
        '[VoiceCallManager] Hangup while ${current.status} -> routing to endCall',
      );
      return endCall(callId);
    }
  }

  void _handleSignalRCallEvent(Map<String, dynamic> envelope) {
    unawaited(_processLifecycleEnvelope(envelope));
  }

  @visibleForTesting
  void handleSignalRCallEventForTesting(Map<String, dynamic> envelope) =>
      _handleSignalRCallEvent(envelope);

  void _enqueuePendingRtcRecord(_PendingRtcRecord record) {
    if (_pendingRtcQueue.length >= _maxPendingRtcRecords) {
      final dropped = _pendingRtcQueue.removeAt(0);
      debugPrint(
        '[VoiceCallManager] Dropping oldest pending RTC record (id: ${dropped.messageId}, gen: ${dropped.generation}) due to queue limit',
      );
    }
    _pendingRtcQueue.add(record);
  }

  void _handleSignalROffer(
    String callId,
    Map<String, dynamic> offer,
    String messageId,
    int generation,
  ) async {
    final current = _currentSnapshot;
    if (current == null || callId != current.callId) {
      debugPrint(
        '[VoiceCallManager] Rejecting RTC offer for mismatching call: $callId != ${current?.callId}',
      );
      return;
    }

    if (messageId.isNotEmpty &&
        (_processedMessageIds.contains(messageId) ||
            _processingMessageIds.contains(messageId))) {
      debugPrint(
        '[VoiceCallManager] Discarding duplicate/in-flight RTC offer: $messageId',
      );
      return;
    }

    if (generation < _currentGeneration) {
      debugPrint(
        '[VoiceCallManager] Discarding stale generation offer: $generation < $_currentGeneration',
      );
      return;
    }
    if (generation > _currentGeneration) {
      _currentGeneration = generation;
      _cancelAllReportRetries();
    }

    final sdp = offer['sdp']?.toString() ?? '';
    if (sdp.isEmpty) return;

    if (!_isWebRtcReady) {
      debugPrint(
        '[VoiceCallManager] WebRTC not ready; queueing offer $messageId (gen: $generation)',
      );
      _enqueuePendingRtcRecord(
        _PendingOfferRecord(
          callId: callId,
          messageId: messageId,
          generation: generation,
          offer: offer,
        ),
      );
      return;
    }

    await _processOffer(
      callId: callId,
      offer: offer,
      messageId: messageId,
      generation: generation,
    );
  }

  Future<void> _processOffer({
    required String callId,
    required Map<String, dynamic> offer,
    required String messageId,
    required int generation,
  }) async {
    final sdp = offer['sdp']?.toString() ?? '';
    if (sdp.isEmpty) return;

    if (messageId.isNotEmpty) {
      _processingMessageIds.add(messageId);
    }

    try {
      final answerSdp = await _webrtcService.handleRemoteOfferAndCreateAnswer(
        sdp,
      );
      final answerMessageId = _uuid.v4();

      await _signalRService.sendAnswer(
        callId: callId,
        sdp: answerSdp,
        messageId: answerMessageId,
        generation: _currentGeneration,
      );

      if (messageId.isNotEmpty) {
        _processedMessageIds.add(messageId);
      }
    } catch (e) {
      debugPrint('[VoiceCallManager] Error responding to RTC offer: $e');
    } finally {
      if (messageId.isNotEmpty) {
        _processingMessageIds.remove(messageId);
      }
    }
  }

  void _handleSignalRIce(
    String callId,
    Map<String, dynamic> candidateData,
    String messageId,
    int generation,
  ) async {
    final current = _currentSnapshot;
    if (current == null || callId != current.callId) {
      debugPrint(
        '[VoiceCallManager] Rejecting RTC ice for mismatching call: $callId != ${current?.callId}',
      );
      return;
    }

    if (messageId.isNotEmpty &&
        (_processedMessageIds.contains(messageId) ||
            _processingMessageIds.contains(messageId))) {
      debugPrint(
        '[VoiceCallManager] Discarding duplicate/in-flight RTC ice: $messageId',
      );
      return;
    }

    if (generation < _currentGeneration) {
      debugPrint(
        '[VoiceCallManager] Discarding stale generation ice: $generation < $_currentGeneration',
      );
      return;
    }
    if (generation > _currentGeneration) {
      _currentGeneration = generation;
      _cancelAllReportRetries();
    }

    final candidateStr = candidateData['candidate']?.toString() ?? '';
    if (candidateStr.isEmpty) return;

    if (!_isWebRtcReady) {
      debugPrint(
        '[VoiceCallManager] WebRTC not ready; queueing ICE candidate $messageId (gen: $generation)',
      );
      _enqueuePendingRtcRecord(
        _PendingIceRecord(
          callId: callId,
          messageId: messageId,
          generation: generation,
          candidateData: candidateData,
        ),
      );
      return;
    }

    await _processIce(candidateData: candidateData, messageId: messageId);
  }

  Future<void> _processIce({
    required Map<String, dynamic> candidateData,
    required String messageId,
  }) async {
    final candidateStr = candidateData['candidate']?.toString() ?? '';
    if (candidateStr.isEmpty) return;

    final sdpMid = candidateData['sdpMid']?.toString();
    final sdpMLineIndex = (candidateData['sdpMLineIndex'] as num?)?.toInt();

    if (messageId.isNotEmpty) {
      _processingMessageIds.add(messageId);
    }

    try {
      await _webrtcService.addRemoteIceCandidate(
        candidateStr: candidateStr,
        sdpMid: sdpMid,
        sdpMLineIndex: sdpMLineIndex,
      );
      if (messageId.isNotEmpty) {
        _processedMessageIds.add(messageId);
      }
    } catch (e) {
      debugPrint('[VoiceCallManager] Error adding remote ICE candidate: $e');
    } finally {
      if (messageId.isNotEmpty) {
        _processingMessageIds.remove(messageId);
      }
    }
  }

  Future<void> _drainPendingRtcQueue(String callId) async {
    final pendingForCall = _pendingRtcQueue
        .where((r) => r.callId == callId && r.generation >= _currentGeneration)
        .toList();
    _pendingRtcQueue.removeWhere((r) => r.callId == callId);

    // Drain offers first in arrival order
    final offers = pendingForCall.whereType<_PendingOfferRecord>().toList();
    for (final off in offers) {
      await _processOffer(
        callId: off.callId,
        offer: off.offer,
        messageId: off.messageId,
        generation: off.generation,
      );
    }

    // Drain ICE candidates in arrival order
    final ices = pendingForCall.whereType<_PendingIceRecord>().toList();
    for (final ice in ices) {
      await _processIce(
        candidateData: ice.candidateData,
        messageId: ice.messageId,
      );
    }
  }

  void _handleLocalIceCandidate(RTCIceCandidate candidate) {
    final snapshot = _currentSnapshot;
    if (snapshot == null || snapshot.callId.isEmpty) return;

    final candidateMap = <String, dynamic>{
      'candidate': candidate.candidate,
      if (candidate.sdpMid != null) 'sdpMid': candidate.sdpMid,
      if (candidate.sdpMLineIndex != null)
        'sdpMLineIndex': candidate.sdpMLineIndex,
    };

    unawaited(
      _signalRService.sendIceCandidate(
        callId: snapshot.callId,
        candidateData: candidateMap,
        messageId: _uuid.v4(),
        generation: _currentGeneration,
      ),
    );
  }

  void _handleWebRtcConnectionStateChange(RTCPeerConnectionState state) {
    final snapshot = _currentSnapshot;
    if (snapshot == null) return;
    final callId = snapshot.callId;
    final reportKey = '$callId:$_currentGeneration';

    debugPrint(
      '[VoiceCallManager] WebRTC connectionState changed to $state for call $callId (gen: $_currentGeneration)',
    );

    if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
      if (!_successfullyReportedConnectingKeys.contains(reportKey) &&
          !_inFlightConnectingKeys.contains(reportKey)) {
        unawaited(_sendConnectingReportWithRetry(callId, _currentGeneration));
      }
    } else if (state ==
        RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      if (!_successfullyReportedConnectedKeys.contains(reportKey) &&
          !_inFlightConnectedKeys.contains(reportKey)) {
        unawaited(_sendConnectedReportWithRetry(callId, _currentGeneration));
      }
      _startHeartbeatTimer(callId);
      // NOTE: Duration timer is NOT started here! Only authoritative Active snapshot starts duration timer.
    } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
        state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
      debugPrint('[VoiceCallManager] WebRTC state: $state for call $callId');
    }
  }

  Future<void> _sendConnectingReportWithRetry(
    String callId,
    int generation, [
    int attempt = 1,
  ]) async {
    final reportKey = '$callId:$generation';
    if (_successfullyReportedConnectingKeys.contains(reportKey)) {
      return;
    }
    if (_inFlightConnectingKeys.contains(reportKey)) {
      await _inFlightConnectingFutures[reportKey];
      return;
    }

    final future = _executeSendConnectingReport(callId, generation, attempt);
    _inFlightConnectingFutures[reportKey] = future;
    try {
      await future;
    } finally {
      _inFlightConnectingFutures.remove(reportKey);
    }
  }

  Future<void> _executeSendConnectingReport(
    String callId,
    int generation,
    int attempt,
  ) async {
    final reportKey = '$callId:$generation';
    if (_currentSnapshot == null ||
        _currentSnapshot!.callId != callId ||
        _currentGeneration != generation ||
        _currentSnapshot!.status.isTerminal) {
      return;
    }

    _inFlightConnectingKeys.add(reportKey);
    try {
      debugPrint(
        '[VoiceCallManager] Sending /reports/connecting for call $callId (gen: $generation, attempt: $attempt)',
      );
      final result = await _reportVoiceConnectingUseCase(
        callId,
        report: VoiceMediaReportRequestDto(
          callId: callId,
          timestampUtc: _serverTimeService.nowUtc.toIso8601String(),
        ),
      );

      if (result is ApiSuccessResult) {
        _successfullyReportedConnectingKeys.add(reportKey);
        debugPrint(
          '[VoiceCallManager] /reports/connecting succeeded for $callId (gen: $generation)',
        );
      } else if (result is ApiErrorResult) {
        final statusCode = result.failure.exception.statusCode;
        debugPrint(
          '[VoiceCallManager] /reports/connecting failed for $callId (HTTP $statusCode): ${result.failure}',
        );
        if (statusCode == 403 || statusCode == 409) {
          await _reconcileCall(callId);
        } else if (attempt < 2 &&
            statusCode != 401 &&
            statusCode != 403 &&
            statusCode != 404 &&
            statusCode != 409 &&
            _currentSnapshot?.callId == callId &&
            _currentGeneration == generation &&
            !(_currentSnapshot?.status.isTerminal ?? true)) {
          _scheduleReportRetry(
            key: 'conn:$reportKey',
            callback: () =>
                _sendConnectingReportWithRetry(callId, generation, attempt + 1),
          );
        }
      }
    } finally {
      _inFlightConnectingKeys.remove(reportKey);
    }
  }

  Future<void> _sendConnectedReportWithRetry(
    String callId,
    int generation, [
    int attempt = 1,
  ]) async {
    final reportKey = '$callId:$generation';
    if (_successfullyReportedConnectedKeys.contains(reportKey) ||
        _inFlightConnectedKeys.contains(reportKey)) {
      return;
    }

    // Connected waits for in-flight Connecting report
    final inFlightConnecting = _inFlightConnectingFutures[reportKey];
    if (inFlightConnecting != null) {
      debugPrint(
        '[VoiceCallManager] Connected report waiting for in-flight connecting report for $reportKey',
      );
      await inFlightConnecting;
    }

    if (_currentSnapshot == null ||
        _currentSnapshot!.callId != callId ||
        _currentGeneration != generation ||
        _currentSnapshot!.status.isTerminal) {
      return;
    }

    _inFlightConnectedKeys.add(reportKey);
    try {
      debugPrint(
        '[VoiceCallManager] Sending /reports/connected for call $callId (gen: $generation, attempt: $attempt)',
      );
      final result = await _reportVoiceConnectedUseCase(
        callId,
        report: VoiceMediaReportRequestDto(
          callId: callId,
          timestampUtc: _serverTimeService.nowUtc.toIso8601String(),
        ),
      );

      if (result is ApiSuccessResult) {
        _successfullyReportedConnectedKeys.add(reportKey);
        debugPrint(
          '[VoiceCallManager] /reports/connected succeeded for $callId (gen: $generation)',
        );
      } else if (result is ApiErrorResult) {
        final statusCode = result.failure.exception.statusCode;
        debugPrint(
          '[VoiceCallManager] /reports/connected failed for $callId (HTTP $statusCode): ${result.failure}',
        );
        if (statusCode == 403 || statusCode == 409) {
          await _reconcileCall(callId);
        } else if (attempt < 2 &&
            statusCode != 401 &&
            statusCode != 403 &&
            statusCode != 404 &&
            statusCode != 409 &&
            _currentSnapshot?.callId == callId &&
            _currentGeneration == generation &&
            !(_currentSnapshot?.status.isTerminal ?? true)) {
          _scheduleReportRetry(
            key: 'connected:$reportKey',
            callback: () =>
                _sendConnectedReportWithRetry(callId, generation, attempt + 1),
          );
        }
      }
    } finally {
      _inFlightConnectedKeys.remove(reportKey);
    }
  }

  void _scheduleReportRetry({
    required String key,
    required Future<void> Function() callback,
  }) {
    _pendingReportRetryTimers[key]?.cancel();
    _pendingReportRetryTimers[key] = Timer(reportRetryDelay, () async {
      _pendingReportRetryTimers.remove(key);
      await callback();
    });
  }

  void _cancelAllReportRetries() {
    for (final timer in _pendingReportRetryTimers.values) {
      timer.cancel();
    }
    _pendingReportRetryTimers.clear();
  }

  void _handleSignalRReconnected() {
    unawaited(_reconcileAfterReconnect());
  }

  @visibleForTesting
  void handleWebRtcConnectionStateChangeForTesting(
    RTCPeerConnectionState state,
  ) => _handleWebRtcConnectionStateChange(state);

  @visibleForTesting
  void handleSignalRReconnectedForTesting() => _handleSignalRReconnected();

  Future<void> _reconcileAfterReconnect() async {
    final session = _currentDeviceSession;
    if (session == null || !session.isValid) return;

    try {
      await _signalRService.bindDeviceSession(
        session.deviceSessionId,
        session.controlProof,
      );
    } catch (_) {}

    final activeResult = await _getActiveVoiceCallUseCase();
    if (activeResult is ApiSuccessResult<VoiceCallSnapshotEntity?>) {
      final active = activeResult.data;
      if (active == null) {
        if (_currentSnapshot != null && !_currentSnapshot!.status.isTerminal) {
          debugPrint(
            '[VoiceCallManager] Active call reconciliation: No active call on server',
          );
          await _callKitService.endAllCalls();
          await _cleanupCall();
        }
      } else {
        await _applySnapshot(active);
        final eventsRes = await _getVoiceCallEventsUseCase(
          active.callId,
          afterSequence: _lastCommittedSequence,
        );
        if (eventsRes is ApiSuccessResult<List<VoiceCallEventEntity>>) {
          for (final event in eventsRes.data) {
            if (event.payloadSnapshot != null) {
              await _applySnapshot(event.payloadSnapshot!);
            }
          }
        }
      }
    }
  }

  Future<ApiResult<VoiceCallSnapshotEntity>> _reconcileCall(
    String callId,
  ) async {
    debugPrint('[VoiceCallManager] Reconciling call details for $callId');
    final res = await _getVoiceCallDetailsUseCase(callId);
    if (res is ApiSuccessResult<VoiceCallSnapshotEntity>) {
      await _applySnapshot(res.data);
    }
    return res;
  }

  Future<bool> answerCall(String callId) async {
    if (_inFlightAccepts.containsKey(callId)) {
      debugPrint('[VoiceCallManager] Reusing in-flight answerCall for $callId');
      return _inFlightAccepts[callId]!;
    }

    final future = _executeAnswerCall(callId);
    _inFlightAccepts[callId] = future;
    try {
      return await future;
    } finally {
      _inFlightAccepts.remove(callId);
    }
  }

  Future<bool> _executeAnswerCall(String callId) async {
    debugPrint('[VoiceCallManager] answerCall: $callId');
    _ringDeadlineTimer?.cancel();
    _ringDeadlineTimer = null;

    if (!_signalRService.isConnected || !_signalRService.isBound) {
      debugPrint(
        '[VoiceCallManager] SignalR not connected or bound. Attempting to ensure connection...',
      );
      await _connectSignalR();
      if (!_signalRService.isConnected || !_signalRService.isBound) {
        debugPrint(
          '[VoiceCallManager] Cannot answer call: SignalR connection or binding failed',
        );
        return false;
      }
    }

    final answerResult = await _answerVoiceCallUseCase(callId);
    if (answerResult is ApiErrorResult) {
      final status = answerResult.failure.exception.statusCode;
      debugPrint(
        '[VoiceCallManager] answerVoiceCall failed (HTTP $status): ${answerResult.failure}',
      );
      if (status == 409) {
        await _reconcileCall(callId);
      }
      return false;
    }

    // Reconcile authoritative server snapshot after successful answer
    await _reconcileCall(callId);

    final iceResult = await _getVoiceIceServersUseCase(callId);
    if (iceResult is! ApiSuccessResult<VoiceIceServersConfigEntity>) {
      debugPrint(
        '[VoiceCallManager] getVoiceIceServers failed for $callId. Aborting media setup.',
      );
      if (iceResult is ApiErrorResult<VoiceIceServersConfigEntity> &&
          iceResult.failure.exception.statusCode == 409) {
        await _reconcileCall(callId);
      }
      return false;
    }

    try {
      await _webrtcService.initializePeerConnection(
        iceServers: iceResult.data.iceServers,
      );
      _isWebRtcReady = true;
    } catch (e) {
      debugPrint(
        '[VoiceCallManager] WebRTC initializePeerConnection failed: $e',
      );
      _isWebRtcReady = false;
      return false;
    }

    await _drainPendingRtcQueue(callId);

    await _navigatorService.pushNamedWhenReady(AppRoutes.activeCall);
    _startHeartbeatTimer(callId);
    return true;
  }

  Future<ApiResult<void>> rejectCall(String callId) async {
    debugPrint('[VoiceCallManager] rejectCall: $callId');
    _ringDeadlineTimer?.cancel();
    _ringDeadlineTimer = null;

    if (_currentSnapshot?.status.isTerminal == true) {
      debugPrint('[VoiceCallManager] rejectCall on already terminal call');
      await _callKitService.endCall(callId);
      await _cleanupCall();
      return const ApiSuccessResult<void>(data: null);
    }

    final result = await _rejectVoiceCallUseCase(callId);
    if (result is ApiSuccessResult<void>) {
      debugPrint('[VoiceCallManager] rejectCall server success for $callId');
      await _callKitService.endCall(callId);
      await _cleanupCall();
      return result;
    } else if (result is ApiErrorResult<void>) {
      final statusCode = result.failure.exception.statusCode;
      debugPrint(
        '[VoiceCallManager] rejectCall server error HTTP $statusCode for $callId',
      );
      if (statusCode == 409) {
        final recResult = await _reconcileCall(callId);
        if (recResult is ApiSuccessResult<VoiceCallSnapshotEntity>) {
          final snapshot = recResult.data;
          if (snapshot.status.isTerminal) {
            await _callKitService.endCall(callId);
            await _cleanupCall();
            return result;
          } else if (snapshot.status == VoiceCallStatus.accepted ||
              snapshot.status == VoiceCallStatus.connecting ||
              snapshot.status == VoiceCallStatus.active) {
            final mySessionId = _currentDeviceSession?.deviceSessionId;
            final isOurDevice =
                snapshot.winningDeviceSessionId == null ||
                snapshot.winningDeviceSessionId == mySessionId;
            if (isOurDevice) {
              debugPrint(
                '[VoiceCallManager] rejectCall got 409 because call is ${snapshot.status}; issuing bounded /end for this device',
              );
              return _executeEndCall(callId, allowRejectFallback: false);
            } else {
              return result;
            }
          }
        }
        debugPrint(
          '[VoiceCallManager] rejectCall got 409 but call is non-terminal or reconciliation failed; preserving call',
        );
        return result;
      }
      return result;
    }
    return result;
  }

  Future<ApiResult<void>> endCall(String callId) async {
    return _executeEndCall(callId, allowRejectFallback: true);
  }

  Future<ApiResult<void>> _executeEndCall(
    String callId, {
    required bool allowRejectFallback,
  }) async {
    debugPrint(
      '[VoiceCallManager] endCall: $callId (status: ${_currentSnapshot?.status})',
    );
    _ringDeadlineTimer?.cancel();
    _ringDeadlineTimer = null;

    if (allowRejectFallback &&
        _currentSnapshot?.status == VoiceCallStatus.ringing) {
      debugPrint(
        '[VoiceCallManager] Call is ringing; rerouting endCall to rejectCall',
      );
      return rejectCall(callId);
    }

    if (_currentSnapshot?.status.isTerminal == true) {
      debugPrint('[VoiceCallManager] endCall on already terminal call');
      await _callKitService.endCall(callId);
      await _cleanupCall();
      return const ApiSuccessResult<void>(data: null);
    }

    final result = await _endVoiceCallUseCase(callId);
    if (result is ApiSuccessResult<void>) {
      debugPrint('[VoiceCallManager] endCall server success for $callId');
      await _callKitService.endCall(callId);
      await _cleanupCall();
      return result;
    } else if (result is ApiErrorResult<void>) {
      final statusCode = result.failure.exception.statusCode;
      debugPrint(
        '[VoiceCallManager] endCall server error HTTP $statusCode for $callId',
      );
      if (statusCode == 409) {
        final recResult = await _reconcileCall(callId);
        if (recResult is ApiSuccessResult<VoiceCallSnapshotEntity>) {
          final snapshot = recResult.data;
          if (snapshot.status.isTerminal) {
            await _callKitService.endCall(callId);
            await _cleanupCall();
            return result;
          }
        }
        debugPrint(
          '[VoiceCallManager] endCall got 409 but call is non-terminal or reconciliation failed; preserving call',
        );
        return result;
      }
      return result;
    }
    return result;
  }

  Future<void> toggleMute() async {
    final newMute = !_webrtcService.isMuted;
    await _webrtcService.setMicrophoneMute(newMute);
  }

  Future<void> toggleSpeaker() async {
    final newSpeaker = !_webrtcService.isSpeakerOn;
    await _webrtcService.setSpeakerphoneOn(newSpeaker);
  }

  void _startHeartbeatTimer(String callId) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      unawaited(_sendVoiceHeartbeatUseCase(callId));
    });
  }

  void _startOrUpdateDurationTimer(
    DateTime connectedAtUtc,
    int? serverReportedDuration,
  ) {
    _durationTimer?.cancel();
    _durationStopwatch.stop();
    _durationStopwatch.reset();
    _durationStopwatch.start();

    final nowServer = _serverTimeService.nowUtc;
    final diffSec = nowServer.difference(connectedAtUtc).inSeconds;
    final baseSec = serverReportedDuration ?? diffSec;
    _baseDurationSeconds = baseSec > 0 ? baseSec : 0;
    _secondsElapsed = _baseDurationSeconds;
    _durationController.add(_secondsElapsed);

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed =
          _baseDurationSeconds + _durationStopwatch.elapsed.inSeconds;
      _durationController.add(_secondsElapsed);
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
    _durationStopwatch.stop();
    _durationStopwatch.reset();
    _baseDurationSeconds = 0;
  }

  Future<void> fetchCallDisplay(String callId, {String? language}) async {
    if (callId.isEmpty) return;
    final lang = language ?? _languageService.getLanguageCode();
    _currentDisplayLanguage = lang;
    final result = await _getVoiceCallDisplayUseCase(callId, language: lang);
    if (result is ApiSuccessResult<VoiceCallDisplayEntity>) {
      if (_currentSnapshot?.callId == callId &&
          (language == null || _currentDisplayLanguage == language)) {
        _currentDisplay = result.data;
        _displayController.add(result.data);
      }
    }
  }

  Future<void> _cleanupCall() async {
    _ringDeadlineTimer?.cancel();
    _ringDeadlineTimer = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _stopDurationTimer();
    _secondsElapsed = 0;
    if (!_durationController.isClosed) {
      _durationController.add(0);
    }

    _cancelAllReportRetries();
    _inFlightConnectingKeys.clear();
    _successfullyReportedConnectingKeys.clear();
    _inFlightConnectedKeys.clear();
    _successfullyReportedConnectedKeys.clear();
    _inFlightConnectingFutures.clear();

    _pendingRtcQueue.clear();
    _processingMessageIds.clear();
    _processedMessageIds.clear();
    _inFlightAccepts.clear();
    _isWebRtcReady = false;
    _currentGeneration = 0;

    _currentDisplay = null;
    _currentDisplayLanguage = null;
    if (!_displayController.isClosed) {
      _displayController.add(null);
    }

    await _webrtcService.cleanup();

    if (_currentSnapshot != null) {
      _currentSnapshot = null;
      if (!_snapshotController.isClosed) {
        _snapshotController.add(null);
      }
    }
  }

  Future<void> onLogout() async {
    await _cleanupCall();
    await _callKitService.endAllCalls();
    await _signalRService.disconnect();
    await _revokeVoiceDeviceUseCase();
    _currentDeviceSession = null;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ringDeadlineTimer?.cancel();
    _ringDeadlineTimer = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _stopDurationTimer();
    _secondsElapsed = 0;
    _cancelAllReportRetries();
    _inFlightConnectingKeys.clear();
    _successfullyReportedConnectingKeys.clear();
    _inFlightConnectedKeys.clear();
    _successfullyReportedConnectedKeys.clear();
    _inFlightConnectingFutures.clear();
    _pendingRtcQueue.clear();
    _processingMessageIds.clear();
    _processedMessageIds.clear();
    _inFlightAccepts.clear();
    _isWebRtcReady = false;
    _currentDisplay = null;
    _currentDisplayLanguage = null;
    _currentSnapshot = null;
    _callKitService.dispose();
    _signalRService.dispose();
    unawaited(_webrtcService.cleanup());
    unawaited(_snapshotController.close());
    unawaited(_displayController.close());
    unawaited(_durationController.close());
  }
}
