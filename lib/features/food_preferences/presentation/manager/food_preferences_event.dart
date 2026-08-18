sealed class FoodPreferencesEvent {
  const FoodPreferencesEvent();
}

class GetFoodPreferencesEvent extends FoodPreferencesEvent {
  const GetFoodPreferencesEvent();
}

class GetFoodPreferencesCatalogEvent extends FoodPreferencesEvent {
  const GetFoodPreferencesCatalogEvent();
}

class ToggleDietaryPreferenceEvent extends FoodPreferencesEvent {
  const ToggleDietaryPreferenceEvent(this.code);

  final String code;
}

class ToggleDislikedFoodEvent extends FoodPreferencesEvent {
  const ToggleDislikedFoodEvent(this.code);

  final String code;
}

class ToggleAllergyPreferenceEvent extends FoodPreferencesEvent {
  const ToggleAllergyPreferenceEvent(this.code);

  final String code;
}

class FoodPreferenceNotesChangedEvent extends FoodPreferencesEvent {
  const FoodPreferenceNotesChangedEvent(this.notes);

  final String notes;
}

class FoodPreferenceAllergySearchChangedEvent extends FoodPreferencesEvent {
  const FoodPreferenceAllergySearchChangedEvent(this.query);

  final String query;
}

class SaveFoodPreferencesEvent extends FoodPreferencesEvent {
  const SaveFoodPreferencesEvent();
}

class SaveFoodPreferencesAllergiesEvent extends FoodPreferencesEvent {
  const SaveFoodPreferencesAllergiesEvent();
}
