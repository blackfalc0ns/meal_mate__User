import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';

void main() {
  group('SubscriptionPrerequisiteDestination', () {
    const cases = {
      'checkout.address_required': SubscriptionPrerequisiteDestination.address,
      'checkout.allergies_required':
          SubscriptionPrerequisiteDestination.allergies,
      'checkout.dietary_preferences_required':
          SubscriptionPrerequisiteDestination.dietaryPreferences,
    };

    for (final entry in cases.entries) {
      test('maps ${entry.key} to ${entry.value.name}', () {
        expect(
          SubscriptionPrerequisiteDestination.fromErrorCode(entry.key),
          entry.value,
        );
      });
    }

    test('returns null for an unrelated backend error', () {
      expect(
        SubscriptionPrerequisiteDestination.fromErrorCode(
          'subscription_flow.friday_unavailable',
        ),
        isNull,
      );
    });
  });
}
