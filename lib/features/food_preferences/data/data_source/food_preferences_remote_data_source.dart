import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';

abstract interface class FoodPreferencesRemoteDataSource {
  Future<FoodPreferencesResponseDto> getFoodPreferencesDislikedIngredients({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<FoodPreferencesResponseDto> getFoodPreferencesAllergies({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<FoodPreferencesResponseDto> getFoodPreferencesDietary({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<FoodPreferencesResponseDto> updateFoodPreferencesDislikedIngredients(
    FoodPreferencesDislikedIngredientsRequestDto request,
  );

  Future<FoodPreferencesResponseDto> updateFoodPreferencesAllergies(
    FoodPreferencesAllergiesRequestDto request,
  );

  Future<FoodPreferencesResponseDto> updateFoodPreferencesDietary(
    FoodPreferencesDietaryRequestDto request,
  );
}
