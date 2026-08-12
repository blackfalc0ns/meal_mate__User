import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/food_preferences/data/data_source/food_preferences_remote_data_source.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_catalog_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';

@Injectable(as: FoodPreferencesRemoteDataSource)
class FoodPreferencesRemoteDataSourceImpl
    implements FoodPreferencesRemoteDataSource {
  FoodPreferencesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<FoodPreferencesResponseDto> getFoodPreferences() {
    return _apiServices.getFoodPreferences();
  }

  @override
  Future<FoodPreferencesCatalogResponseDto> getFoodPreferencesCatalog() {
    return _apiServices.getFoodPreferencesCatalog();
  }

  @override
  Future<void> updateFoodPreferences(FoodPreferencesRequestDto request) {
    return _apiServices.updateFoodPreferences(request);
  }

  @override
  Future<void> updateFoodPreferencesAllergies(
    FoodPreferencesAllergiesRequestDto request,
  ) {
    return _apiServices.updateFoodPreferencesAllergies(request);
  }
}
