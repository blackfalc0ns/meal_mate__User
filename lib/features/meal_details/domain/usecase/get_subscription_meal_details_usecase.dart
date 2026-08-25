import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/repo/meal_details_repository.dart';

@injectable
class GetSubscriptionMealDetailsUseCase {
  GetSubscriptionMealDetailsUseCase(this._repository);

  final MealDetailsRepository _repository;

  Future<ApiResult<SubscriptionMealDetailsEntity>> call({
    required String programId,
    required String bundleId,
    required String restaurantId,
    required String mealId,
  }) {
    return _repository.getMealDetails(
      programId: programId,
      bundleId: bundleId,
      restaurantId: restaurantId,
      mealId: mealId,
    );
  }
}
