enum InfluencerWithdrawalStatus {
  requested,
  underReview,
  approved,
  completed,
  rejected,
  cancelled,
  unknown,
}

class InfluencerWalletMoneyEntity {
  const InfluencerWalletMoneyEntity({
    required this.amount,
    required this.currency,
  });
  final double amount;
  final String currency;
}

class InfluencerWalletBankEntity {
  const InfluencerWalletBankEntity({
    required this.bankName,
    required this.accountHolderName,
    required this.maskedIban,
    required this.isConfigured,
    this.iban,
  });
  final String bankName, accountHolderName, maskedIban;
  final String? iban;
  final bool isConfigured;
}

class InfluencerWithdrawalPolicyEntity {
  const InfluencerWithdrawalPolicyEntity({
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

class InfluencerWalletEntity {
  const InfluencerWalletEntity({
    required this.availableBalance,
    required this.pendingBalance,
    required this.lifetimeEarnings,
    required this.thisMonthEarned,
    required this.thisMonthWithdrawn,
    required this.currencyCode,
    required this.hasActiveWithdrawalRequest,
    required this.withdrawalPolicy,
    required this.bankInfo,
    required this.recentTransactions,
  });
  final InfluencerWalletMoneyEntity availableBalance,
      pendingBalance,
      lifetimeEarnings,
      thisMonthEarned,
      thisMonthWithdrawn;
  final String currencyCode;
  final bool hasActiveWithdrawalRequest;
  final InfluencerWithdrawalPolicyEntity withdrawalPolicy;
  final InfluencerWalletBankEntity bankInfo;
  final List<InfluencerWithdrawalEntity> recentTransactions;
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
  final InfluencerWalletMoneyEntity amount;
  final InfluencerWithdrawalStatus status;
  final String method;
  final InfluencerWalletBankEntity bankInfo;
  final DateTime? requestedAtUtc, reviewedAtUtc, completedAtUtc;
  final String? rejectionReason;
}

class InfluencerWithdrawalsPageEntity {
  const InfluencerWithdrawalsPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
  final List<InfluencerWithdrawalEntity> items;
  final int page, pageSize, totalCount, totalPages;
  final bool hasPreviousPage, hasNextPage;
}
