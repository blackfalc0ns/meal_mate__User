import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../../core/network/network_constants.dart';
import '../../../../core/services/token_service.dart';

typedef CallEventListener = void Function(Map<String, dynamic> envelope);
typedef RtcOfferListener =
    void Function(
      String callId,
      Map<String, dynamic> offer,
      String messageId,
      int generation,
    );
typedef RtcAnswerListener =
    void Function(
      String callId,
      Map<String, dynamic> answer,
      String messageId,
      int generation,
    );
typedef RtcIceListener =
    void Function(
      String callId,
      Map<String, dynamic> candidate,
      String messageId,
      int generation,
    );

@lazySingleton
class VoiceCallSignalRService {
  VoiceCallSignalRService(this._tokenService);

  final TokenService _tokenService;

  HubConnection? _hubConnection;
  bool _isBound = false;
  String? _boundSessionId;
  String? _boundControlProof;

  final _boundController = StreamController<bool>.broadcast();
  Stream<bool> get onBoundChanged => _boundController.stream;

  CallEventListener? onCallEvent;
  RtcOfferListener? onRtcOffer;
  RtcAnswerListener? onRtcAnswer;
  RtcIceListener? onRtcIce;
  VoidCallback? onReconnected;

  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;
  bool get isBound => _isBound;

  Future<void> connectAndBind({
    required String deviceSessionId,
    required String controlProof,
  }) async {
    if (isConnected && _isBound && _boundSessionId == deviceSessionId) {
      debugPrint('[SignalR] Already connected and bound to session: $deviceSessionId');
      return;
    }

    await disconnect();

    const hubUrl = '${NetworkConstants.baseUrl}${EndPoints.voiceCallHub}';
    debugPrint('[SignalR] Connecting to $hubUrl with sessionId: $deviceSessionId');
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              return await _tokenService.getToken() ?? '';
            },
          ),
        )
        .withAutomaticReconnect()
        .build();

    _setupHandlers();

    try {
      await _hubConnection!.start();
      debugPrint('[SignalR] Hub connected. Binding session...');
      await bindDeviceSession(deviceSessionId, controlProof);
    } catch (e) {
      debugPrint('[SignalR] Connection/bind error: $e');
      rethrow;
    }
  }

  void _setupHandlers() {
    final connection = _hubConnection;
    if (connection == null) return;

    connection.onreconnected(({connectionId}) async {
      debugPrint('[SignalR] onreconnected: connectionId=$connectionId. Re-binding session...');
      _isBound = false;
      _boundController.add(false);
      if (_boundSessionId != null && _boundControlProof != null) {
        try {
          await bindDeviceSession(_boundSessionId!, _boundControlProof!);
          debugPrint('[SignalR] Re-bind after reconnect succeeded for $_boundSessionId');
        } catch (e) {
          debugPrint('[SignalR] Re-bind after reconnect failed: $e');
        }
      }
      onReconnected?.call();
    });

    connection.onclose(({error}) {
      debugPrint('[SignalR] onclose: error=$error');
      _isBound = false;
      _boundController.add(false);
    });

    connection.on('bound', (arguments) {
      debugPrint('[SignalR] Received bound event');
      _isBound = true;
      _boundController.add(true);
    });

    connection.on('call:event', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final arg = arguments.first;
        if (arg is Map) {
          final map = Map<String, dynamic>.from(arg);
          final eventId = map['eventId']?.toString() ?? '';
          final callId = map['callId']?.toString() ?? '';
          final seq = (map['sequence'] as num?)?.toInt() ?? 0;
          final payload = map['payload'] is Map ? map['payload'] as Map : null;
          final status = payload?['status']?.toString() ?? '';
          debugPrint('[SignalR] Received call:event (eventId: $eventId, callId: $callId, seq: $seq, status: $status)');
          onCallEvent?.call(map);
        }
      }
    });

    connection.on('rtc:offer', (arguments) {
      if (arguments != null && arguments.length >= 4) {
        final callId = arguments[0]?.toString() ?? '';
        final offerMap = arguments[1] is Map
            ? Map<String, dynamic>.from(arguments[1] as Map)
            : <String, dynamic>{};
        final messageId = arguments[2]?.toString() ?? '';
        final generation = (arguments[3] as num?)?.toInt() ?? 0;
        debugPrint('[SignalR] Received rtc:offer (callId: $callId, messageId: $messageId, gen: $generation)');
        onRtcOffer?.call(callId, offerMap, messageId, generation);
      }
    });

    connection.on('rtc:answer', (arguments) {
      if (arguments != null && arguments.length >= 4) {
        final callId = arguments[0]?.toString() ?? '';
        final answerMap = arguments[1] is Map
            ? Map<String, dynamic>.from(arguments[1] as Map)
            : <String, dynamic>{};
        final messageId = arguments[2]?.toString() ?? '';
        final generation = (arguments[3] as num?)?.toInt() ?? 0;
        debugPrint('[SignalR] Received rtc:answer (callId: $callId, messageId: $messageId, gen: $generation)');
        onRtcAnswer?.call(callId, answerMap, messageId, generation);
      }
    });

    connection.on('rtc:ice-candidate', (arguments) {
      if (arguments != null && arguments.length >= 4) {
        final callId = arguments[0]?.toString() ?? '';
        final candidateMap = arguments[1] is Map
            ? Map<String, dynamic>.from(arguments[1] as Map)
            : <String, dynamic>{};
        final messageId = arguments[2]?.toString() ?? '';
        final generation = (arguments[3] as num?)?.toInt() ?? 0;
        final mid = candidateMap['sdpMid']?.toString();
        final lineIndex = candidateMap['sdpMLineIndex'];
        debugPrint('[SignalR] Received rtc:ice-candidate (callId: $callId, messageId: $messageId, gen: $generation, mid: $mid, lineIndex: $lineIndex)');
        onRtcIce?.call(callId, candidateMap, messageId, generation);
      }
    });
  }

  Future<void> bindDeviceSession(
    String deviceSessionId,
    String controlProof,
  ) async {
    final connection = _hubConnection;
    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      throw StateError('Cannot bind device session: SignalR not connected');
    }

    try {
      debugPrint('[SignalR] Invoking BindDeviceSession for $deviceSessionId');
      await connection.invoke(
        'BindDeviceSession',
        args: [deviceSessionId, controlProof],
      );
      _isBound = true;
      _boundSessionId = deviceSessionId;
      _boundControlProof = controlProof;
      _boundController.add(true);
      debugPrint('[SignalR] BindDeviceSession succeeded for $deviceSessionId');
    } catch (e) {
      _isBound = false;
      _boundController.add(false);
      debugPrint('[SignalR] BindDeviceSession failed for $deviceSessionId: $e');
      rethrow;
    }
  }

  Future<void> sendAnswer({
    required String callId,
    required String sdp,
    required String messageId,
    required int generation,
  }) async {
    _ensureCanSendRtc();
    final bytesLen = utf8.encode(sdp).length;
    if (bytesLen > 65536) {
      throw ArgumentError('SDP exceeds max length of 65,536 bytes');
    }
    debugPrint('[SignalR] Invoking SendAnswer (callId: $callId, messageId: $messageId, gen: $generation, sdpBytes: $bytesLen)');
    await _hubConnection!.invoke(
      'SendAnswer',
      args: [
        callId,
        {'type': 'answer', 'sdp': sdp},
        messageId,
        generation,
      ],
    );
  }

  Future<void> sendOffer({
    required String callId,
    required String sdp,
    required String messageId,
    required int generation,
  }) async {
    _ensureCanSendRtc();
    final bytesLen = utf8.encode(sdp).length;
    if (bytesLen > 65536) {
      throw ArgumentError('SDP exceeds max length of 65,536 bytes');
    }
    debugPrint('[SignalR] Invoking SendOffer (callId: $callId, messageId: $messageId, gen: $generation, sdpBytes: $bytesLen)');
    await _hubConnection!.invoke(
      'SendOffer',
      args: [
        callId,
        {'type': 'offer', 'sdp': sdp},
        messageId,
        generation,
      ],
    );
  }

  Future<void> sendIceCandidate({
    required String callId,
    required Map<String, dynamic> candidateData,
    required String messageId,
    required int generation,
  }) async {
    _ensureCanSendRtc();
    final candidateStr = candidateData['candidate']?.toString() ?? '';
    if (candidateStr.isEmpty) {
      return;
    }
    if (utf8.encode(candidateStr).length > 4096) {
      throw ArgumentError('Candidate exceeds max length of 4,096 bytes');
    }
    final mid = candidateData['sdpMid']?.toString();
    final lineIndex = candidateData['sdpMLineIndex'];
    debugPrint('[SignalR] Invoking SendIceCandidate (callId: $callId, messageId: $messageId, gen: $generation, mid: $mid, lineIndex: $lineIndex)');
    await _hubConnection!.invoke(
      'SendIceCandidate',
      args: [callId, candidateData, messageId, generation],
    );
  }

  void _ensureCanSendRtc() {
    if (!isConnected || !_isBound) {
      throw StateError(
        'Cannot send RTC message: SignalR not connected or bound',
      );
    }
  }

  Future<void> disconnect() async {
    _isBound = false;
    _boundSessionId = null;
    _boundControlProof = null;
    _boundController.add(false);
    if (_hubConnection != null) {
      try {
        debugPrint('[SignalR] Disconnecting hub');
        await _hubConnection!.stop();
      } catch (_) {}
      _hubConnection = null;
    }
  }

  void dispose() {
    unawaited(disconnect());
    unawaited(_boundController.close());
  }
}
