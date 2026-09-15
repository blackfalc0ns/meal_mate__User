import '../models/influencer_analytics_dto.dart';

abstract interface class InfluencerAnalyticsRemoteDataSource {
  Future<InfluencerAnalyticsResponseDto> getAnalytics(String period);
}
