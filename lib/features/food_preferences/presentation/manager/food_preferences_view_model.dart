import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
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
      case ToggleDietaryPreferenceEvent():
        _toggleDietaryPreference(event.code);
      case ToggleDislikedFoodEvent():
        _toggleDislikedFood(event.code);
      case ToggleAllergyPreferenceEvent():
        _toggleAllergyPreference(event.code);
      case FoodPreferenceNotesChangedEvent():
        _changeNotes(event.notes);
      case FoodPreferenceAllergySearchChangedEvent():
        _changeAllergySearchQuery(event.query);
      case SaveFoodPreferencesEvent():
        _updateFoodPreferences();
      case SaveFoodPreferencesAllergiesEvent():
        _updateFoodPreferencesAllergies();
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
        final selection = _selectionFromPreferences(result.data);
        emit(
          state.copyWith(
            preferences: state.preferences.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
            selection: selection,
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

  Future<void> _updateFoodPreferences() async {
    final catalog = state.catalog.data;
    if (catalog == null) return;

    await _runAction(
      () => _updateFoodPreferencesUseCase(_buildPreferencesEntity(catalog)),
    );

    if (state.action.isSuccess) {
      _getFoodPreferences();
    }
  }

  Future<void> _updateFoodPreferencesAllergies() async {
    final catalog = state.catalog.data;
    if (catalog == null) return;

    await _runAction(
      () => _updateFoodPreferencesAllergiesUseCase(
        _selectedCatalogItems(
          selectedCodes: state.selection.allergies,
          catalogItems: catalog.allergens,
        ),
      ),
    );
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

  void _toggleDietaryPreference(String code) {
    emit(
      state.copyWith(
        selection: state.selection.copyWith(
          dietaryPreferences: _toggleSelection(
            state.selection.dietaryPreferences,
            code,
          ),
        ),
      ),
    );
  }

  void _toggleDislikedFood(String code) {
    emit(
      state.copyWith(
        selection: state.selection.copyWith(
          dislikedFoods: _toggleSelection(state.selection.dislikedFoods, code),
        ),
      ),
    );
  }

  void _toggleAllergyPreference(String code) {
    emit(
      state.copyWith(
        selection: state.selection.copyWith(
          allergies: _toggleSelection(state.selection.allergies, code),
        ),
      ),
    );
  }

  void _changeNotes(String notes) {
    if (state.selection.notes == notes) return;
    emit(state.copyWith(selection: state.selection.copyWith(notes: notes)));
  }

  void _changeAllergySearchQuery(String query) {
    if (state.selection.allergySearchQuery == query) return;
    emit(
      state.copyWith(
        selection: state.selection.copyWith(allergySearchQuery: query),
      ),
    );
  }

  FoodPreferencesSelectionState _selectionFromPreferences(
    FoodPreferencesEntity preferences,
  ) {
    return state.selection.copyWith(
      dietaryPreferences: _selectedCodesOrNone(preferences.dietaryPreferences),
      dislikedFoods: _selectedCodesOrNone(preferences.dislikedFoods),
      allergies: _selectedCodesOrNone(preferences.allergies),
      notes: preferences.notes,
    );
  }

  FoodPreferencesEntity _buildPreferencesEntity(
    FoodPreferencesCatalogEntity catalog,
  ) {
    final selectedDiets = state.selection.activeDietaryPreferences.toList();

    return FoodPreferencesEntity(
      dietaryPattern: selectedDiets.isEmpty ? null : selectedDiets.first,
      dietaryPreferences: _selectedCatalogItems(
        selectedCodes: state.selection.dietaryPreferences,
        catalogItems: catalog.dietaryPreferences,
      ),
      allergies: _selectedCatalogItems(
        selectedCodes: state.selection.allergies,
        catalogItems: catalog.allergens,
      ),
      dislikedFoods: _selectedCatalogItems(
        selectedCodes: state.selection.activeDislikedFoods,
        catalogItems: catalog.ingredients,
      ),
      notes: state.selection.notes,
    );
  }

  List<FoodPreferenceItemEntity> _selectedCatalogItems({
    required Set<String> selectedCodes,
    required List<FoodPreferenceCatalogItemEntity> catalogItems,
  }) {
    final itemsByCode = {for (final item in catalogItems) item.code: item};

    return selectedCodes
        .map(
          (code) =>
              itemsByCode[code] ??
              (code == FoodPreferenceItemEntity.noneCode
                  ? const FoodPreferenceCatalogItemEntity(
                      code: FoodPreferenceItemEntity.noneCode,
                      nameAr: '',
                      nameEn: '',
                    )
                  : null),
        )
        .nonNulls
        .map(
          (item) => FoodPreferenceItemEntity(
            code: item.code,
            nameAr: item.nameAr,
            nameEn: item.nameEn,
          ),
        )
        .toList();
  }

  Set<String> _selectedCodesOrNone(List<FoodPreferenceItemEntity> items) {
    final codes = items
        .map((item) => item.code)
        .where(
          (code) =>
              code.isNotEmpty && code != FoodPreferenceItemEntity.noneCode,
        )
        .toSet();

    return codes.isEmpty
        ? const <String>{FoodPreferenceItemEntity.noneCode}
        : codes;
  }

  Set<String> _toggleSelection(Set<String> values, String code) {
    if (code == FoodPreferenceItemEntity.noneCode) {
      return const <String>{FoodPreferenceItemEntity.noneCode};
    }

    final updated = Set<String>.of(values)
      ..remove(FoodPreferenceItemEntity.noneCode);

    if (updated.contains(code)) {
      updated.remove(code);
    } else {
      updated.add(code);
    }

    return updated.isEmpty
        ? const <String>{FoodPreferenceItemEntity.noneCode}
        : updated;
  }
}
