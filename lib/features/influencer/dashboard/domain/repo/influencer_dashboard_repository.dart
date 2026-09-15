import '../../../../../core/network/api_results.dart';
import '../entities/influencer_dashboard_api_entity.dart';

abstract interface class InfluencerDashboardRepository {
  Future<ApiResult<InfluencerHomeApiEntity>> getHome();
  Future<ApiResult<InfluencerLinksEntity>> getLinks();
  Future<ApiResult<InfluencerActivitiesPageEntity>> getActivities({
    required int page,
    required int pageSize,
  });
}
