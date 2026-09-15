import '../models/influencer_social_links_dto.dart';

abstract interface class InfluencerSocialLinksRemoteDataSource {
  Future<InfluencerSocialProfileResponseDto> getProfile();
  Future<InfluencerSocialLinksUpdateResponseDto> updateSocialLinks(
    InfluencerSocialLinksDto request,
  );
}
