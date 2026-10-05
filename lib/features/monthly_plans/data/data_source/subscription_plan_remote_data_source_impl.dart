import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/monthly_plans/data/data_source/subscription_plan_remote_data_source.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_duration_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_restaurant_details_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_restaurant_browse_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_restaurants_page_response_dto.dart';

@Injectable(as: SubscriptionPlanRemoteDataSource)
class SubscriptionPlanRemoteDataSourceImpl
    implements SubscriptionPlanRemoteDataSource {
  SubscriptionPlanRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<SubscriptionDurationResponseDto>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) {
    return _apiServices.getSubscriptionDurations(
      programId,
      bundleId,
      includeFriday,
    );
  }

  @override
  Future<List<SubscriptionTierResponseDto>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) {
    return _apiServices.getSubscriptionTiers(
      programId,
      bundleId,
      durationDays,
      includeFriday,
      null,
    );
  }

  @override
  Future<List<SubscriptionTierRestaurantBrowseResponseDto>> getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
  }) {
    return _apiServices.getSubscriptionTierRestaurants(
      programId,
      bundleId,
      tier,
      null,
    );
  }

  @override
  Future<SubscriptionTierRestaurantsPageResponseDto> getTierRestaurantsPage({
    required String programId,
    required String bundleId,
    required String tier,
    required int page,
    required int pageSize,
    String? addressId,
  }) async {
    final items = await _apiServices.getSubscriptionTierRestaurants(
      programId,
      bundleId,
      tier,
      null,
      page: page,
      pageSize: pageSize,
    );
    final hasNext = items.length >= pageSize;
    return SubscriptionTierRestaurantsPageResponseDto(
      items: items,
      totalCount: items.length,
      page: page,
      pageSize: pageSize,
      totalPages: hasNext ? page + 1 : page,
      hasNextPage: hasNext,
      hasPreviousPage: page > 1,
    );
  }

  @override
  Future<SubscriptionRestaurantDetailsResponseDto> getRestaurantDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
  }) {
    return _apiServices.getSubscriptionRestaurantDetails(
      programId,
      bundleId,
      restaurantId,
    );
  }
}
