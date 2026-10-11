import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/data_source/subscription_tier_remote_data_source.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_restaurant_browse_response_dto.dart';

@Injectable(as: SubscriptionTierRemoteDataSource)
class SubscriptionTierRemoteDataSourceImpl
    implements SubscriptionTierRemoteDataSource {
  SubscriptionTierRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<void> checkPrerequisites() {
    return _apiServices.checkSubscriptionPrerequisites();
  }

  @override
  Future<List<SubscriptionTierResponseDto>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
    String? startDate,
    String? familyMemberId,
  }) async {
    try {
      final response = await _apiServices.getSubscriptionCatalogTiers(
        programId,
        bundleId,
        durationDays: durationDays,
        startDate: startDate,
        includeFriday: includeFriday,
        familyMemberId: familyMemberId,
      );
      return response.effectiveTiers;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
        return _apiServices.getSubscriptionTiers(
          programId,
          bundleId,
          durationDays,
          includeFriday,
          familyMemberId,
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<SubscriptionTierRestaurantBrowseResponseDto>> getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
    String? familyMemberId,
    int? durationDays,
    String? startDate,
    bool? includeFriday,
  }) {
    return _apiServices.getSubscriptionTierRestaurants(
      programId,
      bundleId,
      tier,
      familyMemberId,
      durationDays: durationDays,
      startDate: startDate,
      includeFriday: includeFriday,
    );
  }
}
