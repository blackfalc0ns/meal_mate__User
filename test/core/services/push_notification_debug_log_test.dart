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

    test('redacts raw envelope, authorization, controlProof, sdp, ice, and address', () {
      final receivedAt = DateTime.utc(2026, 9, 1, 10, 30, 45);

      final log = formatPushNotificationDebugLog(
        source: 'background',
        receivedAt: receivedAt,
        messageId: 'message-voice-1',
        sentTime: DateTime.utc(2026, 9, 1, 10, 30),
        title: 'Voice Call',
        body: 'Incoming call',
        channelId: null,
        data: const {
          'envelope': '{"callId":"call-1","controlProof":"secret-proof-123","sdp":"v=0..."}',
          'controlProof': 'super-secret-proof-9999',
          'authorization': 'Bearer token-secret-auth-8888',
          'ice': 'candidate:123456789',
          'address': 'Secret Street 42',
        },
      );

      expect(log, contains('[REDACTED_ENVELOPE]'));
      expect(log, isNot(contains('secret-proof-123')));
      expect(log, isNot(contains('super-secret-proof-9999')));
      expect(log, isNot(contains('token-secret-auth-8888')));
      expect(log, isNot(contains('candidate:123456789')));
      expect(log, isNot(contains('Secret Street 42')));
    });
  });
}
