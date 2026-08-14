import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';

@injectable
class GetSubscriptionRestaurantDetailsUseCase {
  GetSubscriptionRestaurantDetailsUseCase(this._repository);

  final SubscriptionPlanRepository _repository;

  Future<ApiResult<SubscriptionRestaurantDetailsEntity>> call({
    required String programId,
    required String bundleId,
    required String restaurantId,
  }) {
    return _repository.getRestaurantDetails(
      programId: programId,
      bundleId: bundleId,
      restaurantId: restaurantId,
    );
  }
}
