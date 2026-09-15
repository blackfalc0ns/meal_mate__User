import '../../domain/entities/influencer_analytics_entity.dart';
import '../models/influencer_analytics_dto.dart';

extension InfluencerAnalyticsDtoMapper on InfluencerAnalyticsResponseDto {
  InfluencerAnalyticsEntity toEntity() {
    final currency = currencyCode ?? totalEarnings?.currency ?? 'KWD';
    final source = overviewKpis;
    return InfluencerAnalyticsEntity(
      period: period ?? '30d',
      currencyCode: currency,
      granularity: granularity ?? 'day',
      totalEarnings: InfluencerAnalyticsMoneyEntity(
        amount: totalEarnings?.amount ?? 0,
        currency: totalEarnings?.currency ?? currency,
      ),
      comparison: InfluencerAnalyticsComparisonEntity(
        clicksChangePercentage: comparison?.clicksChangePercentage ?? 0,
        ordersChangePercentage: comparison?.ordersChangePercentage ?? 0,
        netCommissionChangePercentage:
            comparison?.netCommissionChangePercentage ?? 0,
      ),
      earningsChart: (earningsChart ?? const [])
          .map(
            (e) => InfluencerAnalyticsPointEntity(
              dateUtc: e.dateUtc == null
                  ? null
                  : DateTime.tryParse(e.dateUtc!)?.toUtc(),
              amount: e.amount ?? 0,
              clicks: e.clicks ?? 0,
              orders: e.orders ?? 0,
            ),
          )
          .toList(),
      kpis: InfluencerAnalyticsKpisEntity(
        registeredCustomers: source?.registeredCustomers ?? 0,
        completedSubscriptions: source?.completedSubscriptions ?? 0,
        linkClicks: source?.linkClicks ?? 0,
        conversionRate: source?.conversionRate ?? 0,
        registeredCustomersDiff: source?.registeredCustomersDiff ?? 0,
        completedSubscriptionsDiff: source?.completedSubscriptionsDiff ?? 0,
        linkClicksDiff: source?.linkClicksDiff ?? 0,
        conversionRateDiff: source?.conversionRateDiff ?? 0,
      ),
      topPackages: (topPackages ?? const [])
          .map(
            (e) => InfluencerTopPackageEntity(
              programId: e.programId ?? '',
              bundleId: e.bundleId ?? '',
              nameAr: e.nameAr ?? '',
              nameEn: e.nameEn ?? '',
              totalRevenue: e.totalRevenue ?? 0,
              orderCount: e.orderCount ?? 0,
              totalCommission: e.totalCommission ?? 0,
            ),
          )
          .toList(),
    );
  }
}
