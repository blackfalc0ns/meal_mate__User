import '../../domain/entities/influencer_social_links_entity.dart';
import '../models/influencer_social_links_dto.dart';

extension InfluencerSocialLinksDtoMapper on InfluencerSocialLinksDto {
  InfluencerSocialLinksEntity toEntity() => InfluencerSocialLinksEntity(
    tiktok: tiktok,
    instagram: instagram,
    whatsapp: whatsapp,
    telegram: telegram,
    youtube: youtube,
    snapchat: snapchat,
  );
}

extension InfluencerSocialProfileDtoMapper
    on InfluencerSocialProfileResponseDto {
  InfluencerSocialProfileEntity toEntity() => InfluencerSocialProfileEntity(
    id: influencerProfileId ?? '',
    displayName: displayName ?? '',
    code: influencerCode ?? '',
    commissionRate: commissionRate ?? 0,
    status: status ?? (isActive == true ? 'Active' : 'Pending'),
    isActive: isActive ?? false,
    hasCompletedSocialOnboarding: hasCompletedSocialOnboarding ?? false,
    avatarUrl: avatarUrl,
    partnerTermsUrl: partnerTermsUrl,
    links: (socialLinks ?? const InfluencerSocialLinksDto()).toEntity(),
  );
}
