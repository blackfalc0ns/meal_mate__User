class SubscriptionAvailabilityEntity {
  const SubscriptionAvailabilityEntity({
    required this.status,
    required this.coveredRestaurantCount,
    required this.eligibleRestaurantCount,
    this.checkedAtUtc,
    required this.effectiveStartDate,
    required this.messageCode,
  });

  final String status;
  final int coveredRestaurantCount;
  final int eligibleRestaurantCount;
  final DateTime? checkedAtUtc;
  final String effectiveStartDate;
  final String messageCode;

  bool get isAvailable => status == 'available';
  bool get isAddressRequired => status == 'address_required';
  bool get isSelectionRequired => status == 'selection_required';
  bool get isNoRestaurantsForAddress => status == 'no_restaurants_for_address';
  bool get isNoRestaurantsForSelection => status == 'no_restaurants_for_selection';

  SubscriptionAvailabilityEntity copyWith({
    String? status,
    int? coveredRestaurantCount,
    int? eligibleRestaurantCount,
    DateTime? checkedAtUtc,
    String? effectiveStartDate,
    String? messageCode,
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
    );
  }
}
