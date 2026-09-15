import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_dashboard_api_entity.dart';
import '../../domain/repo/influencer_dashboard_repository.dart';
import '../data_source/influencer_dashboard_remote_data_source.dart';
import '../mapper/influencer_dashboard_mapper.dart';

@Injectable(as: InfluencerDashboardRepository)
class InfluencerDashboardRepositoryImpl
    implements InfluencerDashboardRepository {
  const InfluencerDashboardRepositoryImpl(this._remote);
  final InfluencerDashboardRemoteDataSource _remote;
  @override
  Future<ApiResult<InfluencerHomeApiEntity>> getHome() =>
      safeApiCall(() async => (await _remote.getHome()).toEntity());
  @override
  Future<ApiResult<InfluencerLinksEntity>> getLinks() =>
      safeApiCall(() async => (await _remote.getLinks()).toEntity());
  @override
  Future<ApiResult<InfluencerActivitiesPageEntity>> getActivities({
    required int page,
    required int pageSize,
  }) => safeApiCall(
    () async => (await _remote.getActivities(
      page: page,
      pageSize: pageSize,
    )).toEntity(),
  );
}
