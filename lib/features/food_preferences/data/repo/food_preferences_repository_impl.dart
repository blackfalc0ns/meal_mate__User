import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/food_preferences/data/data_source/food_preferences_remote_data_source.dart';
import 'package:meal_meat_user/features/food_preferences/data/mapper/food_preferences_mapper.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/repo/food_preferences_repository.dart';

@Injectable(as: FoodPreferencesRepository)
class FoodPreferencesRepositoryImpl implements FoodPreferencesRepository {
  FoodPreferencesRepositoryImpl(this._remoteDataSource);

  static const int _firstPage = 1;
  static const int _maxPageSize = 50;

  final FoodPreferencesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FoodPreferencesEntity>> getFoodPreferences() {
    return safeApiCall(() async {
      final responses = await Future.wait([
        _getAllPages(_remoteDataSource.getFoodPreferencesDislikedIngredients),
        _getAllPages(_remoteDataSource.getFoodPreferencesAllergies),
        _getAllPages(_remoteDataSource.getFoodPreferencesDietary),
      ]);

      return mapFoodPreferencesSections(
        dislikedIngredients: responses[0],
        allergies: responses[1],
        dietary: responses[2],
      );
    });
  }

  @override
  Future<ApiResult<FoodPreferencesCatalogEntity>> getFoodPreferencesCatalog() {
    return safeApiCall(() async {
      final responses = await Future.wait([
        _getAllPages(_remoteDataSource.getFoodPreferencesDislikedIngredients),
        _getAllPages(_remoteDataSource.getFoodPreferencesAllergies),
        _getAllPages(_remoteDataSource.getFoodPreferencesDietary),
      ]);

      return mapFoodPreferencesCatalogSections(
        dislikedIngredients: responses[0],
        allergies: responses[1],
        dietary: responses[2],
      );
    });
  }

  @override
  Future<ApiResult<List<FoodPreferenceCatalogItemEntity>>>
  searchFoodPreferencesAllergies({
    required int page,
    required int pageSize,
    String? search,
  }) => safeApiCall(() async {
    final response = await _remoteDataSource.getFoodPreferencesAllergies(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return response.toAllergyCatalog();
  });

  @override
  Future<ApiResult<List<FoodPreferenceCatalogItemEntity>>>
  searchFoodPreferencesIngredients({
    required int page,
    required int pageSize,
    String? search,
  }) => safeApiCall(() async {
    final response = await _remoteDataSource
        .getFoodPreferencesDislikedIngredients(
          page: page,
          pageSize: pageSize,
          search: search,
        );
    return response.toDislikedIngredientCatalog();
  });

  @override
  Future<ApiResult<void>> updateFoodPreferences(
    FoodPreferencesEntity preferences,
  ) {
    return safeApiCall(() async {
      await Future.wait([
        _remoteDataSource.updateFoodPreferencesDislikedIngredients(
          preferences.toDislikedIngredientsDto(),
        ),
        _remoteDataSource.updateFoodPreferencesAllergies(
          preferences.allergies.toAllergiesDto(),
        ),
        _remoteDataSource.updateFoodPreferencesDietary(
          preferences.toDietaryDto(),
        ),
      ]);
    });
  }

  @override
  Future<ApiResult<void>> updateFoodPreferencesAllergies(
    List<FoodPreferenceItemEntity> allergies,
  ) {
    return safeApiCall(() async {
      await _remoteDataSource.updateFoodPreferencesAllergies(
        allergies.toAllergiesDto(),
      );
    });
  }

  Future<FoodPreferencesResponseDto> _getAllPages(
    Future<FoodPreferencesResponseDto> Function({
      required int page,
      required int pageSize,
      String? search,
    })
    request,
  ) async {
    final pages = <FoodPreferencesResponseDto>[];
    var page = _firstPage;
    var hasNextPage = true;

    while (hasNextPage) {
      final response = await request(page: page, pageSize: _maxPageSize);
      pages.add(response);
      hasNextPage = response.hasNextPage ?? false;
      page++;
    }

    return mergeFoodPreferencesPages(pages);
  }
}
