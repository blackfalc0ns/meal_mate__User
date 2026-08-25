sealed class MealDetailsEvent {
  const MealDetailsEvent();
}

class GetMealDetailsEvent extends MealDetailsEvent {
  const GetMealDetailsEvent({
    required this.programId,
    required this.bundleId,
    required this.restaurantId,
    required this.mealId,
  });

  final String programId;
  final String bundleId;
  final String restaurantId;
  final String mealId;
}
