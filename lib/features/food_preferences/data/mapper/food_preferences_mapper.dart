import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_catalog_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

extension FoodPreferencesResponseDtoMapper on FoodPreferencesResponseDto {
  FoodPreferencesEntity toEntity() {
    return FoodPreferencesEntity(
      dietaryPattern: dietaryPattern,
      dietaryPreferences: _selectedItems(
        dietaryPreferences,
      ).map((item) => item.toEntity()).toList(),
      allergies: allergies?.map((item) => item.toEntity()).toList() ?? const [],
      dislikedFoods:
          dislikedFoods?.map((item) => item.toEntity()).toList() ?? const [],
      notes: notes,
    );
  }

  List<FoodPreferenceItemEntity> toSelectedDislikedIngredients() {
    return _selectedItems(
      ingredients ?? dislikedFoods,
    ).map((item) => item.toEntity()).toList();
  }

  List<FoodPreferenceItemEntity> toSelectedAllergies() {
    return _selectedItems(
      allergens ?? allergies,
    ).map((item) => item.toEntity()).toList();
  }

  List<FoodPreferenceItemEntity> toSelectedDietaryPreferences() {
    return _selectedItems(
      dietaryPreferences,
    ).map((item) => item.toEntity()).toList();
  }

  List<FoodPreferenceCatalogItemEntity> toDislikedIngredientCatalog() {
    return [
      if (noneOption != null) noneOption!.toCatalogItemEntity(),
      ...(ingredients ?? dislikedFoods ?? const []).map(
        (item) => item.toCatalogItemEntity(),
      ),
    ];
  }

  List<FoodPreferenceCatalogItemEntity> toAllergyCatalog() {
    return [
      if (noneOption != null) noneOption!.toCatalogItemEntity(),
      ...(allergens ?? allergies ?? const []).map(
        (item) => item.toCatalogItemEntity(),
      ),
    ];
  }

  List<FoodPreferenceCatalogItemEntity> toDietaryPreferenceCatalog() {
    return [
      if (noneOption != null) noneOption!.toCatalogItemEntity(),
      ...(dietaryPreferences ?? const []).map(
        (item) => item.toCatalogItemEntity(),
      ),
    ];
  }
}

extension FoodPreferenceItemResponseDtoMapper on FoodPreferenceItemResponseDto {
  FoodPreferenceItemEntity toEntity() {
    return FoodPreferenceItemEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      severity: severity,
    );
  }

  FoodPreferenceCatalogItemEntity toCatalogItemEntity() {
    return FoodPreferenceCatalogItemEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      category: category,
      allergenCodes: allergenCodes ?? const [],
    );
  }
}

FoodPreferencesEntity mapFoodPreferencesSections({
  required FoodPreferencesResponseDto dislikedIngredients,
  required FoodPreferencesResponseDto allergies,
  required FoodPreferencesResponseDto dietary,
}) {
  final dietaryPreferences = dietary.toSelectedDietaryPreferences();

  return FoodPreferencesEntity(
    dietaryPattern: dietaryPreferences.isEmpty
        ? dietary.dietaryPattern
        : dietaryPreferences.first.code,
    dietaryPreferences: dietaryPreferences,
    allergies: allergies.toSelectedAllergies(),
    dislikedFoods: dislikedIngredients.toSelectedDislikedIngredients(),
    notes: dietary.notes ?? allergies.notes ?? dislikedIngredients.notes,
  );
}

FoodPreferencesCatalogEntity mapFoodPreferencesCatalogSections({
  required FoodPreferencesResponseDto dislikedIngredients,
  required FoodPreferencesResponseDto allergies,
  required FoodPreferencesResponseDto dietary,
}) {
  return FoodPreferencesCatalogEntity(
    ingredients: dislikedIngredients.toDislikedIngredientCatalog(),
    allergens: allergies.toAllergyCatalog(),
    dietaryPreferences: dietary.toDietaryPreferenceCatalog(),
  );
}

FoodPreferencesResponseDto mergeFoodPreferencesPages(
  List<FoodPreferencesResponseDto> pages,
) {
  final first = pages.first;

  return FoodPreferencesResponseDto(
    noneOption: first.noneOption,
    dietaryPattern: first.dietaryPattern,
    dietaryPreferences: _mergeItems(
      pages.map((page) => page.dietaryPreferences),
    ),
    ingredients: _mergeItems(pages.map((page) => page.ingredients)),
    allergens: _mergeItems(pages.map((page) => page.allergens)),
    allergies: _mergeItems(pages.map((page) => page.allergies)),
    dislikedFoods: _mergeItems(pages.map((page) => page.dislikedFoods)),
    selectedCount: first.selectedCount,
    eatsEverything: first.eatsEverything,
    hasNoAllergies: first.hasNoAllergies,
    hasNoDietaryRestriction: first.hasNoDietaryRestriction,
    page: first.page,
    pageSize: first.pageSize,
    totalCount: first.totalCount,
    totalPages: first.totalPages,
    hasNextPage: false,
    hasPreviousPage: first.hasPreviousPage,
    notes: first.notes,
  );
}

extension FoodPreferencesEntityMapper on FoodPreferencesEntity {
  FoodPreferencesRequestDto toDto() {
    return FoodPreferencesRequestDto(
      dietaryPattern: dietaryPattern,
      allergies: allergies.map((item) => item.toDto()).toList(),
      dislikedFoods: dislikedFoods.map((item) => item.toDto()).toList(),
      notes: notes,
    );
  }
}

extension FoodPreferencesAllergiesEntityMapper
    on List<FoodPreferenceItemEntity> {
  FoodPreferencesAllergiesRequestDto toAllergiesDto() {
    return FoodPreferencesAllergiesRequestDto(
      allergies: map(
        (item) => FoodPreferencesAllergyRequestDto(
          code: item.code,
          severity: item.severity,
        ),
      ).toList(),
    );
  }
}

extension FoodPreferencesDislikedIngredientsEntityMapper
    on FoodPreferencesEntity {
  FoodPreferencesDislikedIngredientsRequestDto toDislikedIngredientsDto() {
    return FoodPreferencesDislikedIngredientsRequestDto(
      ingredientCodes: dislikedFoods.map((item) => item.code).toList(),
    );
  }

  FoodPreferencesDietaryRequestDto toDietaryDto() {
    final fallbackDietaryPattern = dietaryPattern;

    return FoodPreferencesDietaryRequestDto(
      dietaryPreferenceCodes: dietaryPreferences.isEmpty
          ? fallbackDietaryPattern == null
                ? const []
                : [fallbackDietaryPattern]
          : dietaryPreferences.map((item) => item.code).toList(),
    );
  }
}

extension FoodPreferenceItemEntityMapper on FoodPreferenceItemEntity {
  FoodPreferenceItemRequestDto toDto() {
    return FoodPreferenceItemRequestDto(
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      severity: severity,
    );
  }
}

extension FoodPreferencesCatalogResponseDtoMapper
    on FoodPreferencesCatalogResponseDto {
  FoodPreferencesCatalogEntity toEntity() {
    return FoodPreferencesCatalogEntity(
      ingredients:
          ingredients?.map((item) => item.toCatalogItemEntity()).toList() ??
          const [],
      allergens:
          allergens?.map((item) => item.toCatalogItemEntity()).toList() ??
          const [],
      dietaryPreferences: const [],
    );
  }
}

extension FoodPreferencesCatalogIngredientResponseDtoMapper
    on FoodPreferencesCatalogIngredientResponseDto {
  FoodPreferenceCatalogItemEntity toCatalogItemEntity() {
    return FoodPreferenceCatalogItemEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      category: category,
      allergenCodes: allergenCodes ?? const [],
    );
  }
}

List<FoodPreferenceItemResponseDto> _selectedItems(
  List<FoodPreferenceItemResponseDto>? items,
) {
  final safeItems = items ?? const <FoodPreferenceItemResponseDto>[];
  final hasSelectionFlags = safeItems.any((item) => item.isSelected != null);

  if (!hasSelectionFlags) return safeItems;

  return safeItems.where((item) => item.isSelected ?? false).toList();
}

List<FoodPreferenceItemResponseDto>? _mergeItems(
  Iterable<List<FoodPreferenceItemResponseDto>?> pages,
) {
  final merged = pages
      .expand((items) => items ?? const <FoodPreferenceItemResponseDto>[])
      .toList();

  return merged.isEmpty ? null : merged;
}

extension FoodPreferencesCatalogAllergenResponseDtoMapper
    on FoodPreferencesCatalogAllergenResponseDto {
  FoodPreferenceCatalogItemEntity toCatalogItemEntity() {
    return FoodPreferenceCatalogItemEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}
