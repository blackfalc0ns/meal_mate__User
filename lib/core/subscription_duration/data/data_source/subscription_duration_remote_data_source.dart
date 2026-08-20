import 'package:meal_meat_user/core/subscription_duration/data/models/response/subscription_duration_response_dto.dart';

abstract interface class SubscriptionDurationRemoteDataSource {
  Future<List<SubscriptionDurationResponseDto>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  });
}
