import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../entities/influencer_social_links_entity.dart';
import '../repo/influencer_social_links_repository.dart';

@injectable
class UpdateInfluencerSocialLinksUseCase {
  const UpdateInfluencerSocialLinksUseCase(this._repo);
  final InfluencerSocialLinksRepository _repo;
  Future<ApiResult<InfluencerSocialLinksEntity>> call(
    InfluencerSocialLinksEntity links,
  ) => _repo.updateSocialLinks(links);
}
