import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/entities/subscription_duration_entity.dart';

abstract interface class SubscriptionDurationRepository {
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  });
}
