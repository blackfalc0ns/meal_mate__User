import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';

@injectable
class GetSubscriptionTiersUseCase {
  GetSubscriptionTiersUseCase(this._repository);

  final SubscriptionPlanRepository _repository;

  Future<ApiResult<List<SubscriptionTierEntity>>> call({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) {
    return _repository.getTiers(
      programId: programId,
      bundleId: bundleId,
      durationDays: durationDays,
      includeFriday: includeFriday,
    );
  }
}
