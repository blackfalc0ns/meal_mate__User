import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/services/push_notification_service.dart';

void main() {
  group('formatPushNotificationDebugLog', () {
    test('formats message details without leaking complete tokens', () {
      final receivedAt = DateTime.utc(2026, 9, 1, 10, 30, 45);

      final log = formatPushNotificationDebugLog(
        source: 'foreground',
        receivedAt: receivedAt,
        messageId: 'message-123',
        sentTime: DateTime.utc(2026, 9, 1, 10, 30),
        title: 'Order update',
        body: 'Your order is ready',
        channelId: 'meal_mate_push_notifications',
        data: const {
          'route': '/calendar',
          'fcmToken': 'abcdefghijklmnopqrstuvwxyz123456',
          'nested': {'deviceToken': 'token-value-987654321'},
        },
      );

      expect(log, contains('source=foreground'));
      expect(log, contains('messageId=message-123'));
      expect(log, contains('receivedAt=2026-09-01T10:30:45.000Z'));
      expect(log, contains('sentTime=2026-09-01T10:30:00.000Z'));
      expect(log, contains('title=Order update'));
      expect(log, contains('body=Your order is ready'));
      expect(log, contains('channelId=meal_mate_push_notifications'));
      expect(log, contains('dataKeys=[fcmToken, nested, route]'));
      expect(log, contains('"route":"/calendar"'));
      expect(log, isNot(contains('abcdefghijklmnopqrstuvwxyz123456')));
      expect(log, isNot(contains('token-value-987654321')));
      expect(log, contains('***3456'));
      expect(log, contains('***4321'));
    });
  });
}
