import 'package:json_annotation/json_annotation.dart';

part 'influencer_dashboard_dto.g.dart';

@JsonSerializable(createToJson: false)
class InfluencerDashboardMoneyDto {
  const InfluencerDashboardMoneyDto({this.amount, this.currency});
  factory InfluencerDashboardMoneyDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerDashboardMoneyDtoFromJson(json);
  final double? amount;
  final String? currency;
}

@JsonSerializable(createToJson: false)
class InfluencerDashboardBankDto {
  const InfluencerDashboardBankDto({
    this.bankName,
    this.accountHolderName,
    this.maskedIban,
    this.isConfigured,
  });
  factory InfluencerDashboardBankDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerDashboardBankDtoFromJson(json);
  final String? bankName, accountHolderName, maskedIban;
  final bool? isConfigured;
}

@JsonSerializable(createToJson: false)
class InfluencerDashboardPolicyDto {
  const InfluencerDashboardPolicyDto({
    this.minimumAmount,
    this.maximumAmount,
    this.currencyCode,
    this.canWithdraw,
    this.disabledReason,
  });
  factory InfluencerDashboardPolicyDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerDashboardPolicyDtoFromJson(json);
  final double? minimumAmount, maximumAmount;
  final String? currencyCode, disabledReason;
  final bool? canWithdraw;
}

@JsonSerializable(createToJson: false)
class InfluencerDashboardKpisDto {
  const InfluencerDashboardKpisDto({
    this.registeredCustomers,
    this.completedSubscriptions,
    this.linkClicks,
    this.conversionRate,
    this.registeredCustomersDiff,
    this.completedSubscriptionsDiff,
    this.linkClicksDiff,
    this.conversionRateDiff,
  });
  factory InfluencerDashboardKpisDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerDashboardKpisDtoFromJson(_normalizeKpis(json));
  final int? registeredCustomers,
      completedSubscriptions,
      linkClicks,
      registeredCustomersDiff,
      completedSubscriptionsDiff,
      linkClicksDiff;
  final double? conversionRate, conversionRateDiff;
}

@JsonSerializable(createToJson: false)
class InfluencerDashboardActivityDto {
  const InfluencerDashboardActivityDto({
    this.activityId,
    this.activityCode,
    this.referenceId,
    this.commissionAmount,
    this.occurredAtUtc,
  });
  factory InfluencerDashboardActivityDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerDashboardActivityDtoFromJson(_normalizeActivity(json));
  final String? activityId, activityCode, referenceId, occurredAtUtc;
  final InfluencerDashboardMoneyDto? commissionAmount;
}

@JsonSerializable(createToJson: false)
class InfluencerDashboardWalletDto {
  const InfluencerDashboardWalletDto({
    this.availableBalance,
    this.pendingBalance,
    this.lifetimeEarnings,
    this.thisMonthEarned,
    this.thisMonthWithdrawn,
    this.currencyCode,
    this.hasActiveWithdrawalRequest,
    this.withdrawalPolicy,
    this.bankInfo,
  });
  factory InfluencerDashboardWalletDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerDashboardWalletDtoFromJson(_normalizeWallet(json));
  final InfluencerDashboardMoneyDto? availableBalance,
      pendingBalance,
      lifetimeEarnings,
      thisMonthEarned,
      thisMonthWithdrawn;
  final String? currencyCode;
  final bool? hasActiveWithdrawalRequest;
  final InfluencerDashboardPolicyDto? withdrawalPolicy;
  final InfluencerDashboardBankDto? bankInfo;
}

@JsonSerializable(createToJson: false)
class InfluencerHomeResponseDto {
  const InfluencerHomeResponseDto({
    this.totalCommissions,
    this.thisWeekCommissionsDiff,
    this.kpis,
    this.influencerCode,
    this.avatarUrl,
    this.currencyCode,
    this.referralLink,
    this.qrCodeData,
    this.bankInfo,
    this.wallet,
    this.recentActivities,
  });
  factory InfluencerHomeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerHomeResponseDtoFromJson(_normalizeHome(json));
  final InfluencerDashboardMoneyDto? totalCommissions, thisWeekCommissionsDiff;
  final InfluencerDashboardKpisDto? kpis;
  final String? influencerCode,
      avatarUrl,
      currencyCode,
      referralLink,
      qrCodeData;
  final InfluencerDashboardBankDto? bankInfo;
  final InfluencerDashboardWalletDto? wallet;
  final List<InfluencerDashboardActivityDto>? recentActivities;
}

@JsonSerializable(createToJson: false)
class InfluencerLinksResponseDto {
  const InfluencerLinksResponseDto({
    this.influencerCode,
    this.referralLink,
    this.qrCodeData,
    this.quickStats,
  });
  factory InfluencerLinksResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerLinksResponseDtoFromJson(json);
  final String? influencerCode, referralLink, qrCodeData;
  final InfluencerDashboardKpisDto? quickStats;
}

@JsonSerializable(createToJson: false)
class InfluencerActivitiesPageDto {
  const InfluencerActivitiesPageDto({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasPreviousPage,
    this.hasNextPage,
  });
  factory InfluencerActivitiesPageDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerActivitiesPageDtoFromJson(json);
  final List<InfluencerDashboardActivityDto>? items;
  final int? page, pageSize, totalCount, totalPages;
  final bool? hasPreviousPage, hasNextPage;
}

Map<String, dynamic> _normalizeKpis(Map<String, dynamic> json) => {
  ...json,
  'completedSubscriptions':
      json['completedSubscriptions'] ??
      json['totalOrders'] ??
      json['affiliatedOrders'],
  'linkClicks': json['linkClicks'] ?? json['totalClicks'],
};
Map<String, dynamic> _normalizeActivity(Map<String, dynamic> json) => {
  ...json,
  'activityId': json['activityId'] ?? json['id'],
  'activityCode': json['activityCode'] ?? json['type'],
  'commissionAmount': json['commissionAmount'] ?? {'amount': json['amount']},
  'occurredAtUtc': json['occurredAtUtc'] ?? json['createdAt'],
};
Map<String, dynamic> _normalizeWallet(Map<String, dynamic> json) {
  Map<String, dynamic>? money(dynamic value) => value == null
      ? null
      : value is Map
      ? Map<String, dynamic>.from(value)
      : {'amount': value};
  return {
    ...json,
    'availableBalance': money(json['availableBalance']),
    'pendingBalance': money(json['pendingBalance']),
    'lifetimeEarnings': money(json['lifetimeEarnings']),
    'thisMonthEarned': money(json['thisMonthEarned']),
    'thisMonthWithdrawn': money(json['thisMonthWithdrawn']),
    'hasActiveWithdrawalRequest':
        json['hasActiveWithdrawalRequest'] ?? json['hasPendingWithdrawal'],
  };
}

Map<String, dynamic> _normalizeHome(Map<String, dynamic> json) => {
  ...json,
  'kpis': json['kpis'] ?? json['quickStats'],
};
