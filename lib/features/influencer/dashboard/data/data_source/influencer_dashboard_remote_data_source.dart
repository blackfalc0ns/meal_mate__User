import '../models/influencer_dashboard_dto.dart';

abstract interface class InfluencerDashboardRemoteDataSource {
  Future<InfluencerHomeResponseDto> getHome();
  Future<InfluencerLinksResponseDto> getLinks();
  Future<InfluencerActivitiesPageDto> getActivities({
    required int page,
    required int pageSize,
  });
}
