import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_allergies/domain/repo/family_allergies_repository.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_allergies_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/repo/food_preferences_repository.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/get_food_preferences_catalog_usecase.dart';

void main() {
  test('loads disliked ingredients and tracks their selection', () async {
    final viewModel = FamilyAllergiesViewModel(
      GetFamilyFlowCurrentUseCase(_FamilySubscriptionSetupRepository()),
      GetFoodPreferencesCatalogUseCase(
        _FoodPreferencesRepository(
          catalog: const FoodPreferencesCatalogEntity(
            ingredients: [
              FoodPreferenceCatalogItemEntity(
                code: 'INGREDIENT:avocado',
                nameAr: 'أفوكادو',
                nameEn: 'Avocado',
              ),
            ],
          ),
        ),
      ),
      SaveFamilyMemberAllergiesUseCase(_FamilyAllergiesRepository()),
    );
    addTearDown(viewModel.close);

    await viewModel.load();

    expect(viewModel.state.ingredients.single.code, 'INGREDIENT:avocado');

    viewModel.toggleRejected('INGREDIENT:avocado');
    expect(viewModel.state.rejectedCodes, {'INGREDIENT:avocado'});

    viewModel.changeIngredientSearch('أفو');
    expect(viewModel.state.ingredientSearch, 'أفو');
  });

  test('loads and restores each member saved allergy selection', () async {
    final viewModel = FamilyAllergiesViewModel(
      GetFamilyFlowCurrentUseCase(
        _FamilySubscriptionSetupRepository(
          members: const [
            FamilyMemberEntity(
              memberId: 'member-1',
              role: 1,
              displayName: 'First',
              relationshipCode: 'SELF',
              gender: 1,
              ageYears: 30,
              setupStatus: 0,
              includeFriday: false,
              isCurrentUser: true,
              allergies: [
                FoodPreferenceItemEntity(
                  code: 'MILK',
                  nameAr: 'حليب',
                  nameEn: 'Milk',
                ),
              ],
              allergiesCompleted: true,
            ),
            FamilyMemberEntity(
              memberId: 'member-2',
              role: 2,
              displayName: 'Second',
              relationshipCode: 'CHILD',
              gender: 2,
              ageYears: 12,
              setupStatus: 0,
              includeFriday: false,
              isCurrentUser: false,
              allergiesCompleted: true,
              hasNoAllergies: true,
            ),
          ],
        ),
      ),
      GetFoodPreferencesCatalogUseCase(_FoodPreferencesRepository()),
      SaveFamilyMemberAllergiesUseCase(_FamilyAllergiesRepository()),
    );
    addTearDown(viewModel.close);

    await viewModel.load();
    expect(viewModel.state.selectedCodes, {'MILK'});

    viewModel.selectMember(1);
    expect(viewModel.state.selectedCodes, {'NONE'});

    viewModel.selectMember(0);
    viewModel.toggle('MILK');
    viewModel.toggle('EGGS');
    await viewModel.saveCurrent();
    expect(viewModel.state.selectedCodes, {'NONE'});

    viewModel.selectMember(0);
    expect(viewModel.state.selectedCodes, {'EGGS'});
  });

  test(
    'saving again resets completion so navigation can trigger again',
    () async {
      final allergiesRepository = _FamilyAllergiesRepository();
      final viewModel = FamilyAllergiesViewModel(
        GetFamilyFlowCurrentUseCase(_FamilySubscriptionSetupRepository()),
        GetFoodPreferencesCatalogUseCase(_FoodPreferencesRepository()),
        SaveFamilyMemberAllergiesUseCase(allergiesRepository),
      );
      addTearDown(viewModel.close);

      await viewModel.load();
      viewModel.toggle('NONE');
      await viewModel.saveCurrent();
      expect(viewModel.state.completed, isTrue);

      viewModel.toggle('NONE');
      viewModel.toggle('NONE');
      final secondSave = viewModel.saveCurrent();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.completed, isFalse);
      expect(viewModel.state.isSaving, isTrue);

      allergiesRepository.pendingSave.complete(ApiSuccessResult(data: true));
      await secondSave;
      expect(viewModel.state.completed, isTrue);
    },
  );
}

class _FamilySubscriptionSetupRepository
    implements FamilySubscriptionSetupRepository {
  _FamilySubscriptionSetupRepository({this.members = const []});

  final List<FamilyMemberEntity> members;

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>>
  getFamilySubscriptionCurrent() async {
    return ApiSuccessResult(
      data: FamilyFlowCurrentEntity(
        members: members.isEmpty
            ? const [
                FamilyMemberEntity(
                  memberId: 'member-1',
                  role: 1,
                  displayName: 'Member',
                  relationshipCode: 'SELF',
                  gender: 1,
                  ageYears: 30,
                  setupStatus: 0,
                  includeFriday: false,
                  isCurrentUser: true,
                ),
              ]
            : members,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FoodPreferencesRepository implements FoodPreferencesRepository {
  const _FoodPreferencesRepository({
    this.catalog = const FoodPreferencesCatalogEntity(),
  });

  final FoodPreferencesCatalogEntity catalog;

  @override
  Future<ApiResult<FoodPreferencesCatalogEntity>>
  getFoodPreferencesCatalog() async {
    return ApiSuccessResult(data: catalog);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FamilyAllergiesRepository implements FamilyAllergiesRepository {
  int _saveCount = 0;
  final pendingSave = Completer<ApiResult<bool>>();

  @override
  Future<ApiResult<bool>> saveMemberAllergies({
    required String memberId,
    required List<FamilyMemberAllergySelection> allergies,
  }) {
    _saveCount++;
    if (_saveCount == 1) {
      return Future.value(ApiSuccessResult(data: true));
    }
    return pendingSave.future;
  }
}
