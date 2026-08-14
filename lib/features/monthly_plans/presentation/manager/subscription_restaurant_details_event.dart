sealed class SubscriptionRestaurantDetailsEvent {
  const SubscriptionRestaurantDetailsEvent();
}

class GetSubscriptionRestaurantDetailsEvent
    extends SubscriptionRestaurantDetailsEvent {
  const GetSubscriptionRestaurantDetailsEvent({
    required this.programId,
    required this.bundleId,
    required this.restaurantId,
  });

  final String programId;
  final String bundleId;
  final String restaurantId;
}
