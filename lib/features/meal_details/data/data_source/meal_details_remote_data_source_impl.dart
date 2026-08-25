import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/meal_details/data/data_source/meal_details_remote_data_source.dart';
import 'package:meal_meat_user/features/meal_details/data/models/response/subscription_meal_details_response_dto.dart';

@Injectable(as: MealDetailsRemoteDataSource)
class MealDetailsRemoteDataSourceImpl implements MealDetailsRemoteDataSource {
  MealDetailsRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<SubscriptionMealDetailsResponseDto> getMealDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
    required String mealId,
  }) {
    return _apiServices.getSubscriptionMealDetails(
      programId,
      bundleId,
      restaurantId,
      mealId,
    );
  }
}
