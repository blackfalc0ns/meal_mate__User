import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_social_links_entity.dart';
import '../../domain/repo/influencer_social_links_repository.dart';
import '../data_source/influencer_social_links_remote_data_source.dart';
import '../mapper/influencer_social_links_mapper.dart';
import '../models/influencer_social_links_dto.dart';

@Injectable(as: InfluencerSocialLinksRepository)
class InfluencerSocialLinksRepositoryImpl
    implements InfluencerSocialLinksRepository {
  InfluencerSocialLinksRepositoryImpl(this._remote);
  final InfluencerSocialLinksRemoteDataSource _remote;
  @override
  Future<ApiResult<InfluencerSocialProfileEntity>> getProfile() =>
      safeApiCall(() async => (await _remote.getProfile()).toEntity());
  @override
  Future<ApiResult<InfluencerSocialLinksEntity>> updateSocialLinks(
    InfluencerSocialLinksEntity links,
  ) => safeApiCall(() async {
    final response = await _remote.updateSocialLinks(
      InfluencerSocialLinksDto(
        tiktok: links.tiktok,
        instagram: links.instagram,
        whatsapp: links.whatsapp,
        telegram: links.telegram,
        youtube: links.youtube,
        snapchat: links.snapchat,
      ),
    );
    return (response.socialLinks ?? const InfluencerSocialLinksDto())
        .toEntity();
  });
}
