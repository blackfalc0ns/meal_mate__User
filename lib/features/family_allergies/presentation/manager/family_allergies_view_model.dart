import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_allergies_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_disliked_ingredients_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/get_food_preferences_catalog_usecase.dart';

@injectable
class FamilyAllergiesViewModel extends Cubit<FamilyAllergiesState> {
  FamilyAllergiesViewModel(
    this._getFlow,
    this._getCatalog,
    this._save,
    this._saveDisliked,
  ) : super(const FamilyAllergiesState());

  final GetFamilyFlowCurrentUseCase _getFlow;
  final GetFoodPreferencesCatalogUseCase _getCatalog;
  final SaveFamilyMemberAllergiesUseCase _save;
  final SaveFamilyMemberDislikedIngredientsUseCase _saveDisliked;
  final Map<String, Timer> _searchTimers = {};
  int _activeLoadId = 0;

  void doIntent(FamilyAllergiesEvent event) {
    switch (event) {
      case LoadFamilyAllergiesEvent():
        unawaited(load(memberId: event.memberId));
      case ToggleFamilyAllergyEvent():
        toggle(event.code);
      case ToggleRejectedIngredientEvent():
        toggleRejected(event.code);
      case ChangeAllergySearchEvent():
        changeAllergySearch(event.value);
      case ChangeIngredientSearchEvent():
        changeIngredientSearch(event.value);
      case SelectFamilyAllergyMemberEvent():
        selectMember(event.index);
      case SaveCurrentFamilyAllergiesEvent():
        unawaited(saveCurrent());
    }
  }

  @override
  Future<void> close() {
    for (final timer in _searchTimers.values) {
      timer.cancel();
    }
    _searchTimers.clear();
    return super.close();
  }

  Future<void> load({String? memberId}) async {
    final reqId = ++_activeLoadId;
    emit(state.copyWith(isLoading: true, clearError: true, clearFailure: true));
    final flowResult = await _getFlow();
    final catalogResult = await _getCatalog();
    if (isClosed || reqId != _activeLoadId) return;
    if (flowResult is ApiSuccessResult<FamilyFlowCurrentEntity> &&
        catalogResult is ApiSuccessResult<FoodPreferencesCatalogEntity>) {
      final members = flowResult.data.members;
      final targetIndex = memberId != null
          ? members.indexWhere((m) => m.memberId == memberId)
          : -1;
      final initialIndex = targetIndex >= 0 ? targetIndex : 0;
      final currentMember = members.isNotEmpty ? members[initialIndex] : null;
      emit(
        state.copyWith(
          isLoading: false,
          clearFailure: true,
          members: members,
          currentIndex: initialIndex,
          catalog: catalogResult.data.allergens,
          ingredients: catalogResult.data.ingredients,
          selectedCodes: currentMember != null
              ? _savedSelectionFor(currentMember)
              : const {},
          rejectedCodes: currentMember != null
              ? _savedRejectedSelectionFor(currentMember)
              : const {},
          completed: members.isEmpty,
        ),
      );
      return;
    }
    final failure = flowResult is ApiErrorResult<FamilyFlowCurrentEntity>
        ? flowResult.failure
        : (catalogResult as ApiErrorResult<FoodPreferencesCatalogEntity>)
              .failure;
    emit(
      state.copyWith(
        isLoading: false,
        failure: failure,
        errorMessage: failure.errorMessage,
      ),
    );
  }

  void toggle(String code) {
    final next = <String>{...state.selectedCodes};
    if (code == 'NONE') {
      next
        ..clear()
        ..add('NONE');
    } else {
      next.remove('NONE');
      next.contains(code) ? next.remove(code) : next.add(code);
    }
    emit(state.copyWith(selectedCodes: next, clearError: true));
  }

  void changeAllergySearch(String value) {
    _debounceSearch('allergy', value, (query) {
      emit(state.copyWith(allergySearch: query));
      unawaited(_searchAllergies(query));
    });
  }

  void changeIngredientSearch(String value) {
    _debounceSearch('ingredient', value, (query) {
      emit(state.copyWith(ingredientSearch: query));
      unawaited(_searchIngredients(query));
    });
  }

  Future<void> _searchAllergies(String query) async {
    final result = await _getCatalog.searchAllergies(
      page: 1,
      pageSize: 50,
      search: query.trim().isEmpty ? null : query.trim(),
    );
    if (isClosed) return;
    if (result case ApiSuccessResult(data: final items)) {
      emit(state.copyWith(catalog: items));
    }
  }

  Future<void> _searchIngredients(String query) async {
    final result = await _getCatalog.searchIngredients(
      page: 1,
      pageSize: 50,
      search: query.trim().isEmpty ? null : query.trim(),
    );
    if (isClosed) return;
    if (result case ApiSuccessResult(data: final items)) {
      emit(state.copyWith(ingredients: items));
    }
  }

  void _debounceSearch(
    String key,
    String value,
    void Function(String value) apply,
  ) {
    _searchTimers[key]?.cancel();
    _searchTimers[key] = Timer(const Duration(milliseconds: 300), () {
      if (!isClosed) apply(value);
    });
  }

  void toggleRejected(String code) {
    final next = <String>{...state.rejectedCodes};
    next.contains(code) ? next.remove(code) : next.add(code);
    emit(state.copyWith(rejectedCodes: next));
  }

  void selectMember(int index) {
    if (state.isSaving || index < 0 || index >= state.members.length) return;
    if (index == state.currentIndex) return;
    for (final timer in _searchTimers.values) {
      timer.cancel();
    }
    _searchTimers.clear();
    emit(
      state.copyWith(
        currentIndex: index,
        selectedCodes: _savedSelectionFor(state.members[index]),
        rejectedCodes: _savedRejectedSelectionFor(state.members[index]),
        allergySearch: '',
        ingredientSearch: '',
        clearError: true,
      ),
    );
  }

  Future<void> saveCurrent() async {
    final member = state.currentMember;
    if (member == null || !state.canSave) return;
    final savedCodes = Set<String>.of(state.selectedCodes);
    emit(
      state.copyWith(
        isSaving: true,
        completed: false,
        clearError: true,
        clearOptionalSaveError: true,
        clearSaveFailure: true,
      ),
    );
    final result = await _save(
      memberId: member.memberId,
      allergies: state.selectedCodes
          .map(
            (code) => FamilyMemberAllergySelection(
              code: code,
              severity: code == 'NONE' ? null : 'High',
            ),
          )
          .toList(),
    );
    switch (result) {
      case ApiSuccessResult(data: final saved) when saved:
        String? optionalSaveErrorMessage;
        Failure? optionalSaveFailure;
        final savedRejectedCodes = _savedRejectedSelectionFor(member);
        if (savedRejectedCodes.length != state.rejectedCodes.length ||
            !savedRejectedCodes.containsAll(state.rejectedCodes)) {
          final dislikedResult = await _saveDisliked(
            memberId: member.memberId,
            ingredientCodes: state.rejectedCodes.toList(),
          );
          if (dislikedResult case ApiErrorResult(:final failure)) {
            optionalSaveErrorMessage = failure.errorMessage;
            optionalSaveFailure = failure;
          }
        }
        final last = state.currentIndex == state.members.length - 1;
        final updatedMembers = [...state.members];
        updatedMembers[state.currentIndex] = member.copyWith(
          allergies: savedCodes
              .where((code) => code != FoodPreferenceItemEntity.noneCode)
              .map((code) {
                final catalogItem = state.catalog.where(
                  (item) => item.code == code,
                );
                final match = catalogItem.isEmpty ? null : catalogItem.first;
                return FoodPreferenceItemEntity(
                  code: code,
                  nameAr: match?.nameAr ?? '',
                  nameEn: match?.nameEn ?? '',
                  severity: 'High',
                );
              })
              .toList(),
          allergiesCompleted: true,
          hasNoAllergies: savedCodes.contains(
            FoodPreferenceItemEntity.noneCode,
          ),
          dislikedFoods: optionalSaveErrorMessage == null
              ? state.rejectedCodes.map((code) {
                  final match = state.ingredients
                      .where((item) => item.code == code)
                      .firstOrNull;
                  return FoodPreferenceItemEntity(
                    code: code,
                    nameAr: match?.nameAr ?? '',
                    nameEn: match?.nameEn ?? '',
                  );
                }).toList()
              : member.dislikedFoods,
        );
        final nextIndex = last ? state.currentIndex : state.currentIndex + 1;
        emit(
          state.copyWith(
            isSaving: false,
            completed: last,
            optionalSaveErrorMessage: optionalSaveErrorMessage,
            errorMessage: optionalSaveErrorMessage,
            saveFailure: optionalSaveFailure,
            members: updatedMembers,
            currentIndex: nextIndex,
            selectedCodes: last
                ? savedCodes
                : _savedSelectionFor(updatedMembers[nextIndex]),
            allergySearch: '',
            ingredientSearch: '',
            rejectedCodes: last
                ? state.rejectedCodes
                : _savedRejectedSelectionFor(updatedMembers[nextIndex]),
          ),
        );
      case ApiSuccessResult():
        emit(state.copyWith(isSaving: false, errorMessage: 'error_unknown'));
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSaving: false,
            saveFailure: result.failure,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Set<String> _savedSelectionFor(FamilyMemberEntity member) {
    if (member.hasNoAllergies) return const {'NONE'};
    return member.allergies.map((allergy) => allergy.code).toSet();
  }

  Set<String> _savedRejectedSelectionFor(FamilyMemberEntity member) {
    return member.dislikedFoods.map((ingredient) => ingredient.code).toSet();
  }
}
