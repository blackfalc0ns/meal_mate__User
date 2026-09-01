class InfluencerDashboardEntity {
  const InfluencerDashboardEntity({
    required this.userName,
    required this.partnerLabel,
    required this.heroImageAsset,
    required this.shareBannerAsset,
    required this.qrAsset,
    required this.metrics,
    required this.actions,
    required this.wallet,
    required this.socialAccounts,
  });

  final String userName;
  final String partnerLabel;
  final String heroImageAsset;
  final String shareBannerAsset;
  final String qrAsset;
  final List<InfluencerMetricEntity> metrics;
  final List<InfluencerActionEntity> actions;
  final InfluencerWalletEntity wallet;
  final List<InfluencerSocialAccountEntity> socialAccounts;
}

class InfluencerMetricEntity {
  const InfluencerMetricEntity({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;
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
    required this.transactions,
  });

  final String totalBalance;
  final String availableBalance;
  final String currency;
  final String lastUpdated;
  final InfluencerBankAccountEntity bankAccount;
  final List<InfluencerTransactionEntity> transactions;
}

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
  });

  final String title;
  final String date;
  final String amount;
  final String status;
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
