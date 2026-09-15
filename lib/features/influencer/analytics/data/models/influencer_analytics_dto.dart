import 'package:json_annotation/json_annotation.dart';

part 'influencer_analytics_dto.g.dart';

@JsonSerializable(createToJson: false)
class InfluencerAnalyticsMoneyDto {
  const InfluencerAnalyticsMoneyDto({this.amount, this.currency});
  factory InfluencerAnalyticsMoneyDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerAnalyticsMoneyDtoFromJson(json);
  final double? amount;
  final String? currency;
}

@JsonSerializable(createToJson: false)
class InfluencerAnalyticsComparisonDto {
  const InfluencerAnalyticsComparisonDto({
    this.clicksChangePercentage,
    this.ordersChangePercentage,
    this.netCommissionChangePercentage,
  });
  factory InfluencerAnalyticsComparisonDto.fromJson(
    Map<String, dynamic> json,
  ) => _$InfluencerAnalyticsComparisonDtoFromJson(json);
  final double? clicksChangePercentage,
      ordersChangePercentage,
      netCommissionChangePercentage;
}

@JsonSerializable(createToJson: false)
class InfluencerAnalyticsPointDto {
  const InfluencerAnalyticsPointDto({
    this.dateUtc,
    this.amount,
    this.clicks,
    this.orders,
  });
  factory InfluencerAnalyticsPointDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerAnalyticsPointDtoFromJson(_normalizePoint(json));
  final String? dateUtc;
  final double? amount;
  final int? clicks, orders;
}

@JsonSerializable(createToJson: false)
class InfluencerAnalyticsKpisDto {
  const InfluencerAnalyticsKpisDto({
    this.registeredCustomers,
    this.completedSubscriptions,
    this.linkClicks,
    this.conversionRate,
    this.registeredCustomersDiff,
    this.completedSubscriptionsDiff,
    this.linkClicksDiff,
    this.conversionRateDiff,
  });
  factory InfluencerAnalyticsKpisDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerAnalyticsKpisDtoFromJson(_normalizeKpis(json));
  final int? registeredCustomers,
      completedSubscriptions,
      linkClicks,
      registeredCustomersDiff,
      completedSubscriptionsDiff,
      linkClicksDiff;
  final double? conversionRate, conversionRateDiff;
}

@JsonSerializable(createToJson: false)
class InfluencerTopPackageDto {
  const InfluencerTopPackageDto({
    this.programId,
    this.bundleId,
    this.nameAr,
    this.nameEn,
    this.totalRevenue,
    this.orderCount,
    this.totalCommission,
  });
  factory InfluencerTopPackageDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerTopPackageDtoFromJson(_normalizePackage(json));
  final String? programId, bundleId, nameAr, nameEn;
  final double? totalRevenue, totalCommission;
  final int? orderCount;
}

@JsonSerializable(createToJson: false)
class InfluencerAnalyticsResponseDto {
  const InfluencerAnalyticsResponseDto({
    this.period,
    this.currencyCode,
    this.granularity,
    this.totalEarnings,
    this.comparison,
    this.earningsChart,
    this.overviewKpis,
    this.topPackages,
  });
  factory InfluencerAnalyticsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerAnalyticsResponseDtoFromJson(_normalizeAnalytics(json));
  final String? period, currencyCode, granularity;
  final InfluencerAnalyticsMoneyDto? totalEarnings;
  final InfluencerAnalyticsComparisonDto? comparison;
  final List<InfluencerAnalyticsPointDto>? earningsChart;
  final InfluencerAnalyticsKpisDto? overviewKpis;
  final List<InfluencerTopPackageDto>? topPackages;
}

Map<String, dynamic> _normalizePoint(Map<String, dynamic> json) => {
  ...json,
  'dateUtc': json['dateUtc'] ?? json['date'],
  'amount': json['amount'] ?? json['commission'],
};
Map<String, dynamic> _normalizeKpis(Map<String, dynamic> json) => {
  ...json,
  'completedSubscriptions':
      json['completedSubscriptions'] ?? json['totalOrders'],
  'linkClicks': json['linkClicks'] ?? json['totalClicks'],
};
Map<String, dynamic> _normalizePackage(Map<String, dynamic> json) => {
  ...json,
  'nameAr': json['nameAr'] ?? json['programName'],
  'orderCount': json['orderCount'] ?? json['subscriptionsCount'],
};
Map<String, dynamic> _normalizeAnalytics(Map<String, dynamic> json) {
  final summary = json['summary'] is Map
      ? Map<String, dynamic>.from(json['summary'] as Map)
      : const <String, dynamic>{};
  return {
    ...json,
    'totalEarnings':
        json['totalEarnings'] ??
        {
          'amount': summary['totalNetCommission'],
          'currency': json['currencyCode'],
        },
    'earningsChart': json['earningsChart'] ?? json['chartData'],
    'overviewKpis': json['overviewKpis'] ?? summary,
    'topPackages': json['topPackages'] ?? json['topPrograms'],
  };
}
