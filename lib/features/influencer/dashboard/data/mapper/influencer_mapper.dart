import '../../domain/entities/influencer_api_entities.dart';
import '../models/influencer_api_models.dart';

InfluencerMoneyEntity _money(MoneyDto? dto, [String fallback = 'KWD']) =>
    InfluencerMoneyEntity(
      amount: dto?.amount ?? 0,
      currency: dto?.currency ?? fallback,
    );
DateTime? _date(String? value) =>
    value == null ? null : DateTime.tryParse(value)?.toUtc();

extension BankInfoDtoMapper on BankInfoDto {
  InfluencerBankInfoEntity toEntity() => InfluencerBankInfoEntity(
    bankName: bankName ?? '',
    accountHolderName: accountHolderName ?? '',
    iban: iban,
    maskedIban: maskedIban ?? '',
    isConfigured: isConfigured ?? false,
  );
}

extension KpisDtoMapper on KpisDto {
  InfluencerKpisEntity toEntity() => InfluencerKpisEntity(
    registeredCustomers: registeredCustomers ?? 0,
    completedSubscriptions: completedSubscriptions ?? 0,
    linkClicks: linkClicks ?? 0,
    conversionRate: conversionRate ?? 0,
    registeredCustomersDiff: registeredCustomersDiff ?? 0,
    completedSubscriptionsDiff: completedSubscriptionsDiff ?? 0,
    linkClicksDiff: linkClicksDiff ?? 0,
    conversionRateDiff: conversionRateDiff ?? 0,
  );
}

extension WalletDtoMapper on InfluencerWalletResponseDto {
  InfluencerWalletApiEntity toEntity() {
    final currency = currencyCode ?? availableBalance?.currency ?? 'KWD';
    return InfluencerWalletApiEntity(
      availableBalance: _money(availableBalance, currency),
      pendingBalance: _money(pendingBalance, currency),
      lifetimeEarnings: _money(lifetimeEarnings, currency),
      thisMonthEarned: _money(thisMonthEarned, currency),
      thisMonthWithdrawn: _money(thisMonthWithdrawn, currency),
      currencyCode: currency,
      hasActiveWithdrawalRequest: hasActiveWithdrawalRequest ?? false,
      withdrawalPolicy: InfluencerWithdrawalPolicyEntity(
        minimumAmount: withdrawalPolicy?.minimumAmount ?? 10,
        maximumAmount:
            withdrawalPolicy?.maximumAmount ?? availableBalance?.amount ?? 0,
        currencyCode: withdrawalPolicy?.currencyCode ?? currency,
        canWithdraw: withdrawalPolicy?.canWithdraw ?? false,
        disabledReason: withdrawalPolicy?.disabledReason,
      ),
      bankInfo: (bankInfo ?? const BankInfoDto()).toEntity(),
    );
  }
}

extension HomeDtoMapper on InfluencerHomeResponseDto {
  InfluencerHomeApiEntity toEntity() => InfluencerHomeApiEntity(
    totalCommissions: _money(totalCommissions, currencyCode ?? 'KWD'),
    thisWeekCommissionsDiff: _money(
      thisWeekCommissionsDiff,
      currencyCode ?? 'KWD',
    ),
    kpis: (kpis ?? const KpisDto()).toEntity(),
    influencerCode: influencerCode ?? '',
    referralLink: referralLink ?? '',
    qrCodeData: qrCodeData ?? referralLink ?? '',
    avatarUrl: avatarUrl,
    wallet: (wallet ?? const InfluencerWalletResponseDto()).toEntity(),
    bankInfo: (bankInfo ?? const BankInfoDto()).toEntity(),
    recentActivities: recentActivities
        .map(
          (e) => InfluencerActivityApiEntity(
            id: e.activityId ?? '',
            code: e.activityCode ?? 'unknown',
            referenceId: e.referenceId,
            commissionAmount: _money(e.commissionAmount),
            occurredAtUtc: _date(e.occurredAtUtc),
          ),
        )
        .toList(),
  );
}

extension ProfileDtoMapper on InfluencerProfileResponseDto {
  InfluencerProfileApiEntity toEntity() => InfluencerProfileApiEntity(
    id: influencerProfileId ?? '',
    displayName: displayName ?? '',
    code: influencerCode ?? '',
    commissionRate: commissionRate ?? 0,
    status: status ?? (isActive == true ? 'Active' : 'Pending'),
    isActive: isActive ?? false,
    hasCompletedSocialOnboarding: hasCompletedSocialOnboarding ?? false,
    avatarUrl: avatarUrl,
    partnerTermsUrl: partnerTermsUrl,
    bankInfo: (bankInfo ?? const BankInfoDto()).toEntity(),
    socialLinks: InfluencerSocialLinksEntity(
      tiktok: socialLinks?.tiktok,
      instagram: socialLinks?.instagram,
      whatsapp: socialLinks?.whatsapp,
      telegram: socialLinks?.telegram,
      youtube: socialLinks?.youtube,
      snapchat: socialLinks?.snapchat,
    ),
  );
}

extension WithdrawalDtoMapper on InfluencerWithdrawalResponseDto {
  InfluencerWithdrawalEntity toEntity() => InfluencerWithdrawalEntity(
    id: withdrawalId ?? '',
    referenceNumber: referenceNumber,
    amount: _money(amount),
    status: switch (status?.toLowerCase()) {
      'requested' => InfluencerWithdrawalStatus.requested,
      'underreview' => InfluencerWithdrawalStatus.underReview,
      'approved' => InfluencerWithdrawalStatus.approved,
      'completed' => InfluencerWithdrawalStatus.completed,
      'rejected' => InfluencerWithdrawalStatus.rejected,
      'cancelled' => InfluencerWithdrawalStatus.cancelled,
      _ => InfluencerWithdrawalStatus.unknown,
    },
    method: method ?? 'BankTransfer',
    bankInfo: (bankDetails ?? const BankInfoDto()).toEntity(),
    requestedAtUtc: _date(requestedAtUtc),
    reviewedAtUtc: _date(reviewedAtUtc),
    completedAtUtc: _date(completedAtUtc),
    rejectionReason: rejectionReason,
  );
}

extension AnalyticsDtoMapper on InfluencerAnalyticsResponseDto {
  InfluencerAnalyticsEntity toEntity() => InfluencerAnalyticsEntity(
    period: period ?? '30d',
    currencyCode: currencyCode ?? totalEarnings?.currency ?? 'KWD',
    granularity: granularity ?? 'day',
    totalEarnings: _money(totalEarnings, currencyCode ?? 'KWD'),
    comparison: InfluencerComparisonEntity(
      clicksChangePercentage: comparison?.clicksChangePercentage ?? 0,
      ordersChangePercentage: comparison?.ordersChangePercentage ?? 0,
      netCommissionChangePercentage:
          comparison?.netCommissionChangePercentage ?? 0,
    ),
    earningsChart: earningsChart
        .map(
          (e) => InfluencerChartPointApiEntity(
            dateUtc: _date(e.dateUtc),
            amount: e.amount ?? 0,
            clicks: e.clicks ?? 0,
            orders: e.orders ?? 0,
          ),
        )
        .toList(),
    kpis: (overviewKpis ?? const KpisDto()).toEntity(),
    topPackages: topPackages
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

extension BankDtoMapper on InfluencerBankDto {
  InfluencerBankEntity toEntity() => InfluencerBankEntity(
    id: id ?? '',
    code: code ?? '',
    nameAr: nameAr ?? '',
    nameEn: nameEn ?? '',
    isActive: isActive ?? false,
  );
}

extension LinksDtoMapper on InfluencerLinksResponseDto {
  InfluencerLinksEntity toEntity() => InfluencerLinksEntity(
    influencerCode: influencerCode ?? '',
    referralLink: referralLink ?? '',
    qrCodeData: qrCodeData ?? referralLink ?? '',
    kpis: (quickStats ?? const KpisDto()).toEntity(),
  );
}

extension ActivitiesPageDtoMapper on InfluencerActivitiesPageDto {
  InfluencerPageEntity<InfluencerActivityApiEntity> toEntity() =>
      InfluencerPageEntity(
        items: items
            .map(
              (e) => InfluencerActivityApiEntity(
                id: e.activityId ?? '',
                code: e.activityCode ?? 'unknown',
                referenceId: e.referenceId,
                commissionAmount: _money(e.commissionAmount),
                occurredAtUtc: _date(e.occurredAtUtc),
              ),
            )
            .toList(),
        page: page ?? 1,
        pageSize: pageSize ?? 20,
        totalCount: totalCount ?? 0,
        totalPages: totalPages ?? 0,
        hasPreviousPage: hasPreviousPage ?? false,
        hasNextPage: hasNextPage ?? false,
      );
}

extension WithdrawalsPageDtoMapper on InfluencerWithdrawalsPageDto {
  InfluencerPageEntity<InfluencerWithdrawalEntity> toEntity() =>
      InfluencerPageEntity(
        items: items.map((e) => e.toEntity()).toList(),
        page: page ?? 1,
        pageSize: pageSize ?? 20,
        totalCount: totalCount ?? 0,
        totalPages: totalPages ?? 0,
        hasPreviousPage: hasPreviousPage ?? false,
        hasNextPage: hasNextPage ?? false,
      );
}
