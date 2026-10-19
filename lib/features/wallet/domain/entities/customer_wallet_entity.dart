class CustomerWalletEntity {
  const CustomerWalletEntity({
    required this.totalBalance,
    required this.cashBalance,
    required this.promotionalBalance,
    required this.currency,
    this.updatedAtUtc,
    this.isPromotionalExpiringSoon = false,
    this.nextExpiringPromotionalAmount,
    this.nextExpiringAtUtc,
  });

  final double totalBalance;
  final double cashBalance;
  final double promotionalBalance;
  final String currency;
  final String? updatedAtUtc;
  final bool isPromotionalExpiringSoon;
  final double? nextExpiringPromotionalAmount;
  final String? nextExpiringAtUtc;
}

class CustomerWalletTransactionItemEntity {
  const CustomerWalletTransactionItemEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.walletType,
    required this.description,
    this.referenceId,
    this.createdAtUtc,
  });

  final String id;
  final String type;
  final double amount;
  final String currency;
  final String walletType;
  final String description;
  final String? referenceId;
  final String? createdAtUtc;
}

class CustomerWalletTransactionsEntity {
  const CustomerWalletTransactionsEntity({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.items,
  });

  final int page;
  final int pageSize;
  final int totalCount;
  final List<CustomerWalletTransactionItemEntity> items;

  bool get hasMore => page * pageSize < totalCount;
}

class CustomerReferralEntity {
  const CustomerReferralEntity({
    required this.code,
    required this.rewardPercentage,
    required this.totalReferrals,
    required this.completedReferrals,
    required this.earnedCredits,
    required this.currency,
    required this.shareMessage,
    required this.shareUrl,
  });

  final String code;
  final double rewardPercentage;
  final int totalReferrals;
  final int completedReferrals;
  final double earnedCredits;
  final String currency;
  final String shareMessage;
  final String shareUrl;
}
