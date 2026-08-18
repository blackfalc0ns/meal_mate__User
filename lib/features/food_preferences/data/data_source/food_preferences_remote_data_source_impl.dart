import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/food_preferences/data/data_source/food_preferences_remote_data_source.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';

@Injectable(as: FoodPreferencesRemoteDataSource)
class FoodPreferencesRemoteDataSourceImpl
    implements FoodPreferencesRemoteDataSource {
  FoodPreferencesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<FoodPreferencesResponseDto> getFoodPreferencesDislikedIngredients({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _apiServices.getFoodPreferencesDislikedIngredients(
      page,
      pageSize,
      search,
    );
  }

  @override
  Future<FoodPreferencesResponseDto> getFoodPreferencesAllergies({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _apiServices.getFoodPreferencesAllergies(page, pageSize, search);
  }

  @override
  Future<FoodPreferencesResponseDto> getFoodPreferencesDietary({
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _apiServices.getFoodPreferencesDietary(page, pageSize, search);
  }

  @override
  Future<FoodPreferencesResponseDto> updateFoodPreferencesDislikedIngredients(
    FoodPreferencesDislikedIngredientsRequestDto request,
  ) {
    return _apiServices.updateFoodPreferencesDislikedIngredients(request);
  }

  @override
  Future<FoodPreferencesResponseDto> updateFoodPreferencesAllergies(
    FoodPreferencesAllergiesRequestDto request,
  ) {
    return _apiServices.updateFoodPreferencesAllergies(request);
  }

  @override
  Future<FoodPreferencesResponseDto> updateFoodPreferencesDietary(
    FoodPreferencesDietaryRequestDto request,
  ) {
    return _apiServices.updateFoodPreferencesDietary(request);
  }
}
