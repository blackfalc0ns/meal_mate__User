import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_prerequisite_destination.dart';

void main() {
  group('SubscriptionPrerequisiteDestination', () {
    const cases = {
      'checkout.address_required': SubscriptionPrerequisiteDestination.address,
      'checkout.allergies_required':
          SubscriptionPrerequisiteDestination.allergies,
      'family.allergies_required':
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

    test('selects address as the first missing profile step', () {
      expect(
        SubscriptionPrerequisiteDestination.fromProfileStatus(
          hasDeliveryAddress: false,
          hasAllergies: false,
          hasDietaryPreferences: false,
        ),
        SubscriptionPrerequisiteDestination.address,
      );
    });

    test('selects allergies after the delivery address is complete', () {
      expect(
        SubscriptionPrerequisiteDestination.fromProfileStatus(
          hasDeliveryAddress: true,
          hasAllergies: false,
          hasDietaryPreferences: false,
        ),
        SubscriptionPrerequisiteDestination.allergies,
      );
    });

    test('selects dietary preferences after earlier steps are complete', () {
      expect(
        SubscriptionPrerequisiteDestination.fromProfileStatus(
          hasDeliveryAddress: true,
          hasAllergies: true,
          hasDietaryPreferences: false,
        ),
        SubscriptionPrerequisiteDestination.dietaryPreferences,
      );
    });

    test('returns no destination when every profile step is complete', () {
      expect(
        SubscriptionPrerequisiteDestination.fromProfileStatus(
          hasDeliveryAddress: true,
          hasAllergies: true,
          hasDietaryPreferences: true,
        ),
        isNull,
      );
    });
  });
}
