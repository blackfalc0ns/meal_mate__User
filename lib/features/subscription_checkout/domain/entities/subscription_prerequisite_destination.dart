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
}
