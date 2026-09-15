import '../../domain/entities/influencer_dashboard_api_entity.dart';
import '../models/influencer_dashboard_dto.dart';

InfluencerDashboardMoneyEntity _money(
  InfluencerDashboardMoneyDto? value, [
  String currency = 'KWD',
]) => InfluencerDashboardMoneyEntity(
  amount: value?.amount ?? 0,
  currency: value?.currency ?? currency,
);
InfluencerDashboardBankEntity _bank(InfluencerDashboardBankDto? value) =>
    InfluencerDashboardBankEntity(
      bankName: value?.bankName ?? '',
      accountHolderName: value?.accountHolderName ?? '',
      maskedIban: value?.maskedIban ?? '',
      isConfigured: value?.isConfigured ?? false,
    );
InfluencerDashboardKpisEntity _kpis(InfluencerDashboardKpisDto? value) =>
    InfluencerDashboardKpisEntity(
      registeredCustomers: value?.registeredCustomers ?? 0,
      completedSubscriptions: value?.completedSubscriptions ?? 0,
      linkClicks: value?.linkClicks ?? 0,
      conversionRate: value?.conversionRate ?? 0,
      registeredCustomersDiff: value?.registeredCustomersDiff ?? 0,
      completedSubscriptionsDiff: value?.completedSubscriptionsDiff ?? 0,
      linkClicksDiff: value?.linkClicksDiff ?? 0,
      conversionRateDiff: value?.conversionRateDiff ?? 0,
    );
InfluencerDashboardActivityEntity _activity(
  InfluencerDashboardActivityDto value,
) => InfluencerDashboardActivityEntity(
  id: value.activityId ?? '',
  code: value.activityCode ?? 'unknown',
  referenceId: value.referenceId,
  commissionAmount: _money(value.commissionAmount),
  occurredAtUtc: value.occurredAtUtc == null
      ? null
      : DateTime.tryParse(value.occurredAtUtc!)?.toUtc(),
);

extension InfluencerHomeDtoMapper on InfluencerHomeResponseDto {
  InfluencerHomeApiEntity toEntity() {
    final currency = currencyCode ?? wallet?.currencyCode ?? 'KWD';
    final source = wallet;
    return InfluencerHomeApiEntity(
      totalCommissions: _money(totalCommissions, currency),
      thisWeekCommissionsDiff: _money(thisWeekCommissionsDiff, currency),
      kpis: _kpis(kpis),
      influencerCode: influencerCode ?? '',
      referralLink: referralLink ?? '',
      qrCodeData: qrCodeData ?? referralLink ?? '',
      avatarUrl: avatarUrl,
      wallet: InfluencerDashboardWalletEntity(
        availableBalance: _money(source?.availableBalance, currency),
        pendingBalance: _money(source?.pendingBalance, currency),
        lifetimeEarnings: _money(source?.lifetimeEarnings, currency),
        thisMonthEarned: _money(source?.thisMonthEarned, currency),
        thisMonthWithdrawn: _money(source?.thisMonthWithdrawn, currency),
        currencyCode: currency,
        hasActiveWithdrawalRequest: source?.hasActiveWithdrawalRequest ?? false,
        withdrawalPolicy: InfluencerDashboardPolicyEntity(
          minimumAmount: source?.withdrawalPolicy?.minimumAmount ?? 10,
          maximumAmount:
              source?.withdrawalPolicy?.maximumAmount ??
              source?.availableBalance?.amount ??
              0,
          currencyCode: source?.withdrawalPolicy?.currencyCode ?? currency,
          canWithdraw: source?.withdrawalPolicy?.canWithdraw ?? false,
          disabledReason: source?.withdrawalPolicy?.disabledReason,
        ),
        bankInfo: _bank(source?.bankInfo),
      ),
      bankInfo: _bank(bankInfo),
      recentActivities: (recentActivities ?? const []).map(_activity).toList(),
    );
  }
}

extension InfluencerLinksDtoMapper on InfluencerLinksResponseDto {
  InfluencerLinksEntity toEntity() => InfluencerLinksEntity(
    influencerCode: influencerCode ?? '',
    referralLink: referralLink ?? '',
    qrCodeData: qrCodeData ?? referralLink ?? '',
    kpis: _kpis(quickStats),
  );
}

extension InfluencerActivitiesPageDtoMapper on InfluencerActivitiesPageDto {
  InfluencerActivitiesPageEntity toEntity() => InfluencerActivitiesPageEntity(
    items: (items ?? const []).map(_activity).toList(),
    page: page ?? 1,
    pageSize: pageSize ?? 20,
    totalCount: totalCount ?? 0,
    totalPages: totalPages ?? 0,
    hasPreviousPage: hasPreviousPage ?? false,
    hasNextPage: hasNextPage ?? false,
  );
}
