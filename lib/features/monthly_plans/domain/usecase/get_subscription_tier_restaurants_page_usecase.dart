import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';

@injectable
class GetSubscriptionTierRestaurantsPageUseCase {
  GetSubscriptionTierRestaurantsPageUseCase(this._repository);

  final SubscriptionPlanRepository _repository;

  Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>> call({
    required String programId,
    required String bundleId,
    required String tier,
    required int page,
    required int pageSize,
    String? addressId,
    int? durationDays,
    String? startDate,
    bool? includeFriday,
  }) {
    return _repository.getTierRestaurantsPage(
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      page: page,
      pageSize: pageSize,
      addressId: addressId,
      durationDays: durationDays,
      startDate: startDate,
      includeFriday: includeFriday,
    );
  }
}
