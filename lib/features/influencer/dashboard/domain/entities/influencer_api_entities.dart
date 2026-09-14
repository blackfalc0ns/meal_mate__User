enum InfluencerWithdrawalStatus {
  requested,
  underReview,
  approved,
  completed,
  rejected,
  cancelled,
  unknown,
}

class InfluencerBankEntity {
  const InfluencerBankEntity({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.isActive,
  });
  final String id, code, nameAr, nameEn;
  final bool isActive;
}

class InfluencerLinksEntity {
  const InfluencerLinksEntity({
    required this.influencerCode,
    required this.referralLink,
    required this.qrCodeData,
    required this.kpis,
  });
  final String influencerCode, referralLink, qrCodeData;
  final InfluencerKpisEntity kpis;
}

class InfluencerPageEntity<T> {
  const InfluencerPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
  final List<T> items;
  final int page, pageSize, totalCount, totalPages;
  final bool hasPreviousPage, hasNextPage;
}

class InfluencerMoneyEntity {
  const InfluencerMoneyEntity({required this.amount, required this.currency});
  final double amount;
  final String currency;
}

class InfluencerWithdrawalPolicyEntity {
  const InfluencerWithdrawalPolicyEntity({
    required this.minimumAmount,
    required this.maximumAmount,
    required this.currencyCode,
    required this.canWithdraw,
    this.disabledReason,
  });
  final double minimumAmount;
  final double maximumAmount;
  final String currencyCode;
  final bool canWithdraw;
  final String? disabledReason;
}

class InfluencerBankInfoEntity {
  const InfluencerBankInfoEntity({
    required this.bankName,
    required this.accountHolderName,
    required this.maskedIban,
    required this.isConfigured,
    this.iban,
  });
  final String bankName;
  final String accountHolderName;
  final String maskedIban;
  final bool isConfigured;
  final String? iban;
}

class InfluencerKpisEntity {
  const InfluencerKpisEntity({
    required this.registeredCustomers,
    required this.completedSubscriptions,
    required this.linkClicks,
    required this.conversionRate,
    required this.registeredCustomersDiff,
    required this.completedSubscriptionsDiff,
    required this.linkClicksDiff,
    required this.conversionRateDiff,
  });
  final int registeredCustomers;
  final int completedSubscriptions;
  final int linkClicks;
  final double conversionRate;
  final int registeredCustomersDiff;
  final int completedSubscriptionsDiff;
  final int linkClicksDiff;
  final double conversionRateDiff;
}

class InfluencerActivityApiEntity {
  const InfluencerActivityApiEntity({
    required this.id,
    required this.code,
    required this.commissionAmount,
    this.referenceId,
    this.occurredAtUtc,
  });
  final String id;
  final String code;
  final String? referenceId;
  final InfluencerMoneyEntity commissionAmount;
  final DateTime? occurredAtUtc;
}

class InfluencerWalletApiEntity {
  const InfluencerWalletApiEntity({
    required this.availableBalance,
    required this.pendingBalance,
    required this.lifetimeEarnings,
    required this.thisMonthEarned,
    required this.thisMonthWithdrawn,
    required this.currencyCode,
    required this.hasActiveWithdrawalRequest,
    required this.withdrawalPolicy,
    required this.bankInfo,
  });
  final InfluencerMoneyEntity availableBalance;
  final InfluencerMoneyEntity pendingBalance;
  final InfluencerMoneyEntity lifetimeEarnings;
  final InfluencerMoneyEntity thisMonthEarned;
  final InfluencerMoneyEntity thisMonthWithdrawn;
  final String currencyCode;
  final bool hasActiveWithdrawalRequest;
  final InfluencerWithdrawalPolicyEntity withdrawalPolicy;
  final InfluencerBankInfoEntity bankInfo;
}

class InfluencerHomeApiEntity {
  const InfluencerHomeApiEntity({
    required this.totalCommissions,
    required this.thisWeekCommissionsDiff,
    required this.kpis,
    required this.influencerCode,
    required this.referralLink,
    required this.qrCodeData,
    required this.wallet,
    required this.bankInfo,
    required this.recentActivities,
    this.avatarUrl,
  });
  final InfluencerMoneyEntity totalCommissions;
  final InfluencerMoneyEntity thisWeekCommissionsDiff;
  final InfluencerKpisEntity kpis;
  final String influencerCode;
  final String referralLink;
  final String qrCodeData;
  final String? avatarUrl;
  final InfluencerWalletApiEntity wallet;
  final InfluencerBankInfoEntity bankInfo;
  final List<InfluencerActivityApiEntity> recentActivities;
}

class InfluencerSocialLinksEntity {
  const InfluencerSocialLinksEntity({
    this.tiktok,
    this.instagram,
    this.whatsapp,
    this.telegram,
    this.youtube,
    this.snapchat,
  });
  final String? tiktok;
  final String? instagram;
  final String? whatsapp;
  final String? telegram;
  final String? youtube;
  final String? snapchat;
}

class InfluencerProfileApiEntity {
  const InfluencerProfileApiEntity({
    required this.id,
    required this.displayName,
    required this.code,
    required this.commissionRate,
    required this.status,
    required this.isActive,
    required this.hasCompletedSocialOnboarding,
    required this.socialLinks,
    required this.bankInfo,
    this.avatarUrl,
    this.partnerTermsUrl,
  });
  final String id;
  final String displayName;
  final String code;
  final double commissionRate;
  final String status;
  final bool isActive;
  final bool hasCompletedSocialOnboarding;
  final String? avatarUrl;
  final String? partnerTermsUrl;
  final InfluencerSocialLinksEntity socialLinks;
  final InfluencerBankInfoEntity bankInfo;
}

class InfluencerWithdrawalEntity {
  const InfluencerWithdrawalEntity({
    required this.id,
    required this.amount,
    required this.status,
    required this.method,
    required this.bankInfo,
    this.referenceNumber,
    this.requestedAtUtc,
    this.reviewedAtUtc,
    this.completedAtUtc,
    this.rejectionReason,
  });
  final String id;
  final String? referenceNumber;
  final InfluencerMoneyEntity amount;
  final InfluencerWithdrawalStatus status;
  final String method;
  final InfluencerBankInfoEntity bankInfo;
  final DateTime? requestedAtUtc;
  final DateTime? reviewedAtUtc;
  final DateTime? completedAtUtc;
  final String? rejectionReason;
}

class InfluencerComparisonEntity {
  const InfluencerComparisonEntity({
    required this.clicksChangePercentage,
    required this.ordersChangePercentage,
    required this.netCommissionChangePercentage,
  });
  final double clicksChangePercentage;
  final double ordersChangePercentage;
  final double netCommissionChangePercentage;
}

class InfluencerChartPointApiEntity {
  const InfluencerChartPointApiEntity({
    required this.amount,
    required this.clicks,
    required this.orders,
    this.dateUtc,
  });
  final DateTime? dateUtc;
  final double amount;
  final int clicks;
  final int orders;
}

class InfluencerTopPackageEntity {
  const InfluencerTopPackageEntity({
    required this.programId,
    required this.bundleId,
    required this.nameAr,
    required this.nameEn,
    required this.totalRevenue,
    required this.orderCount,
    required this.totalCommission,
  });
  final String programId;
  final String bundleId;
  final String nameAr;
  final String nameEn;
  final double totalRevenue;
  final int orderCount;
  final double totalCommission;
}

class InfluencerAnalyticsEntity {
  const InfluencerAnalyticsEntity({
    required this.period,
    required this.currencyCode,
    required this.granularity,
    required this.totalEarnings,
    required this.comparison,
    required this.earningsChart,
    required this.kpis,
    required this.topPackages,
  });
  final String period;
  final String currencyCode;
  final String granularity;
  final InfluencerMoneyEntity totalEarnings;
  final InfluencerComparisonEntity comparison;
  final List<InfluencerChartPointApiEntity> earningsChart;
  final InfluencerKpisEntity kpis;
  final List<InfluencerTopPackageEntity> topPackages;
}
