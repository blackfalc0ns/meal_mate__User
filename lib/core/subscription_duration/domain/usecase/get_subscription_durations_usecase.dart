import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/repo/subscription_duration_repository.dart';

@injectable
class GetSubscriptionDurationsUseCase {
  GetSubscriptionDurationsUseCase(this._repository);

  final SubscriptionDurationRepository _repository;

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
