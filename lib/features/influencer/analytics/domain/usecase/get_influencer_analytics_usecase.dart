import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_analytics_entity.dart';
import '../repo/influencer_analytics_repository.dart';

@injectable
class GetInfluencerAnalyticsUseCase {
  const GetInfluencerAnalyticsUseCase(this._repo);
  final InfluencerAnalyticsRepository _repo;
  Future<ApiResult<InfluencerAnalyticsEntity>> call(String period) =>
      _repo.getAnalytics(period);
}
