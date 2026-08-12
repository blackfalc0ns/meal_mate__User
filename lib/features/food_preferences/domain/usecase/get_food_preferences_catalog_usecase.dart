import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/repo/food_preferences_repository.dart';

@injectable
class GetFoodPreferencesCatalogUseCase {
  GetFoodPreferencesCatalogUseCase(this._repository);

  final FoodPreferencesRepository _repository;

  Future<ApiResult<FoodPreferencesCatalogEntity>> call() {
    return _repository.getFoodPreferencesCatalog();
  }
}
