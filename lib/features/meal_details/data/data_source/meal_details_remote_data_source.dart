import 'package:meal_meat_user/features/meal_details/data/models/response/subscription_meal_details_response_dto.dart';

abstract interface class MealDetailsRemoteDataSource {
  Future<SubscriptionMealDetailsResponseDto> getMealDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
    required String mealId,
  });
}
