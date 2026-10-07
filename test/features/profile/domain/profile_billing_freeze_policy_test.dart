import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

void main() {
  test('minimum freeze start skips the locked delay window', () {
    final minimumDate = SubscriptionBillingFreezeDatePolicy.minimumStartDate(
      now: DateTime(2026, 9, 3, 23, 30),
      freezeStartDelayDays: 3,
    );

    expect(minimumDate, DateTime(2026, 9, 7));
  });

  test('minimum freeze start uses backend date when available', () {
    final minimumDate = SubscriptionBillingFreezeDatePolicy.minimumStartDate(
      now: DateTime(2026, 9, 3, 23, 30),
      freezeStartDelayDays: 3,
      earliestFreezeStartDate: '2026-09-06',
    );

    expect(minimumDate, DateTime(2026, 9, 6));
  });
}
