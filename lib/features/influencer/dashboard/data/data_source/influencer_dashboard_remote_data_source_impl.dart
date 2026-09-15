import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_services.dart';
import '../models/influencer_dashboard_dto.dart';
import 'influencer_dashboard_remote_data_source.dart';

@Injectable(as: InfluencerDashboardRemoteDataSource)
class InfluencerDashboardRemoteDataSourceImpl
    implements InfluencerDashboardRemoteDataSource {
  const InfluencerDashboardRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<InfluencerHomeResponseDto> getHome() => _api.getInfluencerHome();
  @override
  Future<InfluencerLinksResponseDto> getLinks() => _api.getInfluencerLinks();
  @override
  Future<InfluencerActivitiesPageDto> getActivities({
    required int page,
    required int pageSize,
  }) => _api.getInfluencerActivities(page, pageSize);
}
