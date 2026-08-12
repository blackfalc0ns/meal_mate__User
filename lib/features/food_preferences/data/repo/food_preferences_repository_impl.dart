import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/data/data_source/food_preferences_remote_data_source.dart';
import 'package:meal_meat_user/features/food_preferences/data/mapper/food_preferences_mapper.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/repo/food_preferences_repository.dart';

@Injectable(as: FoodPreferencesRepository)
class FoodPreferencesRepositoryImpl implements FoodPreferencesRepository {
  FoodPreferencesRepositoryImpl(this._remoteDataSource);

  final FoodPreferencesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FoodPreferencesEntity>> getFoodPreferences() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFoodPreferences();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FoodPreferencesCatalogEntity>> getFoodPreferencesCatalog() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFoodPreferencesCatalog();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> updateFoodPreferences(
    FoodPreferencesEntity preferences,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateFoodPreferences(preferences.toDto());
    });
  }

  @override
  Future<ApiResult<void>> updateFoodPreferencesAllergies(
    List<FoodPreferenceItemEntity> allergies,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateFoodPreferencesAllergies(
        allergies.toAllergiesDto(),
      );
    });
  }
}
