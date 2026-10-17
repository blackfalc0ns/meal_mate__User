import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:signalr_netcore/signalr_client.dart';

abstract interface class CustomerDeliveryRealtimeService {
  Stream<String> get onDeliveryChanged;
  Future<void> connect();
  Future<void> disconnect();
  void notifyDeliveryChanged(String subscriptionDayId);
  void dispose();
}

@LazySingleton(as: CustomerDeliveryRealtimeService)
class CustomerDeliveryRealtimeServiceImpl
    implements CustomerDeliveryRealtimeService {
  CustomerDeliveryRealtimeServiceImpl(this._tokenService);

  final TokenService _tokenService;
  final StreamController<String> _controller =
      StreamController<String>.broadcast();
  final Set<String> _processedEventIds = <String>{};

  HubConnection? _hubConnection;
  bool _isConnecting = false;
  bool _isDisposed = false;
  Timer? _retryTimer;
  int _retryAttempts = 0;

  @override
  Stream<String> get onDeliveryChanged => _controller.stream;

  @override
  Future<void> connect() async {
    if (_isDisposed) return;
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      return;
    }
    if (_isConnecting) return;

    final token = await _tokenService.getToken();
    if (token == null || token.isEmpty) {
      debugPrint(
        '[SignalR:CustomerDelivery] No token available, skipping connect',
      );
      return;
    }

    _isConnecting = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    try {
      if (_hubConnection == null) {
        const hubUrl = '${NetworkConstants.baseUrl}/hubs/customer-delivery';
        _hubConnection = HubConnectionBuilder()
            .withUrl(
              hubUrl,
              options: HttpConnectionOptions(
                accessTokenFactory: () async =>
                    (await _tokenService.getToken()) ?? '',
              ),
            )
            .withAutomaticReconnect()
            .build();

        _hubConnection!.on('customer-delivery-changed', _handleDeliveryChanged);

        _hubConnection!.onreconnected(({connectionId}) {
          debugPrint('[SignalR:CustomerDelivery] Reconnected: $connectionId');
          _retryAttempts = 0;
          notifyDeliveryChanged('');
        });

        _hubConnection!.onclose(({error}) {
          debugPrint('[SignalR:CustomerDelivery] Connection closed: $error');
          if (!_isDisposed) {
            _scheduleRetryWithBackoff();
          }
        });
      }

      debugPrint(
        '[SignalR:CustomerDelivery] Connecting to customer-delivery hub...',
      );
      await _hubConnection!.start();
      _retryAttempts = 0;
      debugPrint(
        '[SignalR:CustomerDelivery] Connected to customer-delivery hub successfully',
      );
      notifyDeliveryChanged('');
    } catch (e) {
      debugPrint('[SignalR:CustomerDelivery] Connection error: $e');
      _scheduleRetryWithBackoff();
    } finally {
      _isConnecting = false;
    }
  }

  void _scheduleRetryWithBackoff() {
    if (_isDisposed) return;
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      return;
    }
    _retryTimer?.cancel();
    _retryAttempts++;
    final backoffSeconds = (1 << _retryAttempts).clamp(2, 32);
    debugPrint(
      '[SignalR:CustomerDelivery] Scheduling connect retry #$_retryAttempts in $backoffSeconds seconds',
    );
    _retryTimer = Timer(Duration(seconds: backoffSeconds), () {
      if (!_isDisposed) {
        unawaited(connect());
      }
    });
  }

  void _handleDeliveryChanged(List<Object?>? arguments) {
    debugPrint(
      '[SignalR:CustomerDelivery] event callback arguments=${arguments?.length ?? 0}',
    );
    if (arguments == null || arguments.isEmpty) return;
    final payload = arguments.first;

    Map<String, dynamic>? data;
    if (payload is Map<String, dynamic>) {
      data = payload;
    } else if (payload is Map) {
      data = payload.map((k, v) => MapEntry(k.toString(), v));
    } else if (payload is String) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        } else if (decoded is Map) {
          data = decoded.map((k, v) => MapEntry(k.toString(), v));
        }
      } catch (_) {}
    }

    if (data == null) return;

    final schemaVersion = data['schemaVersion'];
    if (schemaVersion != null && schemaVersion != 1 && schemaVersion != '1') {
      debugPrint(
        '[SignalR:CustomerDelivery] Unsupported schemaVersion: $schemaVersion',
      );
      return;
    }

    final eventId = data['eventId']?.toString();
    if (eventId != null && eventId.isNotEmpty) {
      if (_processedEventIds.contains(eventId)) {
        debugPrint(
          '[SignalR:CustomerDelivery] Duplicate eventId ignored: $eventId',
        );
        return;
      }
      _processedEventIds.add(eventId);
      if (_processedEventIds.length > 200) {
        _processedEventIds.remove(_processedEventIds.first);
      }
    }

    final subscriptionDayId = data['subscriptionDayId']?.toString() ?? '';
    debugPrint(
      '[SignalR:CustomerDelivery] event received dayId=$subscriptionDayId eventId=$eventId',
    );
    notifyDeliveryChanged(subscriptionDayId);
  }

  @override
  void notifyDeliveryChanged(String subscriptionDayId) {
    if (!_controller.isClosed) {
      _controller.add(subscriptionDayId);
    }
  }

  @override
  Future<void> disconnect() async {
    _retryTimer?.cancel();
    _retryTimer = null;
    _retryAttempts = 0;
    try {
      if (_hubConnection != null) {
        await _hubConnection!.stop();
        debugPrint('[SignalR:CustomerDelivery] Disconnected');
      }
    } catch (e) {
      debugPrint('[SignalR:CustomerDelivery] Disconnect error: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    unawaited(disconnect());
    unawaited(_controller.close());
  }
}
