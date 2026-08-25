import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/meal_details/data/data_source/meal_details_remote_data_source.dart';
import 'package:meal_meat_user/features/meal_details/data/mapper/subscription_meal_details_mapper.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/repo/meal_details_repository.dart';

@Injectable(as: MealDetailsRepository)
class MealDetailsRepositoryImpl implements MealDetailsRepository {
  MealDetailsRepositoryImpl(this._remoteDataSource);

  final MealDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<SubscriptionMealDetailsEntity>> getMealDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
    required String mealId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getMealDetails(
        programId: programId,
        bundleId: bundleId,
        restaurantId: restaurantId,
        mealId: mealId,
      );
      return response.toEntity();
    });
  }
}
