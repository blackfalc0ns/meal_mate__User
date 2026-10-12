import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/device_id_service.dart';
import 'package:meal_meat_user/core/services/push_notification_payload.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:meal_meat_user/features/calling/service/voice_call_manager.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_register_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_register_response_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_unregister_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/register_device_token_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/unregister_device_token_usecase.dart';
import 'package:meal_meat_user/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logPushNotificationMessage('background', message);

  if (message.data.containsKey('envelope') ||
      message.data['type'] == 'voice-call') {
    final envelopeStr = message.data['envelope']?.toString();
    if (envelopeStr != null) {
      try {
        final decoded = jsonDecode(envelopeStr);
        if (decoded is Map<String, dynamic>) {
          final callId = decoded['callId']?.toString();
          final eventType = decoded['eventType']?.toString().toLowerCase();
          final payload =
              decoded['payload'] is Map ? decoded['payload'] as Map : null;
          final status = payload?['status']?.toString().toLowerCase();

          if (callId != null && callId.isNotEmpty) {
            if (eventType == 'call:ringing' ||
                status == 'ringing' ||
                eventType == 'call:created') {
              final deadlineStr = payload?['deadlineAtUtc']?.toString();
              int durationMs = 30000;
              if (deadlineStr != null && deadlineStr.isNotEmpty) {
                final deadline = DateTime.tryParse(deadlineStr)?.toUtc();
                if (deadline != null) {
                  int serverOffsetMs = 0;
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    serverOffsetMs = prefs.getInt('server_time_offset_ms') ?? 0;
                  } catch (e) {
                    debugPrint(
                      '[PushNotification] Failed reading server offset in bg: $e',
                    );
                  }
                  final nowServer = DateTime.now().toUtc().add(
                        Duration(milliseconds: serverOffsetMs),
                      );
                  final diff = deadline.difference(nowServer);
                  if (diff.isNegative || diff.inMilliseconds <= 0) {
                    debugPrint(
                      '[PushNotification] Call ring deadline already expired: $deadline vs serverNow: $nowServer',
                    );
                    return; // already expired
                  }
                  durationMs = diff.inMilliseconds;
                }
              }

              final params = CallKitParams(
                id: callId,
                nameCaller: 'مندوب التوصيل',
                appName: 'MealMate',
                handle: 'مندوب التوصيل',
                type: 0,
                duration: durationMs,
                extra: <String, dynamic>{'callId': callId},
                android: const AndroidParams(
                  isCustomNotification: true,
                  isShowLogo: false,
                  ringtonePath: 'system_ringtone_default',
                  backgroundColor: '#090909',
                  actionColor: '#078847',
                  textColor: '#ffffff',
                  textAccept: 'Accept',
                  textDecline: 'Decline',
                ),
                ios: const IOSParams(
                  iconName: 'AppIcon',
                  handleType: 'generic',
                  supportsVideo: false,
                  maximumCallGroups: 1,
                  maximumCallsPerCallGroup: 1,
                  audioSessionMode: 'voiceChat',
                  audioSessionActive: true,
                  audioSessionPreferredSampleRate: 44100.0,
                  audioSessionPreferredIOBufferDuration: 0.005,
                  supportsDTMF: false,
                  supportsHolding: false,
                  supportsGrouping: false,
                  supportsUngrouping: false,
                ),
              );
              await FlutterCallkitIncoming.showCallkitIncoming(params);
            } else if (status == 'rejected' ||
                status == 'cancelled' ||
                status == 'missed' ||
                status == 'failed' ||
                status == 'ended') {
              await FlutterCallkitIncoming.endCall(callId);
            }
          }
        }
      } catch (e) {
        debugPrint(
          '[PushNotification] Error processing background voice envelope: $e',
        );
      }
    }
    return;
  }
}

void logPushNotificationMessage(String source, RemoteMessage message) {
  debugPrint(
    formatPushNotificationDebugLog(
      source: source,
      receivedAt: DateTime.now(),
      messageId: message.messageId,
      sentTime: message.sentTime,
      title: message.notification?.title,
      body: message.notification?.body,
      channelId: message.notification?.android?.channelId,
      data: message.data,
    ),
  );
}

@visibleForTesting
String formatPushNotificationDebugLog({
  required String source,
  required DateTime receivedAt,
  required String? messageId,
  required DateTime? sentTime,
  required String? title,
  required String? body,
  required String? channelId,
  required Map<String, dynamic> data,
}) {
  final sortedDataKeys = data.keys.toList()..sort();
  final sanitizedData = _sanitizePushNotificationData(data);

  return [
    '[PushNotification]',
    'source=$source',
    'receivedAt=${receivedAt.toUtc().toIso8601String()}',
    'sentTime=${sentTime?.toUtc().toIso8601String() ?? 'null'}',
    'messageId=${messageId ?? 'null'}',
    'title=${title ?? 'null'}',
    'body=${body ?? 'null'}',
    'channelId=${channelId ?? 'null'}',
    'dataKeys=$sortedDataKeys',
    'data=${jsonEncode(sanitizedData)}',
  ].join(' | ');
}

Map<String, dynamic> _sanitizePushNotificationData(Map<String, dynamic> data) {
  return data.map(
    (key, value) => MapEntry(key, _sanitizeDebugValue(key, value)),
  );
}

Object? _sanitizeDebugValue(String key, Object? value) {
  if (key.toLowerCase() == 'envelope') {
    return '[REDACTED_ENVELOPE]';
  }

  if (value is Map) {
    return value.map(
      (nestedKey, nestedValue) => MapEntry(
        nestedKey.toString(),
        _sanitizeDebugValue(nestedKey.toString(), nestedValue),
      ),
    );
  }

  if (value is List) {
    return value
        .map((item) => _sanitizeDebugValue(key, item))
        .toList(growable: false);
  }

  if (value is String && _looksSensitivePushKey(key)) {
    return _maskDebugValue(value);
  }

  return value;
}

bool _looksSensitivePushKey(String key) {
  final normalized = key.toLowerCase();
  return normalized.contains('token') ||
      normalized.contains('secret') ||
      normalized.contains('password') ||
      normalized.contains('authorization') ||
      normalized.contains('controlproof') ||
      normalized.contains('sdp') ||
      normalized.contains('ice') ||
      normalized.contains('address');
}

String _maskDebugValue(String value) {
  if (value.length <= 4) {
    return '***';
  }

  return '***${value.substring(value.length - 4)}';
}

@lazySingleton
class PushNotificationService {
  PushNotificationService(
    this._messaging,
    this._localNotifications,
    this._navigatorService,
    this._tokenService,
    this._deviceIdService,
    this._registerDeviceTokenUseCase,
    this._unregisterDeviceTokenUseCase,
  );

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'meal_mate_push_notifications',
        'Meal Mate Notifications',
        description: 'Meal Mate app notifications',
        importance: Importance.high,
      );

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final AppNavigatorService _navigatorService;
  final TokenService _tokenService;
  final DeviceIdService _deviceIdService;
  final RegisterDeviceTokenUseCase _registerDeviceTokenUseCase;
  final UnregisterDeviceTokenUseCase _unregisterDeviceTokenUseCase;

  bool _initialized = false;

  Future<String?> initialize() async {
    if (_initialized) {
      return _messaging.getToken();
    }
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermissions();
    await _initializeLocalNotifications();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      logPushNotificationMessage('initial', initialMessage);
      unawaited(_handleMessageTap(initialMessage));
    }

    _messaging.onTokenRefresh.listen(_handleTokenRefresh);

    final token = await _messaging.getToken();
    await registerCurrentToken(token: token);
    try {
      unawaited(GetIt.instance<VoiceCallManager>().initialize());
    } catch (_) {}
    return token;
  }

  Future<void> registerCurrentToken({String? token}) async {
    try {
      if (!_tokenService.isAccessTokenSaved) {
        return;
      }

      final fcmToken = token ?? await _messaging.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        return;
      }

      final platform = _currentPlatform;
      if (platform == null) {
        return;
      }

      final regResult = await _registerDeviceTokenUseCase(
        DeviceTokenRegisterRequestEntity(
          token: fcmToken,
          platform: platform,
          deviceId: await _deviceIdService.getOrCreateDeviceId(),
        ),
      );

      if (regResult is ApiSuccessResult<DeviceTokenRegisterResponseEntity>) {
        final fcmDeviceTokenId = regResult.data.fcmDeviceTokenId;
        if (fcmDeviceTokenId != null && fcmDeviceTokenId.isNotEmpty) {
          String? voipToken;
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            try {
              voipToken = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
            } catch (_) {}
          }
          if (GetIt.instance.isRegistered<VoiceCallManager>()) {
            await GetIt.instance<VoiceCallManager>().ensureDeviceRegistered(
              fcmDeviceTokenId: fcmDeviceTokenId,
              apnsVoipToken: voipToken,
              force: false,
            );
          }
        }
      }
    } catch (error, stackTrace) {
      debugPrintStack(
        label: 'Failed to register push notification token: $error',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> unregisterCurrentToken() async {
    try {
      if (!_tokenService.isAccessTokenSaved) {
        return;
      }

      final fcmToken = await _messaging.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        return;
      }

      if (GetIt.instance.isRegistered<VoiceCallManager>()) {
        await GetIt.instance<VoiceCallManager>().onLogout();
      }

      await _unregisterDeviceTokenUseCase(
        DeviceTokenUnregisterRequestEntity(token: fcmToken),
      );
    } catch (error, stackTrace) {
      debugPrintStack(
        label: 'Failed to unregister push notification token: $error',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    logPushNotificationMessage('foreground', message);

    if (message.data.containsKey('envelope') ||
        message.data['type'] == 'voice-call') {
      try {
        await GetIt.instance<VoiceCallManager>().handleFcmPushMessage(message.data);
      } catch (e) {
        debugPrint('[PushNotification] Error handling voice call push: $e');
      }
      return;
    }

    final notification = message.notification;
    if (defaultTargetPlatform == TargetPlatform.iOS && notification != null) {
      return;
    }

    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();
    if (title == null && body == null) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'meal_mate_push_notifications',
      'Meal Mate Notifications',
      channelDescription: 'Meal Mate app notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  Future<void> _handleMessageTap(RemoteMessage message) async {
    logPushNotificationMessage('opened', message);
    if (message.data.containsKey('envelope') ||
        message.data['type'] == 'voice-call') {
      try {
        await GetIt.instance<VoiceCallManager>().handleFcmPushMessage(message.data);
      } catch (e) {
        debugPrint('[PushNotification] Error handling voice call push tap: $e');
      }
      return;
    }
    return _navigateFromData(message.data);
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        unawaited(_navigateFromData(decoded));
      }
    } on FormatException catch (error, stackTrace) {
      debugPrintStack(
        label: 'Invalid push notification payload: $error',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _navigateFromData(Map<String, dynamic> data) async {
    final payload = PushNotificationPayload.fromData(data);
    if (payload == null) {
      return;
    }

    await _navigatorService.pushNamedWhenReady(
      payload.routeName,
      arguments: payload.arguments,
    );
  }

  Future<void> _handleTokenRefresh(String token) {
    return registerCurrentToken(token: token);
  }

  int? get _currentPlatform {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 1,
      TargetPlatform.iOS => 2,
      _ => null,
    };
  }
}
