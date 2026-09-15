import 'package:json_annotation/json_annotation.dart';

part 'influencer_social_links_dto.g.dart';

@JsonSerializable(includeIfNull: true)
class InfluencerSocialLinksDto {
  const InfluencerSocialLinksDto({
    this.tiktok,
    this.instagram,
    this.whatsapp,
    this.telegram,
    this.youtube,
    this.snapchat,
  });
  factory InfluencerSocialLinksDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerSocialLinksDtoFromJson(json);
  final String? tiktok, instagram, whatsapp, telegram, youtube, snapchat;
  Map<String, dynamic> toJson() => _$InfluencerSocialLinksDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class InfluencerSocialProfileResponseDto {
  const InfluencerSocialProfileResponseDto({
    this.influencerProfileId,
    this.displayName,
    this.influencerCode,
    this.commissionRate,
    this.isActive,
    this.status,
    this.avatarUrl,
    this.hasCompletedSocialOnboarding,
    this.partnerTermsUrl,
    this.socialLinks,
  });
  factory InfluencerSocialProfileResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$InfluencerSocialProfileResponseDtoFromJson(json);
  final String? influencerProfileId,
      displayName,
      influencerCode,
      status,
      avatarUrl,
      partnerTermsUrl;
  final double? commissionRate;
  final bool? isActive, hasCompletedSocialOnboarding;
  final InfluencerSocialLinksDto? socialLinks;
}

@JsonSerializable(createToJson: false)
class InfluencerSocialLinksUpdateResponseDto {
  const InfluencerSocialLinksUpdateResponseDto({
    this.socialLinks,
    this.hasCompletedSocialOnboarding,
  });
  factory InfluencerSocialLinksUpdateResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$InfluencerSocialLinksUpdateResponseDtoFromJson(json);
  final InfluencerSocialLinksDto? socialLinks;
  final bool? hasCompletedSocialOnboarding;
}
