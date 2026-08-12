import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

abstract interface class FoodPreferencesRepository {
  Future<ApiResult<FoodPreferencesEntity>> getFoodPreferences();

  Future<ApiResult<void>> updateFoodPreferences(
    FoodPreferencesEntity preferences,
  );
}
