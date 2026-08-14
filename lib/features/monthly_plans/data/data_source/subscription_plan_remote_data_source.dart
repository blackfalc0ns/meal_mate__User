import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_duration_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_response_dto.dart';

abstract interface class SubscriptionPlanRemoteDataSource {
  Future<List<SubscriptionDurationResponseDto>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  });

  Future<List<SubscriptionTierResponseDto>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  });
}
