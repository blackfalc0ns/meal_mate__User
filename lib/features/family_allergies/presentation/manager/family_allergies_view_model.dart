import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_allergies_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_disliked_ingredients_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
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

  Future<void> load({String? memberId}) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearFailure: true));
    final flowResult = await _getFlow();
    final catalogResult = await _getCatalog();
    if (flowResult is ApiSuccessResult<FamilyFlowCurrentEntity> &&
        catalogResult is ApiSuccessResult<FoodPreferencesCatalogEntity>) {
      final members = memberId == null
          ? flowResult.data.members
          : flowResult.data.members
                .where((member) => member.memberId == memberId)
                .toList();
      emit(
        state.copyWith(
          isLoading: false,
          clearFailure: true,
          members: members,
          catalog: catalogResult.data.allergens,
          ingredients: catalogResult.data.ingredients,
          selectedCodes: members.isEmpty
              ? const {}
              : _savedSelectionFor(members.first),
          rejectedCodes: members.isEmpty
              ? const {}
              : _savedRejectedSelectionFor(members.first),
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
    emit(state.copyWith(allergySearch: value));
  }

  void changeIngredientSearch(String value) {
    emit(state.copyWith(ingredientSearch: value));
  }

  void toggleRejected(String code) {
    final next = <String>{...state.rejectedCodes};
    next.contains(code) ? next.remove(code) : next.add(code);
    emit(state.copyWith(rejectedCodes: next));
  }

  void selectMember(int index) {
    if (state.isSaving || index < 0 || index >= state.members.length) return;
    if (index == state.currentIndex) return;
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
