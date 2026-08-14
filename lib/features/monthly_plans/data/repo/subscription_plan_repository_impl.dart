import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/data/data_source/subscription_plan_remote_data_source.dart';
import 'package:meal_meat_user/features/monthly_plans/data/mapper/subscription_duration_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/data/mapper/subscription_tier_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';

@Injectable(as: SubscriptionPlanRepository)
class SubscriptionPlanRepositoryImpl implements SubscriptionPlanRepository {
  SubscriptionPlanRepositoryImpl(this._remoteDataSource);

  final SubscriptionPlanRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getDurations(
        programId: programId,
        bundleId: bundleId,
        includeFriday: includeFriday,
      );
      return response.map((duration) => duration.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTiers(
        programId: programId,
        bundleId: bundleId,
        durationDays: durationDays,
        includeFriday: includeFriday,
      );
      return response.map((tier) => tier.toEntity()).toList();
    });
  }
}
