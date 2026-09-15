import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_social_links_entity.dart';
import '../repo/influencer_social_links_repository.dart';

@injectable
class GetInfluencerSocialProfileUseCase {
  const GetInfluencerSocialProfileUseCase(this._repo);
  final InfluencerSocialLinksRepository _repo;
  Future<ApiResult<InfluencerSocialProfileEntity>> call() => _repo.getProfile();
}
