class InfluencerAnalyticsMetricViewData {
  const InfluencerAnalyticsMetricViewData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconAsset,
    required this.trendIconAsset,
  });
  final String title, value, subtitle, iconAsset, trendIconAsset;
}

class InfluencerAnalyticsPointViewData {
  const InfluencerAnalyticsPointViewData({
    required this.label,
    required this.value,
  });
  final String label;
  final double value;
}

class InfluencerAnalyticsSummaryViewData {
  const InfluencerAnalyticsSummaryViewData({
    required this.title,
    required this.value,
    required this.currency,
    required this.gain,
    required this.growthPercent,
    required this.comparisonLabel,
  });
  final String title, value, currency, gain, growthPercent, comparisonLabel;
}

class InfluencerTopProductViewData {
  const InfluencerTopProductViewData({
    required this.rank,
    required this.name,
    required this.orders,
    required this.ordersLabel,
    required this.revenueLabel,
    required this.revenue,
  });
  final String rank, name, orders, ordersLabel, revenueLabel, revenue;
}
