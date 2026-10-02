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

  // ── Readiness action screens ──
  /// User must select or add an address.
  static const String actionAddress = 'ADDRESS';

  /// User must complete dietary preferences.
  static const String actionDietaryPreferences = 'DIETARY_PREFERENCES';

  /// User must specify allergies.
  static const String actionAllergies = 'ALLERGIES';
}
