class InfluencerAnalyticsMoneyEntity {
  const InfluencerAnalyticsMoneyEntity({
    required this.amount,
    required this.currency,
  });
  final double amount;
  final String currency;
}

class InfluencerAnalyticsComparisonEntity {
  const InfluencerAnalyticsComparisonEntity({
    required this.clicksChangePercentage,
    required this.ordersChangePercentage,
    required this.netCommissionChangePercentage,
  });
  final double clicksChangePercentage,
      ordersChangePercentage,
      netCommissionChangePercentage;
}

class InfluencerAnalyticsPointEntity {
  const InfluencerAnalyticsPointEntity({
    required this.amount,
    required this.clicks,
    required this.orders,
    this.dateUtc,
  });
  final DateTime? dateUtc;
  final double amount;
  final int clicks, orders;
}

class InfluencerAnalyticsKpisEntity {
  const InfluencerAnalyticsKpisEntity({
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
  final String programId, bundleId, nameAr, nameEn;
  final double totalRevenue, totalCommission;
  final int orderCount;
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
  final String period, currencyCode, granularity;
  final InfluencerAnalyticsMoneyEntity totalEarnings;
  final InfluencerAnalyticsComparisonEntity comparison;
  final List<InfluencerAnalyticsPointEntity> earningsChart;
  final InfluencerAnalyticsKpisEntity kpis;
  final List<InfluencerTopPackageEntity> topPackages;
}
