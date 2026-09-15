import '../../../../../core/network/api_results.dart';
import '../entities/influencer_social_links_entity.dart';

abstract interface class InfluencerSocialLinksRepository {
  Future<ApiResult<InfluencerSocialProfileEntity>> getProfile();
  Future<ApiResult<InfluencerSocialLinksEntity>> updateSocialLinks(
    InfluencerSocialLinksEntity links,
  );
}
