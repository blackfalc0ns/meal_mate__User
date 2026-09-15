import '../../../../../core/network/api_results.dart';
import '../entities/influencer_analytics_entity.dart';

abstract interface class InfluencerAnalyticsRepository {
  Future<ApiResult<InfluencerAnalyticsEntity>> getAnalytics(String period);
}
