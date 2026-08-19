import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/data_source/subscription_summary_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_summary_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';

@Injectable(as: SubscriptionSummaryRepository)
class SubscriptionSummaryRepositoryImpl
    implements SubscriptionSummaryRepository {
  SubscriptionSummaryRepositoryImpl(this._remoteDataSource);

  final SubscriptionSummaryRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSummary(request);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionReadinessEntity>> getReadiness(
    SubscriptionSummaryRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getReadiness(request);
      return response.toEntity();
    });
  }
}
