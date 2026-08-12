import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/repo/food_preferences_repository.dart';

@injectable
class UpdateFoodPreferencesAllergiesUseCase {
  UpdateFoodPreferencesAllergiesUseCase(this._repository);

  final FoodPreferencesRepository _repository;

  Future<ApiResult<void>> call(List<FoodPreferenceItemEntity> allergies) {
    return _repository.updateFoodPreferencesAllergies(allergies);
  }
}
