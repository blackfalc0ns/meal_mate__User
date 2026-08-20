import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_duration/data/data_source/subscription_duration_remote_data_source.dart';
import 'package:meal_meat_user/core/subscription_duration/data/mapper/subscription_duration_mapper.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/repo/subscription_duration_repository.dart';

@Injectable(as: SubscriptionDurationRepository)
class SubscriptionDurationRepositoryImpl
    implements SubscriptionDurationRepository {
  SubscriptionDurationRepositoryImpl(this._remoteDataSource);

  final SubscriptionDurationRemoteDataSource _remoteDataSource;

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
      return response.map((item) => item.toEntity()).toList();
    });
  }
}
