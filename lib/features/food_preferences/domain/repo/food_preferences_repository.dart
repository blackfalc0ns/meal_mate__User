import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

abstract interface class FoodPreferencesRepository {
  Future<ApiResult<FoodPreferencesEntity>> getFoodPreferences();

  Future<ApiResult<FoodPreferencesCatalogEntity>> getFoodPreferencesCatalog();

  Future<ApiResult<List<FoodPreferenceCatalogItemEntity>>>
  searchFoodPreferencesAllergies({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<ApiResult<List<FoodPreferenceCatalogItemEntity>>>
  searchFoodPreferencesIngredients({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<ApiResult<void>> updateFoodPreferences(
    FoodPreferencesEntity preferences,
  );

  Future<ApiResult<void>> updateFoodPreferencesAllergies(
    List<FoodPreferenceItemEntity> allergies,
  );
}
