import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/core/services/push_notification_payload.dart';

void main() {
  group('Push Notification Deep Links & Arguments', () {
    test('resolves mealmate://calendar to AppRoutes.calendar', () {
      final payload = PushNotificationPayload.fromData({
        'deepLink': 'mealmate://calendar',
        'subscriptionId': 'sub-1',
      });

      expect(payload, isNotNull);
      expect(payload!.routeName, AppRoutes.calendar);
      expect(payload.arguments['subscriptionId'], 'sub-1');
    });

    test('resolves mealmate://orders alias to AppRoutes.calendar', () {
      final payload = PushNotificationPayload.fromData({
        'deepLink': 'mealmate://orders',
      });

      expect(payload, isNotNull);
      expect(payload!.routeName, AppRoutes.calendar);
    });

    test('resolves mealmate://influencer-portal to AppRoutes.influencerDashboard', () {
      final payload = PushNotificationPayload.fromData({
        'deepLink': 'mealmate://influencer-portal',
      });

      expect(payload, isNotNull);
      expect(payload!.routeName, AppRoutes.influencerDashboard);
    });

    test('resolves relative path /orders/{dayId} to AppRoutes.calendar with dayId extracted', () {
      final payload = PushNotificationPayload.fromData({
        'deepLink': '/orders/day-uuid-999',
      });

      expect(payload, isNotNull);
      expect(payload!.routeName, AppRoutes.calendar);
      expect(payload.arguments['dayId'], 'day-uuid-999');
    });

    test('parses query parameters in deep link into arguments', () {
      final payload = PushNotificationPayload.fromData({
        'deepLink': 'mealmate://calendar?subscriptionId=sub-query-123',
      });

      expect(payload, isNotNull);
      expect(payload!.routeName, AppRoutes.calendar);
      expect(payload.arguments['subscriptionId'], 'sub-query-123');
    });

    test('unknown or malformed link returns null safely without throwing', () {
      expect(
        PushNotificationPayload.fromData({'deepLink': 'unknown://invalid'}),
        isNull,
      );
      expect(
        PushNotificationPayload.fromData({'deepLink': ''}),
        isNull,
      );
      expect(
        PushNotificationPayload.fromData({'route': 'unregistered_route'}),
        isNull,
      );
    });

    test('routing_generator parses calendar arguments from String or Map', () {
      // 1. String argument
      final stringRoute = RouteGenerator.getRoute(
        const RouteSettings(
          name: AppRoutes.calendar,
          arguments: 'sub-str-1',
        ),
      );
      expect(stringRoute, isNotNull);

      // 2. Map argument
      final mapRoute = RouteGenerator.getRoute(
        const RouteSettings(
          name: AppRoutes.calendar,
          arguments: {'subscriptionId': 'sub-map-2'},
        ),
      );
      expect(mapRoute, isNotNull);
    });
  });
}
