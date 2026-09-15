enum InfluencerWalletActionIcon { wallet, history }

class InfluencerWalletActionViewData {
  const InfluencerWalletActionViewData({
    required this.title,
    required this.routeName,
    required this.icon,
  });
  final String title, routeName;
  final InfluencerWalletActionIcon icon;
}

enum InfluencerWalletSummaryIcon { earnings, withdrawn }

class InfluencerWalletSummaryMetricViewData {
  const InfluencerWalletSummaryMetricViewData({
    required this.title,
    required this.value,
    required this.currency,
    required this.icon,
  });
  final String title, value, currency;
  final InfluencerWalletSummaryIcon icon;
}

class InfluencerTransactionViewData {
  const InfluencerTransactionViewData({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.isDebit = false,
  });
  final String title, date, amount, status;
  final bool isDebit;
}
