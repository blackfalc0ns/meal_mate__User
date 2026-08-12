import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_catalog_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';

abstract interface class FoodPreferencesRemoteDataSource {
  Future<FoodPreferencesResponseDto> getFoodPreferences();

  Future<FoodPreferencesCatalogResponseDto> getFoodPreferencesCatalog();

  Future<void> updateFoodPreferences(FoodPreferencesRequestDto request);
}
