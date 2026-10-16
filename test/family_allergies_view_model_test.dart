import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';
import 'package:meal_meat_user/features/family_allergies/domain/repo/family_allergies_repository.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_allergies_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/domain/usecase/save_family_member_disliked_ingredients_usecase.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_view_model.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/repo/food_preferences_repository.dart';
import 'package:meal_meat_user/features/food_preferences/domain/usecase/get_food_preferences_catalog_usecase.dart';

void main() {
  test('debounces allergy search updates', () async {
    final viewModel = FamilyAllergiesViewModel(
      GetFamilyFlowCurrentUseCase(_FamilySubscriptionSetupRepository()),
      GetFoodPreferencesCatalogUseCase(const _FoodPreferencesRepository()),
      SaveFamilyMemberAllergiesUseCase(_FamilyAllergiesRepository()),
      SaveFamilyMemberDislikedIngredientsUseCase(_FamilyAllergiesRepository()),
    );
    addTearDown(viewModel.close);

    await viewModel.load();
    viewModel.doIntent(const ChangeAllergySearchEvent('mi'));

    expect(viewModel.state.allergySearch, isEmpty);
    await Future<void>.delayed(const Duration(milliseconds: 350));

    expect(viewModel.state.allergySearch, 'mi');
  });

  test('routes toggle allergy through doIntent', () async {
    final viewModel = FamilyAllergiesViewModel(
      GetFamilyFlowCurrentUseCase(_FamilySubscriptionSetupRepository()),
      GetFoodPreferencesCatalogUseCase(const _FoodPreferencesRepository()),
      SaveFamilyMemberAllergiesUseCase(_FamilyAllergiesRepository()),
      SaveFamilyMemberDislikedIngredientsUseCase(_FamilyAllergiesRepository()),
    );
    addTearDown(viewModel.close);

    await viewModel.load();
    viewModel.doIntent(const ToggleFamilyAllergyEvent('MILK'));

    expect(viewModel.state.selectedCodes, contains('MILK'));
  });

  test('NONE is sent as the selected allergy code', () {
    const request = FamilyMemberAllergiesRequestDto(
      allergies: [FamilyMemberAllergyRequestDto(code: 'NONE')],
    );
    expect(request.toJson(), {
      'selectedCodes': ['NONE'],
    });
  });
  test(
    'saves disliked ingredients without making them checkout required',
    () async {
      final repository = _FamilyAllergiesRepository();
      final viewModel = FamilyAllergiesViewModel(
        GetFamilyFlowCurrentUseCase(_FamilySubscriptionSetupRepository()),
        GetFoodPreferencesCatalogUseCase(const _FoodPreferencesRepository()),
        SaveFamilyMemberAllergiesUseCase(repository),
        SaveFamilyMemberDislikedIngredientsUseCase(repository),
      );
      addTearDown(viewModel.close);

      await viewModel.load();
      viewModel.toggle('NONE');
      viewModel.toggleRejected('INGREDIENT:avocado');
      await viewModel.saveCurrent();

      expect(repository.savedIngredientCodes, ['INGREDIENT:avocado']);
      expect(viewModel.state.completed, isTrue);
    },
  );

  test(
    'failed optional preference save does not block allergy completion',
    () async {
      final repository = _FamilyAllergiesRepository()..failDislikedSave = true;
      final viewModel = FamilyAllergiesViewModel(
        GetFamilyFlowCurrentUseCase(_FamilySubscriptionSetupRepository()),
        GetFoodPreferencesCatalogUseCase(const _FoodPreferencesRepository()),
        SaveFamilyMemberAllergiesUseCase(repository),
        SaveFamilyMemberDislikedIngredientsUseCase(repository),
      );
      addTearDown(viewModel.close);

      await viewModel.load();
      viewModel.toggle('NONE');
      viewModel.toggleRejected('INGREDIENT:avocado');
      await viewModel.saveCurrent();

      expect(viewModel.state.completed, isTrue);
      expect(
        viewModel.state.optionalSaveErrorMessage,
        'Preference save failed',
      );
    },
  );

  test('loads disliked ingredients and tracks their selection', () async {
    final viewModel = FamilyAllergiesViewModel(
      GetFamilyFlowCurrentUseCase(_FamilySubscriptionSetupRepository()),
      GetFoodPreferencesCatalogUseCase(
        const _FoodPreferencesRepository(
          catalog: FoodPreferencesCatalogEntity(
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
      SaveFamilyMemberDislikedIngredientsUseCase(_FamilyAllergiesRepository()),
    );
    addTearDown(viewModel.close);

    await viewModel.load();

    expect(viewModel.state.ingredients.single.code, 'INGREDIENT:avocado');

    viewModel.toggleRejected('INGREDIENT:avocado');
    expect(viewModel.state.rejectedCodes, {'INGREDIENT:avocado'});

    viewModel.changeIngredientSearch('أفو');
    await Future<void>.delayed(const Duration(milliseconds: 350));
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
      GetFoodPreferencesCatalogUseCase(const _FoodPreferencesRepository()),
      SaveFamilyMemberAllergiesUseCase(_FamilyAllergiesRepository()),
      SaveFamilyMemberDislikedIngredientsUseCase(_FamilyAllergiesRepository()),
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
        GetFoodPreferencesCatalogUseCase(const _FoodPreferencesRepository()),
        SaveFamilyMemberAllergiesUseCase(allergiesRepository),
        SaveFamilyMemberDislikedIngredientsUseCase(allergiesRepository),
      );
      addTearDown(viewModel.close);

      await viewModel.load();
      viewModel.toggle('NONE');
      await viewModel.saveCurrent();
      expect(viewModel.state.completed, isTrue);

      viewModel.toggle('NONE');
      viewModel.toggle('NONE');
      allergiesRepository.pauseSave = true;
      final secondSave = viewModel.saveCurrent();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.completed, isFalse);
      expect(viewModel.state.isSaving, isTrue);

      allergiesRepository.pendingSave.complete(
        const ApiSuccessResult(data: true),
      );
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
  Future<ApiResult<List<FoodPreferenceCatalogItemEntity>>>
  searchFoodPreferencesAllergies({
    required int page,
    required int pageSize,
    String? search,
  }) async => ApiSuccessResult(data: catalog.allergens);

  @override
  Future<ApiResult<List<FoodPreferenceCatalogItemEntity>>>
  searchFoodPreferencesIngredients({
    required int page,
    required int pageSize,
    String? search,
  }) async => ApiSuccessResult(data: catalog.ingredients);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FamilyAllergiesRepository implements FamilyAllergiesRepository {
  List<String>? savedIngredientCodes;
  bool failDislikedSave = false;
  bool pauseSave = false;
  final pendingSave = Completer<ApiResult<bool>>();

  @override
  Future<ApiResult<bool>> saveMemberAllergies({
    required String memberId,
    required List<FamilyMemberAllergySelection> allergies,
  }) {
    if (pauseSave) {
      return pendingSave.future;
    }
    return Future.value(const ApiSuccessResult(data: true));
  }

  @override
  Future<ApiResult<void>> saveMemberDislikedIngredients({
    required String memberId,
    required List<String> ingredientCodes,
  }) async {
    savedIngredientCodes = ingredientCodes;
    if (failDislikedSave) {
      return ApiErrorResult<void>(
        failure: Failure(errorMessage: 'Preference save failed'),
      );
    }
    return const ApiSuccessResult<void>(data: null);
  }
}
