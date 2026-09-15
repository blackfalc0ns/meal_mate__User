import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_services.dart';
import '../models/influencer_social_links_dto.dart';
import 'influencer_social_links_remote_data_source.dart';

@Injectable(as: InfluencerSocialLinksRemoteDataSource)
class InfluencerSocialLinksRemoteDataSourceImpl
    implements InfluencerSocialLinksRemoteDataSource {
  InfluencerSocialLinksRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<InfluencerSocialProfileResponseDto> getProfile() =>
      _api.getInfluencerProfile();
  @override
  Future<InfluencerSocialLinksUpdateResponseDto> updateSocialLinks(
    InfluencerSocialLinksDto request,
  ) => _api.updateInfluencerSocialLinks(request);
}
