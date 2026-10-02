/// Centralized error and readiness codes for subscription checkout flow.
class SubscriptionErrorCodes {
  SubscriptionErrorCodes._();

  /// Block reason when no participating restaurants cover the selected address.
  static const String noRestaurantsForAddress =
      'subscription_flow.no_restaurants_for_address';

  /// Alternative block reason for checkout address coverage.
  static const String checkoutNoRestaurantsForAddress =
      'checkout.no_restaurants_for_address';

  /// Block reason when a restaurant is not eligible.
  static const String restaurantNotEligible = 'restaurant.not_eligible';

  /// Error code when startDate is required by the backend.
  static const String startDateRequired = 'checkout.start_date_required';

  /// Error code when address is required.
  static const String addressRequired = 'checkout.address_required';

  /// Error code when allergies are required.
  static const String allergiesRequired = 'checkout.allergies_required';

  /// Error code when dietary preferences are required.
  static const String dietaryPreferencesRequired =
      'checkout.dietary_preferences_required';

  /// Error code when an existing active subscription is present.
  static const String existingSubscription = 'checkout.existing_subscription';

  // ── Readiness action screens ──
  /// User must select or add an address.
  static const String actionAddress = 'ADDRESS';

  /// User must complete dietary preferences.
  static const String actionDietaryPreferences = 'DIETARY_PREFERENCES';

  /// User must specify allergies.
  static const String actionAllergies = 'ALLERGIES';
}
