import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';

@injectable
class GetFamilyPlanDurationsUseCase {
  const GetFamilyPlanDurationsUseCase(this._repository);

  final FamilyPackageDaysRepository _repository;

  Future<ApiResult<List<SubscriptionDurationEntity>>> call({
    required String programId,
    required bool includeFriday,
  }) {
    return _repository.getDurations(
      programId: programId,
      includeFriday: includeFriday,
    );
  }
}
