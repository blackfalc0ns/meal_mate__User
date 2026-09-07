import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_allergies_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/get_food_preferences_catalog_usecase.dart';

@injectable
class FamilyAllergiesViewModel extends Cubit<FamilyAllergiesState> {
  FamilyAllergiesViewModel(this._getFlow, this._getCatalog, this._save)
    : super(const FamilyAllergiesState());

  final GetFamilyFlowCurrentUseCase _getFlow;
  final GetFoodPreferencesCatalogUseCase _getCatalog;
  final SaveFamilyMemberAllergiesUseCase _save;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final flowResult = await _getFlow();
    final catalogResult = await _getCatalog();
    if (flowResult is ApiSuccessResult<FamilyFlowCurrentEntity> &&
        catalogResult is ApiSuccessResult<FoodPreferencesCatalogEntity>) {
      final members = flowResult.data.members
          .where((member) => member.isInCheckoutBasket)
          .toList();
      emit(
        state.copyWith(
          isLoading: false,
          members: members,
          catalog: catalogResult.data.allergens,
          ingredients: catalogResult.data.ingredients,
          completed: members.isEmpty,
        ),
      );
      return;
    }
    final failure = flowResult is ApiErrorResult<FamilyFlowCurrentEntity>
        ? flowResult.failure
        : (catalogResult as ApiErrorResult<FoodPreferencesCatalogEntity>)
              .failure;
    emit(state.copyWith(isLoading: false, errorMessage: failure.errorMessage));
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

  Future<void> saveCurrent() async {
    final member = state.currentMember;
    if (member == null || !state.canSave) return;
    emit(state.copyWith(isSaving: true, clearError: true));
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
        final last = state.currentIndex == state.members.length - 1;
        emit(
          state.copyWith(
            isSaving: false,
            completed: last,
            currentIndex: last ? state.currentIndex : state.currentIndex + 1,
            selectedCodes: const {},
            allergySearch: '',
            ingredientSearch: '',
            rejectedCodes: const {},
          ),
        );
      case ApiSuccessResult():
        emit(state.copyWith(isSaving: false, errorMessage: 'error_unknown'));
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSaving: false,
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }
}
