import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';

class FamilyAllergiesState {
  const FamilyAllergiesState({
    this.isLoading = false,
    this.isSaving = false,
    this.members = const [],
    this.catalog = const [],
    this.ingredients = const [],
    this.currentIndex = 0,
    this.selectedCodes = const {},
    this.errorMessage,
    this.optionalSaveErrorMessage,
    this.failure,
    this.saveFailure,
    this.completed = false,
    this.allergySearch = '',
    this.ingredientSearch = '',
    this.rejectedCodes = const {},
  });

  final bool isLoading;
  final bool isSaving;
  final List<FamilyMemberEntity> members;
  final List<FoodPreferenceCatalogItemEntity> catalog;
  final List<FoodPreferenceCatalogItemEntity> ingredients;
  final int currentIndex;
  final Set<String> selectedCodes;
  final String? errorMessage;
  final String? optionalSaveErrorMessage;
  final Failure? failure;
  final Failure? saveFailure;
  final bool completed;
  final String allergySearch;
  final String ingredientSearch;
  final Set<String> rejectedCodes;

  FamilyMemberEntity? get currentMember =>
      members.isEmpty ? null : members[currentIndex];
  bool get canSave => selectedCodes.isNotEmpty && !isSaving;

  FamilyAllergiesState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<FamilyMemberEntity>? members,
    List<FoodPreferenceCatalogItemEntity>? catalog,
    List<FoodPreferenceCatalogItemEntity>? ingredients,
    int? currentIndex,
    Set<String>? selectedCodes,
    String? errorMessage,
    String? optionalSaveErrorMessage,
    Failure? failure,
    Failure? saveFailure,
    bool clearError = false,
    bool clearOptionalSaveError = false,
    bool clearFailure = false,
    bool clearSaveFailure = false,
    bool? completed,
    String? allergySearch,
    String? ingredientSearch,
    Set<String>? rejectedCodes,
  }) => FamilyAllergiesState(
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    members: members ?? this.members,
    catalog: catalog ?? this.catalog,
    ingredients: ingredients ?? this.ingredients,
    currentIndex: currentIndex ?? this.currentIndex,
    selectedCodes: selectedCodes ?? this.selectedCodes,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    optionalSaveErrorMessage: clearOptionalSaveError
        ? null
        : optionalSaveErrorMessage ?? this.optionalSaveErrorMessage,
    failure: clearFailure ? null : (failure ?? this.failure),
    saveFailure: clearSaveFailure ? null : (saveFailure ?? this.saveFailure),
    completed: completed ?? this.completed,
    allergySearch: allergySearch ?? this.allergySearch,
    ingredientSearch: ingredientSearch ?? this.ingredientSearch,
    rejectedCodes: rejectedCodes ?? this.rejectedCodes,
  );
}
