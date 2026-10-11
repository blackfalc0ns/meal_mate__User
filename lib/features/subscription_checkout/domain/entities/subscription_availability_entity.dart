class SubscriptionAvailabilityEntity {
  const SubscriptionAvailabilityEntity({
    required this.status,
    required this.coveredRestaurantCount,
    this.eligibleRestaurantCount,
    this.checkedAtUtc,
    required this.effectiveStartDate,
    required this.messageCode,
    this.scope,
    this.canSelect,
    this.missingStep,
    this.actionEndpoint,
    this.failureReasons = const [],
    this.failureReasonCounts = const {},
  });

  final String status;
  final int coveredRestaurantCount;
  final int? eligibleRestaurantCount;
  final DateTime? checkedAtUtc;
  final String effectiveStartDate;
  final String messageCode;
  final String? scope;
  final bool? canSelect;
  final String? missingStep;
  final String? actionEndpoint;
  final List<String> failureReasons;
  final Map<String, int> failureReasonCounts;

  bool get isAvailable => status == 'available';
  bool get isAddressRequired =>
      status == 'address_required' ||
      messageCode == 'checkout.address_required' ||
      missingStep == 'ADDRESS';
  bool get isAllergiesRequired =>
      status == 'allergies_required' ||
      messageCode == 'checkout.allergies_required' ||
      missingStep == 'ALLERGIES';
  bool get isDietaryPreferencesRequired =>
      status == 'dietary_preferences_required' ||
      messageCode == 'checkout.dietary_preferences_required' ||
      missingStep == 'DIETARY_PREFERENCES';
  bool get isSelectionRequired => status == 'selection_required';
  bool get isNoRestaurantsForAddress => status == 'no_restaurants_for_address';
  bool get isNoRestaurantsForSelection =>
      status == 'no_restaurants_for_selection';
  bool get isNoPreparedRestaurants =>
      status == 'no_prepared_restaurants' ||
      messageCode == 'subscription_flow.no_prepared_restaurants' ||
      messageCode == 'no_prepared_restaurants' ||
      failureReasons.contains('no_prepared_restaurants') ||
      failureReasons.contains('subscription_flow.no_prepared_restaurants');
  bool get isScopePeriod => scope == 'period';
  bool get isScopeCoverage => scope == 'coverage';

  bool get hasPeriodCheck => eligibleRestaurantCount != null;

  bool get effectiveCanSelect {
    if (canSelect == false) return false;
    if (isAddressRequired ||
        isAllergiesRequired ||
        isDietaryPreferencesRequired ||
        isNoPreparedRestaurants) {
      return false;
    }
    return canSelect ?? (isAvailable || isSelectionRequired);
  }

  SubscriptionAvailabilityEntity copyWith({
    String? status,
    int? coveredRestaurantCount,
    int? eligibleRestaurantCount,
    DateTime? checkedAtUtc,
    String? effectiveStartDate,
    String? messageCode,
    String? scope,
    bool? canSelect,
    String? missingStep,
    String? actionEndpoint,
    List<String>? failureReasons,
    Map<String, int>? failureReasonCounts,
  }) {
    return SubscriptionAvailabilityEntity(
      status: status ?? this.status,
      coveredRestaurantCount:
          coveredRestaurantCount ?? this.coveredRestaurantCount,
      eligibleRestaurantCount:
          eligibleRestaurantCount ?? this.eligibleRestaurantCount,
      checkedAtUtc: checkedAtUtc ?? this.checkedAtUtc,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      messageCode: messageCode ?? this.messageCode,
      scope: scope ?? this.scope,
      canSelect: canSelect ?? this.canSelect,
      missingStep: missingStep ?? this.missingStep,
      actionEndpoint: actionEndpoint ?? this.actionEndpoint,
      failureReasons: failureReasons ?? this.failureReasons,
      failureReasonCounts: failureReasonCounts ?? this.failureReasonCounts,
    );
  }
}
