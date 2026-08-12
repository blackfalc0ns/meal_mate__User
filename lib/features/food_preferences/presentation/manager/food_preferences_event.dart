import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

sealed class FoodPreferencesEvent {
  const FoodPreferencesEvent();
}

class GetFoodPreferencesEvent extends FoodPreferencesEvent {
  const GetFoodPreferencesEvent();
}

class GetFoodPreferencesCatalogEvent extends FoodPreferencesEvent {
  const GetFoodPreferencesCatalogEvent();
}

class UpdateFoodPreferencesEvent extends FoodPreferencesEvent {
  const UpdateFoodPreferencesEvent(this.preferences);

  final FoodPreferencesEntity preferences;
}
