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

  /// Error code when no restaurants deliver to address.
  static const String noDelivery = 'subscription_flow.no_delivery_to_address';

  /// Error code when no restaurants cover the selected options.
  static const String optionUncovered = 'no_restaurants_for_address';

  /// Error code when restaurants cover address, but none have eligible meals/valid pricing.
  static const String noPreparedRestaurants =
      'subscription_flow.no_prepared_restaurants';

  /// Error code when no restaurants can serve the entire period.
  static const String periodUnavailable = 'no_restaurants_for_selection';

  /// Error code when selection (duration, start date) is required.
  static const String selectionRequired =
      'subscription_flow.selection_required';

  /// Error code when Friday service is unavailable.
  static const String fridayUnavailable =
      'subscription_flow.friday_unavailable';

  /// Error code when pricing is unavailable.
  static const String pricingUnavailable =
      'subscription_flow.pricing_unavailable';

  /// Error code for empty options.
  static const String emptyOptions = 'subscription_flow.empty_options';

  /// Error code for loading status.
  static const String loading = 'subscription_flow.loading';

  /// Error code for request failed.
  static const String requestFailed = 'subscription_flow.request_failed';

  /// Error code when deadline has passed.
  static const String deadlinePassed = 'deadline_passed';
  static const String selectionDeadlinePassed = 'selection_deadline_passed';
  static const String calendarSelectionDeadlinePassed =
      'calendar.selection_deadline_passed';

  /// Error code for first day edit deadline window.
  static const String firstDayDeadline = 'calendar.first_day_deadline';

  /// Error code for ordinary days edit deadline window.
  static const String ordinaryDeadline = 'calendar.ordinary_deadline';

  /// Error code for pending fulfillment.
  static const String fulfillmentPending = 'fulfillment_pending';
  static const String fulfillmentNotReady = 'fulfillment_not_ready';

  /// Error code for automatic selection failure.
  static const String autoSelectionFailed = 'calendar.auto_selection_failed';

  // ── Calendar Failure Reason Codes ──
  /// No eligible restaurant covers delivery address for this day.
  static const String calendarRestaurantCoverageUnavailable =
      'calendar.restaurant_coverage_unavailable';

  /// Restaurant does not have approved menu for delivery day.
  static const String calendarBoxNotReady = 'calendar.box_not_ready';

  /// Restaurant capacity is full or unavailable on delivery day.
  static const String restaurantCapacityFull = 'RESTAURANT_CAPACITY_FULL';

  /// No full allergy-safe box available for this day.
  static const String calendarNoSafeBox = 'calendar.no_safe_box';

  /// Restaurant is busy on delivery day.
  static const String calendarRestaurantBusy = 'calendar.restaurant_busy';

  /// Restaurant has reached repetition limit.
  static const String calendarQuotaExhausted = 'calendar.quota_exhausted';

  // ── Day Edit Block Reasons ──
  static const String dayLocked = 'day_locked';
  static const String calendarDayLocked = 'calendar.day_locked';
  static const String dayFrozen = 'day_frozen';
  static const String calendarDayFrozen = 'subscription.day_frozen';
  static const String dayCancelled = 'day_cancelled';
  static const String calendarDayCancelled = 'calendar.day_cancelled';

  // ── Freeze Codes ──
  static const String freezePreparationFailed = 'freeze.preparation_failed';
  static const String freezePreparationUnavailable =
      'freeze.preparation_unavailable';
  static const String freezeReplacementPoolUnavailable =
      'freeze.replacement_pool_unavailable';
  static const String replacementCapacityUnavailable =
      'freeze.replacement_capacity_unavailable';
  static const String replacementRestaurantsUnavailable =
      'freeze.replacement_restaurants_unavailable';
  static const String freezeNoServiceDays = 'freeze.no_service_days';
  static const String freezeLockedDaysCannotBeFrozen =
      'freeze.locked_days_cannot_be_frozen';

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
  static const String upgradeNotAvailable =
      'subscription.upgrade_not_available';

  /// Upgrade request already pending.
  static const String upgradeRequestAlreadyPending =
      'subscription.upgrade_request_already_pending';

  // ── Family Domain Error Codes ──
  /// Permissions conflict (409) - Permissions changed on server.
  static const String familyPermissionsChanged = 'family.permissions_changed';

  /// Delivery version conflict (409) - Delivery version mismatch.
  static const String familyDeliveryVersionChanged =
      'family.delivery_version_changed';

  /// Quote changed - Package pricing updated, review required.
  static const String familyQuoteChanged = 'family.quote_changed';

  /// Idempotency key already used for a different intent.
  static const String familyIdempotencyKeyUsed = 'family.idempotency_key_used';

  /// Client app update required to continue subscription/checkout.
  static const String familyClientUpdateRequired =
      'family.client_update_required';

  /// Invoice creation stopped temporarily on backend.
  static const String familyInvoiceCreationStopped =
      'family.invoice_creation_stopped';

  /// Member must have a linked account before subscribing.
  static const String familyMemberAccountRequired =
      'family.member_account_required';

  /// Payment method is unavailable.
  static const String familyPaymentMethodUnavailable =
      'family.payment_method_unavailable';

  /// Payment currency is not supported.
  static const String familyPaymentCurrencyUnsupported =
      'family.payment_currency_unsupported';

  /// Provider refund required - operations/provider processing needed.
  static const String familyProviderRefundRequired =
      'family.provider_refund_required';

  /// Delivery snapshot review required - amendment cannot overwrite paid schedule.
  static const String familyDeliverySnapshotReviewRequired =
      'family.delivery_snapshot_review_required';

  /// Action not available for current member or capability state.
  static const String familyActionNotAvailable = 'family.action_not_available';

  /// Payment initialization failed (502).
  static const String paymentInitializationFailed =
      'payment.initialization_failed';

  /// Auto renewal price changed on backend.
  static const String autoRenewalPriceChanged = 'auto_renewal.price_changed';

  /// Member setup incomplete blocker.
  static const String familyMemberIncomplete = 'family.member_incomplete';

  /// Cannot remove family manager.
  static const String familyCannotRemoveManager =
      'family.cannot_remove_manager';

  /// Family member not found.
  static const String familyMemberNotFound = 'family.member_not_found';

  /// Member already in family.
  static const String familyAlreadyInFamily = 'family.already_in_family';

  /// Family max members reached.
  static const String familyMaxMembers = 'family.max_members';

  /// Family plan locked.
  static const String familyPlanLocked = 'family.plan_locked';

  /// Family plan incomplete.
  static const String familyPlanIncomplete = 'family.plan_incomplete';

  /// Member is paused.
  static const String familyMemberPaused = 'family.member_paused';

  /// Permission denied.
  static const String familyPermissionDenied = 'family.permission_denied';

  /// Family manager only access.
  static const String familyNotManager = 'family.not_manager';

  /// Permissions version required for update.
  static const String familyPermissionsVersionRequired =
      'family.permissions_version_required';

  /// Manager permissions cannot be modified.
  static const String familyManagerPermissionsImmutable =
      'family.manager_permissions_immutable';

  /// Member access paused.
  static const String familyAccessPaused = 'family.access_paused';

  /// Member access disabled.
  static const String familyAccessDisabled = 'family.access_disabled';

  /// Specific permission required.
  static const String familyPermissionRequired = 'family.permission_required';

  /// Use checkout flow instead of direct action.
  static const String familyUseCheckoutFlow = 'family.use_checkout_flow';

  /// Family group is not active.
  static const String familyGroupNotActive = 'family.group_not_active';

  /// Calendar service temporarily unavailable.
  static const String calendarServiceUnavailable =
      'calendar.service_unavailable';

  /// Box has allergy conflicts.
  static const String calendarAllergyConflict = 'calendar.allergy_conflict';

  /// Subscription service temporarily unavailable.
  static const String subscriptionServiceUnavailable =
      'subscription.service_unavailable';

  /// Auth forbidden (403).
  static const String authForbidden = 'auth.forbidden';
}
