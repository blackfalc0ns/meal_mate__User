import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';

abstract interface class MealDetailsRepository {
  Future<ApiResult<SubscriptionMealDetailsEntity>> getMealDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
    required String mealId,
  });
}
