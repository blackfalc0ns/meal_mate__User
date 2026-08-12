import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/get_food_preferences_catalog_usecase.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/get_food_preferences_usecase.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/update_food_preferences_allergies_usecase.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/update_food_preferences_usecase.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_state.dart';

@injectable
class FoodPreferencesViewModel extends Cubit<FoodPreferencesState> {
  FoodPreferencesViewModel(
    this._getFoodPreferencesUseCase,
    this._getFoodPreferencesCatalogUseCase,
    this._updateFoodPreferencesUseCase,
    this._updateFoodPreferencesAllergiesUseCase,
  ) : super(const FoodPreferencesState());

  final GetFoodPreferencesUseCase _getFoodPreferencesUseCase;
  final GetFoodPreferencesCatalogUseCase _getFoodPreferencesCatalogUseCase;
  final UpdateFoodPreferencesUseCase _updateFoodPreferencesUseCase;
  final UpdateFoodPreferencesAllergiesUseCase
  _updateFoodPreferencesAllergiesUseCase;

  void doIntent(FoodPreferencesEvent event) {
    switch (event) {
      case GetFoodPreferencesEvent():
        _getFoodPreferences();
      case GetFoodPreferencesCatalogEvent():
        _getFoodPreferencesCatalog();
      case UpdateFoodPreferencesEvent():
        _updateFoodPreferences(event.preferences);
      case UpdateFoodPreferencesAllergiesEvent():
        _updateFoodPreferencesAllergies(event.allergies);
    }
  }

  Future<void> _getFoodPreferences() async {
    emit(
      state.copyWith(
        preferences: state.preferences.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getFoodPreferencesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            preferences: state.preferences.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            preferences: state.preferences.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getFoodPreferencesCatalog() async {
    emit(
      state.copyWith(
        catalog: state.catalog.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getFoodPreferencesCatalogUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            catalog: state.catalog.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            catalog: state.catalog.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _updateFoodPreferences(FoodPreferencesEntity preferences) async {
    await _runAction(() => _updateFoodPreferencesUseCase(preferences));

    if (state.action.isSuccess) {
      _getFoodPreferences();
    }
  }

  Future<void> _updateFoodPreferencesAllergies(
    List<FoodPreferenceItemEntity> allergies,
  ) async {
    await _runAction(() => _updateFoodPreferencesAllergiesUseCase(allergies));
    if (state.action.isSuccess) {
      _getFoodPreferences();
    }
  }

  Future<void> _runAction(Future<ApiResult<void>> Function() action) async {
    emit(
      state.copyWith(
        action: state.action.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await action();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(isLoading: false, isSuccess: true),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }
}
