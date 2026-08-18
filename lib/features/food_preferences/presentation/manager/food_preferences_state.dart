import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

class FoodPreferencesState {
  const FoodPreferencesState({
    this.preferences = const FoodPreferencesDataState(),
    this.catalog = const FoodPreferencesCatalogState(),
    this.action = const FoodPreferencesActionState(),
    this.selection = const FoodPreferencesSelectionState(),
  });

  final FoodPreferencesDataState preferences;
  final FoodPreferencesCatalogState catalog;
  final FoodPreferencesActionState action;
  final FoodPreferencesSelectionState selection;

  FoodPreferencesState copyWith({
    FoodPreferencesDataState? preferences,
    FoodPreferencesCatalogState? catalog,
    FoodPreferencesActionState? action,
    FoodPreferencesSelectionState? selection,
  }) {
    return FoodPreferencesState(
      preferences: preferences ?? this.preferences,
      catalog: catalog ?? this.catalog,
      action: action ?? this.action,
      selection: selection ?? this.selection,
    );
  }
}

class FoodPreferencesSelectionState {
  const FoodPreferencesSelectionState({
    this.dietaryPreferences = const <String>{},
    this.dislikedFoods = const <String>{},
    this.allergies = const <String>{},
    this.notes,
    this.allergySearchQuery = '',
  });

  final Set<String> dietaryPreferences;
  final Set<String> dislikedFoods;
  final Set<String> allergies;
  final String? notes;
  final String allergySearchQuery;

  Set<String> get activeDietaryPreferences =>
      _activeSelections(dietaryPreferences);

  Set<String> get activeDislikedFoods => _activeSelections(dislikedFoods);

  Set<String> get activeAllergies => _activeSelections(allergies);

  FoodPreferencesSelectionState copyWith({
    Set<String>? dietaryPreferences,
    Set<String>? dislikedFoods,
    Set<String>? allergies,
    String? notes,
    String? allergySearchQuery,
  }) {
    return FoodPreferencesSelectionState(
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      dislikedFoods: dislikedFoods ?? this.dislikedFoods,
      allergies: allergies ?? this.allergies,
      notes: notes ?? this.notes,
      allergySearchQuery: allergySearchQuery ?? this.allergySearchQuery,
    );
  }

  Set<String> _activeSelections(Set<String> codes) {
    return codes
        .where((code) => code != FoodPreferenceItemEntity.noneCode)
        .toSet();
  }
}

class FoodPreferencesDataState {
  const FoodPreferencesDataState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final FoodPreferencesEntity? data;
  final Failure? failure;

  FoodPreferencesDataState copyWith({
    bool? isLoading,
    bool? isSuccess,
    FoodPreferencesEntity? data,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FoodPreferencesDataState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class FoodPreferencesCatalogState {
  const FoodPreferencesCatalogState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final FoodPreferencesCatalogEntity? data;
  final Failure? failure;

  FoodPreferencesCatalogState copyWith({
    bool? isLoading,
    bool? isSuccess,
    FoodPreferencesCatalogEntity? data,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FoodPreferencesCatalogState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class FoodPreferencesActionState {
  const FoodPreferencesActionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Failure? failure;

  FoodPreferencesActionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return FoodPreferencesActionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
