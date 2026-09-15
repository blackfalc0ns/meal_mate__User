import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_dashboard_api_entity.dart';
import '../repo/influencer_dashboard_repository.dart';

@injectable
class GetInfluencerLinksUseCase {
  const GetInfluencerLinksUseCase(this._repo);
  final InfluencerDashboardRepository _repo;
  Future<ApiResult<InfluencerLinksEntity>> call() => _repo.getLinks();
}
