class InfluencerDashboardMoneyEntity {
  const InfluencerDashboardMoneyEntity({
    required this.amount,
    required this.currency,
  });
  final double amount;
  final String currency;
}

class InfluencerDashboardBankEntity {
  const InfluencerDashboardBankEntity({
    required this.bankName,
    required this.accountHolderName,
    required this.maskedIban,
    required this.isConfigured,
  });
  final String bankName, accountHolderName, maskedIban;
  final bool isConfigured;
}

class InfluencerDashboardPolicyEntity {
  const InfluencerDashboardPolicyEntity({
    required this.minimumAmount,
    required this.maximumAmount,
    required this.currencyCode,
    required this.canWithdraw,
    this.disabledReason,
  });
  final double minimumAmount, maximumAmount;
  final String currencyCode;
  final bool canWithdraw;
  final String? disabledReason;
}

class InfluencerDashboardKpisEntity {
  const InfluencerDashboardKpisEntity({
    required this.registeredCustomers,
    required this.completedSubscriptions,
    required this.linkClicks,
    required this.conversionRate,
    required this.registeredCustomersDiff,
    required this.completedSubscriptionsDiff,
    required this.linkClicksDiff,
    required this.conversionRateDiff,
  });
  final int registeredCustomers,
      completedSubscriptions,
      linkClicks,
      registeredCustomersDiff,
      completedSubscriptionsDiff,
      linkClicksDiff;
  final double conversionRate, conversionRateDiff;
}

class InfluencerDashboardActivityEntity {
  const InfluencerDashboardActivityEntity({
    required this.id,
    required this.code,
    required this.commissionAmount,
    this.referenceId,
    this.occurredAtUtc,
  });
  final String id, code;
  final String? referenceId;
  final InfluencerDashboardMoneyEntity commissionAmount;
  final DateTime? occurredAtUtc;
}

class InfluencerDashboardWalletEntity {
  const InfluencerDashboardWalletEntity({
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
  final InfluencerDashboardMoneyEntity availableBalance,
      pendingBalance,
      lifetimeEarnings,
      thisMonthEarned,
      thisMonthWithdrawn;
  final String currencyCode;
  final bool hasActiveWithdrawalRequest;
  final InfluencerDashboardPolicyEntity withdrawalPolicy;
  final InfluencerDashboardBankEntity bankInfo;
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
  final InfluencerDashboardMoneyEntity totalCommissions,
      thisWeekCommissionsDiff;
  final InfluencerDashboardKpisEntity kpis;
  final String influencerCode, referralLink, qrCodeData;
  final String? avatarUrl;
  final InfluencerDashboardWalletEntity wallet;
  final InfluencerDashboardBankEntity bankInfo;
  final List<InfluencerDashboardActivityEntity> recentActivities;
}

class InfluencerLinksEntity {
  const InfluencerLinksEntity({
    required this.influencerCode,
    required this.referralLink,
    required this.qrCodeData,
    required this.kpis,
  });
  final String influencerCode, referralLink, qrCodeData;
  final InfluencerDashboardKpisEntity kpis;
}

class InfluencerActivitiesPageEntity {
  const InfluencerActivitiesPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
  final List<InfluencerDashboardActivityEntity> items;
  final int page, pageSize, totalCount, totalPages;
  final bool hasPreviousPage, hasNextPage;
}
