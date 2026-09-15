class InfluencerMetricEntity {
  const InfluencerMetricEntity({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconAsset,
    required this.trendIconAsset,
  });
  final String title, value, subtitle, iconAsset, trendIconAsset;
}

class InfluencerActionEntity {
  const InfluencerActionEntity({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });
  final String title, subtitle, routeName;
  final InfluencerActionIcon icon;
}

enum InfluencerActionIcon { share, social, wallet, history }

class InfluencerShareLinksEntity {
  const InfluencerShareLinksEntity({
    required this.title,
    required this.subtitle,
    required this.bannerTitle,
    required this.bannerHighlight,
    required this.bannerSubtitle,
    required this.bannerFooter,
    required this.discountCodeTitle,
    required this.discountCode,
    required this.discountBadgePrefix,
    required this.discountBadgeValue,
    required this.discountBadgeSuffix,
    required this.copyCodeLabel,
    required this.qrLabel,
    required this.referralLinkTitle,
    required this.referralLink,
    required this.copyLinkLabel,
    required this.shareNowTitle,
    required this.shareNowSubtitle,
    required this.quickStatsTitle,
    required this.quickStatsSubtitle,
    required this.socialPlatforms,
    required this.quickStats,
  });
  final String title,
      subtitle,
      bannerTitle,
      bannerHighlight,
      bannerSubtitle,
      bannerFooter,
      discountCodeTitle,
      discountCode,
      discountBadgePrefix,
      discountBadgeValue,
      discountBadgeSuffix,
      copyCodeLabel,
      qrLabel,
      referralLinkTitle,
      referralLink,
      copyLinkLabel,
      shareNowTitle,
      shareNowSubtitle,
      quickStatsTitle,
      quickStatsSubtitle;
  final List<InfluencerShareSocialPlatformEntity> socialPlatforms;
  final List<InfluencerShareQuickStatEntity> quickStats;
}

class InfluencerShareSocialPlatformEntity {
  const InfluencerShareSocialPlatformEntity({
    required this.label,
    required this.iconAsset,
    this.drawDotsIcon = false,
  });
  final String label, iconAsset;
  final bool drawDotsIcon;
}

class InfluencerShareQuickStatEntity {
  const InfluencerShareQuickStatEntity({
    required this.label,
    required this.value,
    required this.iconAsset,
  });
  final String label, value, iconAsset;
}

class InfluencerActivityEntity {
  const InfluencerActivityEntity({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.avatarAsset,
  });
  final String title, subtitle, amount, time, avatarAsset;
}
