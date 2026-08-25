class SubscriptionMealDetailsArgs {
  const SubscriptionMealDetailsArgs({
    required this.programId,
    required this.bundleId,
    required this.restaurantId,
    required this.mealId,
    this.restaurantInitials,
    this.restaurantRating,
  });

  final String programId;
  final String bundleId;
  final String restaurantId;
  final String mealId;
  final String? restaurantInitials;
  final String? restaurantRating;
}
