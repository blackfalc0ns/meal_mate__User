enum SubscriptionPrerequisiteDestination {
  address,
  allergies,
  dietaryPreferences;

  static SubscriptionPrerequisiteDestination? fromErrorCode(String code) {
    return switch (code) {
      'checkout.address_required' => address,
      'checkout.allergies_required' || 'family.allergies_required' => allergies,
      'checkout.dietary_preferences_required' => dietaryPreferences,
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
