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

  /// Error code when checkout coupon is rejected.
  static const String couponRejected = 'checkout.coupon_rejected';

  /// Error code when checkout coupon is no longer valid.
  static const String couponNoLongerValid = 'checkout.coupon_no_longer_valid';

  /// Error code when coupon results in zero amount (full discount unsupported).
  static const String couponFullDiscountUnsupported =
      'checkout.coupon_full_discount_unsupported';

  // ── Readiness action screens ──
  /// User must select or add an address.
  static const String actionAddress = 'ADDRESS';

  /// User must complete dietary preferences.
  static const String actionDietaryPreferences = 'DIETARY_PREFERENCES';

  /// User must specify allergies.
  static const String actionAllergies = 'ALLERGIES';

  // ── Calendar flow ──
  /// The selected day box requirements are not met.
  static const String calendarBoxIncomplete = 'calendar.box_incomplete';

  /// Selection is locked for this day and cannot be changed.
  static const String calendarSelectionLocked = 'calendar.selection_locked';

  /// The day is unavailable for ordering or editing.
  static const String calendarDayUnavailable = 'calendar.day_unavailable';

  /// Fulfillment is not ready for the selected day.
  static const String calendarFulfillmentNotReady =
      'calendar.fulfillment_not_ready';

  /// Generic not found error code from common backend errors.
  static const String commonNotFound = 'errors.common.not_found';

  // ── Subscription upgrade flow ──
  /// Upgrade not available for current subscription status.
  static const String upgradeNotAvailableForStatus =
      'upgrade_not_available_for_status';

  /// Customer is already on the highest tier.
  static const String upgradeAlreadyHighestTier = 'already_elite';

  /// An upgrade request is already pending.
  static const String upgradeRequestPending = 'upgrade_request_pending';

  /// Subscription has no remaining days to upgrade.
  static const String upgradeNoRemainingDays = 'upgrade_no_remaining_days';

  /// Pricing is unavailable for the target upgrade.
  static const String upgradePricingUnavailable = 'pricing.unavailable';

  /// Selected upgrade target tier is invalid.
  static const String upgradeTargetInvalid =
      'subscription.upgrade_target_invalid';

  /// Redirect URLs are required for upgrade payment.
  static const String upgradeRedirectUrlsRequired =
      'upgrade.redirect_urls_required';

  /// Customer not found for upgrade.
  static const String upgradeCustomerNotFound = 'upgrade.customer_not_found';

  /// Subscription upgrade is not available.
  static const String upgradeNotAvailable = 'subscription.upgrade_not_available';

  /// Upgrade request already pending.
  static const String upgradeRequestAlreadyPending =
      'subscription.upgrade_request_already_pending';
}
