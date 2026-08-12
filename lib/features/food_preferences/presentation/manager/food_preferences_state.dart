import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

class FoodPreferencesState {
  const FoodPreferencesState({
    this.preferences = const FoodPreferencesDataState(),
    this.catalog = const FoodPreferencesCatalogState(),
    this.action = const FoodPreferencesActionState(),
  });

  final FoodPreferencesDataState preferences;
  final FoodPreferencesCatalogState catalog;
  final FoodPreferencesActionState action;

  FoodPreferencesState copyWith({
    FoodPreferencesDataState? preferences,
    FoodPreferencesCatalogState? catalog,
    FoodPreferencesActionState? action,
  }) {
    return FoodPreferencesState(
      preferences: preferences ?? this.preferences,
      catalog: catalog ?? this.catalog,
      action: action ?? this.action,
    );
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
