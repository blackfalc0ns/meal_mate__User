class InfluencerDashboardEntity {
  const InfluencerDashboardEntity({
    required this.userName,
    required this.partnerLabel,
    required this.heroImageAsset,
    required this.shareBannerAsset,
    required this.qrAsset,
    required this.avatarAsset,
    required this.logoAsset,
    required this.shareIconAsset,
    required this.copyIconAsset,
    required this.trendIconAsset,
    required this.metrics,
    required this.actions,
    required this.wallet,
    required this.socialAccounts,
    required this.activities,
    required this.statistics,
    required this.shareLinks,
  });

  final String userName;
  final String partnerLabel;
  final String heroImageAsset;
  final String shareBannerAsset;
  final String qrAsset;
  final String avatarAsset;
  final String logoAsset;
  final String shareIconAsset;
  final String copyIconAsset;
  final String trendIconAsset;
  final List<InfluencerMetricEntity> metrics;
  final List<InfluencerActionEntity> actions;
  final InfluencerWalletEntity wallet;
  final List<InfluencerSocialAccountEntity> socialAccounts;
  final List<InfluencerActivityEntity> activities;
  final InfluencerStatisticsEntity statistics;
  final InfluencerShareLinksEntity shareLinks;
}

class InfluencerMetricEntity {
  const InfluencerMetricEntity({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconAsset,
    required this.trendIconAsset,
  });

  final String title;
  final String value;
  final String subtitle;
  final String iconAsset;
  final String trendIconAsset;
}

class InfluencerActionEntity {
  const InfluencerActionEntity({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final String subtitle;
  final InfluencerActionIcon icon;
  final String routeName;
}

enum InfluencerActionIcon { share, social, wallet, history }

class InfluencerWalletEntity {
  const InfluencerWalletEntity({
    required this.totalBalance,
    required this.availableBalance,
    required this.currency,
    required this.lastUpdated,
    required this.bankAccount,
    required this.monthlySummary,
    required this.transactions,
  });

  final String totalBalance;
  final String availableBalance;
  final String currency;
  final String lastUpdated;
  final InfluencerBankAccountEntity bankAccount;
  final List<InfluencerWalletSummaryMetricEntity> monthlySummary;
  final List<InfluencerTransactionEntity> transactions;
}

class InfluencerWalletSummaryMetricEntity {
  const InfluencerWalletSummaryMetricEntity({
    required this.title,
    required this.value,
    required this.currency,
    required this.icon,
  });

  final String title;
  final String value;
  final String currency;
  final InfluencerWalletSummaryIcon icon;
}

enum InfluencerWalletSummaryIcon { earnings, withdrawn }

class InfluencerBankAccountEntity {
  const InfluencerBankAccountEntity({
    required this.accountHolder,
    required this.iban,
    required this.bankName,
  });

  final String accountHolder;
  final String iban;
  final String bankName;
}

class InfluencerTransactionEntity {
  const InfluencerTransactionEntity({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.isDebit = false,
  });

  final String title;
  final String date;
  final String amount;
  final String status;
  final bool isDebit;
}

class InfluencerSocialAccountEntity {
  const InfluencerSocialAccountEntity({
    required this.platform,
    required this.handle,
    required this.connected,
  });

  final String platform;
  final String handle;
  final bool connected;
}

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

  final String title;
  final String subtitle;
  final String bannerTitle;
  final String bannerHighlight;
  final String bannerSubtitle;
  final String bannerFooter;
  final String discountCodeTitle;
  final String discountCode;
  final String discountBadgePrefix;
  final String discountBadgeValue;
  final String discountBadgeSuffix;
  final String copyCodeLabel;
  final String qrLabel;
  final String referralLinkTitle;
  final String referralLink;
  final String copyLinkLabel;
  final String shareNowTitle;
  final String shareNowSubtitle;
  final String quickStatsTitle;
  final String quickStatsSubtitle;
  final List<InfluencerShareSocialPlatformEntity> socialPlatforms;
  final List<InfluencerShareQuickStatEntity> quickStats;
}

class InfluencerShareSocialPlatformEntity {
  const InfluencerShareSocialPlatformEntity({
    required this.label,
    required this.iconAsset,
    this.drawDotsIcon = false,
  });

  final String label;
  final String iconAsset;
  final bool drawDotsIcon;
}

class InfluencerShareQuickStatEntity {
  const InfluencerShareQuickStatEntity({
    required this.label,
    required this.value,
    required this.iconAsset,
  });

  final String label;
  final String value;
  final String iconAsset;
}

class InfluencerActivityEntity {
  const InfluencerActivityEntity({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.avatarAsset,
  });

  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final String avatarAsset;
}

class InfluencerStatisticsEntity {
  const InfluencerStatisticsEntity({
    required this.periods,
    required this.selectedPeriodIndex,
    required this.summary,
    required this.overviewMetrics,
    required this.revenuePoints,
    required this.revenueBars,
    required this.topProduct,
    required this.periodData,
  });

  final List<String> periods;
  final int selectedPeriodIndex;
  final InfluencerStatisticsSummaryEntity summary;
  final List<InfluencerMetricEntity> overviewMetrics;
  final List<InfluencerChartPointEntity> revenuePoints;
  final List<InfluencerChartPointEntity> revenueBars;
  final InfluencerTopProductEntity topProduct;
  final List<InfluencerStatisticsPeriodDataEntity> periodData;
}

class InfluencerStatisticsPeriodDataEntity {
  const InfluencerStatisticsPeriodDataEntity({
    required this.summary,
    required this.overviewMetrics,
    required this.revenuePoints,
    required this.revenueBars,
  });

  final InfluencerStatisticsSummaryEntity summary;
  final List<InfluencerMetricEntity> overviewMetrics;
  final List<InfluencerChartPointEntity> revenuePoints;
  final List<InfluencerChartPointEntity> revenueBars;
}

class InfluencerStatisticsSummaryEntity {
  const InfluencerStatisticsSummaryEntity({
    required this.title,
    required this.value,
    required this.currency,
    required this.gain,
    required this.growthPercent,
    required this.comparisonLabel,
    required this.dateLabels,
  });

  final String title;
  final String value;
  final String currency;
  final String gain;
  final String growthPercent;
  final String comparisonLabel;
  final List<String> dateLabels;
}

class InfluencerChartPointEntity {
  const InfluencerChartPointEntity({required this.label, required this.value});

  final String label;
  final double value;
}

class InfluencerTopProductEntity {
  const InfluencerTopProductEntity({
    required this.rank,
    required this.name,
    required this.orders,
    required this.ordersLabel,
    required this.revenueLabel,
    required this.revenue,
  });

  final String rank;
  final String name;
  final String orders;
  final String ordersLabel;
  final String revenueLabel;
  final String revenue;
}
