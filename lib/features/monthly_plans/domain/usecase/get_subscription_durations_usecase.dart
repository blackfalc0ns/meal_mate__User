import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';

@injectable
class GetSubscriptionDurationsUseCase {
  GetSubscriptionDurationsUseCase(this._repository);

  final SubscriptionPlanRepository _repository;

  Future<ApiResult<List<SubscriptionDurationEntity>>> call({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) {
    return _repository.getDurations(
      programId: programId,
      bundleId: bundleId,
      includeFriday: includeFriday,
    );
  }
}
