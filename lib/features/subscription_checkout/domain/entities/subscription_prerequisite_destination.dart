import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';

enum SubscriptionPrerequisiteDestination {
  address,
  allergies,
  dietaryPreferences;

  static SubscriptionPrerequisiteDestination? fromErrorCode(String code) {
    return switch (code) {
      SubscriptionErrorCodes.addressRequired => address,
      SubscriptionErrorCodes.allergiesRequired ||
      'family.allergies_required' => allergies,
      SubscriptionErrorCodes.dietaryPreferencesRequired => dietaryPreferences,
      _ => null,
    };
  }

  static SubscriptionPrerequisiteDestination? fromProfileStatus({
    required bool hasDeliveryAddress,
    required bool hasAllergies,
    required bool hasDietaryPreferences,
  }) {
    if (!hasDeliveryAddress) return address;
    if (!hasAllergies) return allergies;
    if (!hasDietaryPreferences) return dietaryPreferences;
    return null;
  }

  static List<SubscriptionPrerequisiteDestination> listFromProfileStatus({
    required bool hasDeliveryAddress,
    required bool hasAllergies,
    required bool hasDietaryPreferences,
  }) {
    final list = <SubscriptionPrerequisiteDestination>[];
    if (!hasDeliveryAddress) list.add(address);
    if (!hasAllergies) list.add(allergies);
    if (!hasDietaryPreferences) list.add(dietaryPreferences);
    return list;
  }
}
