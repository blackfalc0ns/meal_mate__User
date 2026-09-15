class InfluencerSocialLinksEntity {
  const InfluencerSocialLinksEntity({
    this.tiktok,
    this.instagram,
    this.whatsapp,
    this.telegram,
    this.youtube,
    this.snapchat,
  });
  final String? tiktok, instagram, whatsapp, telegram, youtube, snapchat;
}

class InfluencerSocialProfileEntity {
  const InfluencerSocialProfileEntity({
    required this.id,
    required this.displayName,
    required this.code,
    required this.commissionRate,
    required this.status,
    required this.isActive,
    required this.hasCompletedSocialOnboarding,
    required this.links,
    this.avatarUrl,
    this.partnerTermsUrl,
  });
  final String id, displayName, code, status;
  final double commissionRate;
  final bool isActive, hasCompletedSocialOnboarding;
  final String? avatarUrl, partnerTermsUrl;
  final InfluencerSocialLinksEntity links;
}
