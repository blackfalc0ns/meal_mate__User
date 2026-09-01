import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/push_notification_payload.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

@lazySingleton
class PushNotificationService {
  PushNotificationService(
    this._messaging,
    this._localNotifications,
    this._navigatorService,
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
      unawaited(_handleMessageTap(initialMessage));
    }

    _messaging.onTokenRefresh.listen(_handleTokenRefresh);
    return _messaging.getToken();
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

  Future<void> _handleMessageTap(RemoteMessage message) {
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

  void _handleTokenRefresh(String _) {}
}
