import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_services.dart';
import '../models/influencer_analytics_dto.dart';
import 'influencer_analytics_remote_data_source.dart';

@Injectable(as: InfluencerAnalyticsRemoteDataSource)
class InfluencerAnalyticsRemoteDataSourceImpl
    implements InfluencerAnalyticsRemoteDataSource {
  const InfluencerAnalyticsRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<InfluencerAnalyticsResponseDto> getAnalytics(String period) =>
      _api.getInfluencerAnalytics(period);
}
