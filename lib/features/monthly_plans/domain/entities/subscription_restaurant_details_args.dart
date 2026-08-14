class SubscriptionRestaurantDetailsArgs {
  const SubscriptionRestaurantDetailsArgs({
    required this.programId,
    required this.bundleId,
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantLogoUrl,
    this.restaurantInitials,
    this.restaurantRating,
  });

  final String programId;
  final String bundleId;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantLogoUrl;
  final String? restaurantInitials;
  final String? restaurantRating;
}
