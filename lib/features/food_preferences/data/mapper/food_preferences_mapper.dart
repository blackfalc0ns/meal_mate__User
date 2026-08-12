import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_catalog_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

extension FoodPreferencesResponseDtoMapper on FoodPreferencesResponseDto {
  FoodPreferencesEntity toEntity() {
    return FoodPreferencesEntity(
      dietaryPattern: dietaryPattern,
      allergies: allergies?.map((item) => item.toEntity()).toList() ?? const [],
      dislikedFoods:
          dislikedFoods?.map((item) => item.toEntity()).toList() ?? const [],
      notes: notes,
    );
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

extension FoodPreferenceCatalogItemEntityMapper
    on FoodPreferenceCatalogItemEntity {
  FoodPreferenceItemEntity toPreferenceItemEntity() {
    return FoodPreferenceItemEntity(code: code, nameAr: nameAr, nameEn: nameEn);
  }
}
