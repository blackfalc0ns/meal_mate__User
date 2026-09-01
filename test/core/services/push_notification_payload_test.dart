import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/services/push_notification_payload.dart';

void main() {
  group('PushNotificationPayload', () {
    test('returns null when route is missing', () {
      final payload = PushNotificationPayload.fromData(const {
        'subscriptionId': 'sub-1',
      });

      expect(payload, isNull);
    });

    test('parses route and preserves additional data as arguments', () {
      final payload = PushNotificationPayload.fromData(const {
        'route': '/calendar',
        'subscriptionId': 'sub-1',
        'date': '2026-09-01',
      });

      expect(payload?.routeName, '/calendar');
      expect(payload?.arguments, {
        'subscriptionId': 'sub-1',
        'date': '2026-09-01',
      });
    });

    test('trims route before accepting it', () {
      final payload = PushNotificationPayload.fromData(const {
        'route': '  /offers  ',
      });

      expect(payload?.routeName, '/offers');
      expect(payload?.arguments, isEmpty);
    });
  });
}
