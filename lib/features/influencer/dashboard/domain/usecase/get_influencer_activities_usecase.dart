import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_dashboard_api_entity.dart';
import '../repo/influencer_dashboard_repository.dart';

@injectable
class GetInfluencerActivitiesUseCase {
  const GetInfluencerActivitiesUseCase(this._repo);
  final InfluencerDashboardRepository _repo;
  Future<ApiResult<InfluencerActivitiesPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) => _repo.getActivities(page: page, pageSize: pageSize);
}
