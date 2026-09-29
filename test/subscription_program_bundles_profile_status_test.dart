import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/mapper/subscription_bundle_mapper.dart';

void main() {
  test('parses every profile completion flag returned with bundles', () {
    final dynamic response = SubscriptionProgramBundlesResponseDto.fromJson({
      'hasDeliveryAddress': true,
      'hasAllergies': true,
      'hasDietaryPreferences': false,
      'isProfileComplete': false,
      'bundles': <Map<String, dynamic>>[],
    });

    expect(response.hasDeliveryAddress, isTrue);
    expect(response.hasAllergies, isTrue);
    expect(response.hasDietaryPreferences, isFalse);
    expect(response.isProfileComplete, isFalse);
  });

  test('maps profile flags and bundles into one domain result', () {
    final response = SubscriptionProgramBundlesResponseDto.fromJson({
      'hasDeliveryAddress': true,
      'hasAllergies': true,
      'hasDietaryPreferences': false,
      'isProfileComplete': false,
      'bundles': [
        {'bundleId': 'bundle-1'},
      ],
    });

    final result = response.toProgramBundlesEntity();

    expect(result.bundles.single.bundleId, 'bundle-1');
    expect(result.hasDeliveryAddress, isTrue);
    expect(result.hasAllergies, isTrue);
    expect(result.hasDietaryPreferences, isFalse);
    expect(result.isProfileComplete, isFalse);
  });
}
