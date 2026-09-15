import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_analytics_entity.dart';
import '../../domain/repo/influencer_analytics_repository.dart';
import '../data_source/influencer_analytics_remote_data_source.dart';
import '../mapper/influencer_analytics_mapper.dart';

@Injectable(as: InfluencerAnalyticsRepository)
class InfluencerAnalyticsRepositoryImpl
    implements InfluencerAnalyticsRepository {
  const InfluencerAnalyticsRepositoryImpl(this._remote);
  final InfluencerAnalyticsRemoteDataSource _remote;
  @override
  Future<ApiResult<InfluencerAnalyticsEntity>> getAnalytics(String period) =>
      safeApiCall(() async => (await _remote.getAnalytics(period)).toEntity());
}
