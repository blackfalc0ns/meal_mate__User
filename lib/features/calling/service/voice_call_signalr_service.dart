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
      return;
    }

    await disconnect();

    const hubUrl = '${NetworkConstants.baseUrl}${EndPoints.voiceCallHub}';
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
      debugPrint('[SignalR] Reconnected. Re-binding...');
      _isBound = false;
      _boundController.add(false);
      onReconnected?.call();
    });

    connection.onclose(({error}) {
      debugPrint('[SignalR] Closed');
      _isBound = false;
      _boundController.add(false);
    });

    connection.on('bound', (arguments) {
      debugPrint('[SignalR] bound event received');
      _isBound = true;
      _boundController.add(true);
    });

    connection.on('call:event', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final arg = arguments.first;
        if (arg is Map) {
          onCallEvent?.call(Map<String, dynamic>.from(arg));
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
      await connection.invoke(
        'BindDeviceSession',
        args: [deviceSessionId, controlProof],
      );
      _isBound = true;
      _boundSessionId = deviceSessionId;
      _boundController.add(true);
    } catch (e) {
      _isBound = false;
      _boundController.add(false);
      debugPrint('[SignalR] BindDeviceSession failed');
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
    if (utf8.encode(sdp).length > 65536) {
      throw ArgumentError('SDP exceeds max length of 65,536 bytes');
    }
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
    if (utf8.encode(sdp).length > 65536) {
      throw ArgumentError('SDP exceeds max length of 65,536 bytes');
    }
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
    _boundController.add(false);
    if (_hubConnection != null) {
      try {
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
