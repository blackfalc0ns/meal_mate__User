double _double(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
int _int(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
Map<String, dynamic> _map(dynamic value) =>
    value is Map<String, dynamic> ? value : const {};
List<Map<String, dynamic>> _maps(dynamic value) =>
    value is List ? value.whereType<Map<String, dynamic>>().toList() : const [];

class MoneyDto {
  const MoneyDto({this.amount, this.currency});
  factory MoneyDto.fromJson(Map<String, dynamic> json) => MoneyDto(
    amount: _double(json['amount']),
    currency: json['currency'] as String?,
  );
  final double? amount;
  final String? currency;
}

class BankInfoDto {
  const BankInfoDto({
    this.bankName,
    this.accountHolderName,
    this.iban,
    this.maskedIban,
    this.isConfigured,
  });
  factory BankInfoDto.fromJson(Map<String, dynamic> json) => BankInfoDto(
    bankName: json['bankName'] as String?,
    accountHolderName: json['accountHolderName'] as String?,
    iban: json['iban'] as String?,
    maskedIban: json['maskedIban'] as String?,
    isConfigured: json['isConfigured'] as bool?,
  );
  final String? bankName, accountHolderName, iban, maskedIban;
  final bool? isConfigured;
}

class WithdrawalPolicyDto {
  const WithdrawalPolicyDto({
    this.minimumAmount,
    this.maximumAmount,
    this.currencyCode,
    this.canWithdraw,
    this.disabledReason,
  });
  factory WithdrawalPolicyDto.fromJson(Map<String, dynamic> json) =>
      WithdrawalPolicyDto(
        minimumAmount: _double(json['minimumAmount']),
        maximumAmount: _double(json['maximumAmount']),
        currencyCode: json['currencyCode'] as String?,
        canWithdraw: json['canWithdraw'] as bool?,
        disabledReason: json['disabledReason'] as String?,
      );
  final double? minimumAmount, maximumAmount;
  final String? currencyCode, disabledReason;
  final bool? canWithdraw;
}

class KpisDto {
  const KpisDto({
    this.registeredCustomers,
    this.completedSubscriptions,
    this.linkClicks,
    this.conversionRate,
    this.registeredCustomersDiff,
    this.completedSubscriptionsDiff,
    this.linkClicksDiff,
    this.conversionRateDiff,
  });
  factory KpisDto.fromJson(Map<String, dynamic> json) => KpisDto(
    registeredCustomers: _int(json['registeredCustomers']),
    completedSubscriptions: _int(json['completedSubscriptions']),
    linkClicks: _int(json['linkClicks']),
    conversionRate: _double(json['conversionRate']),
    registeredCustomersDiff: _int(json['registeredCustomersDiff']),
    completedSubscriptionsDiff: _int(json['completedSubscriptionsDiff']),
    linkClicksDiff: _int(json['linkClicksDiff']),
    conversionRateDiff: _double(json['conversionRateDiff']),
  );
  final int? registeredCustomers,
      completedSubscriptions,
      linkClicks,
      registeredCustomersDiff,
      completedSubscriptionsDiff,
      linkClicksDiff;
  final double? conversionRate, conversionRateDiff;
}

class ActivityDto {
  const ActivityDto({
    this.activityId,
    this.activityCode,
    this.referenceId,
    this.commissionAmount,
    this.occurredAtUtc,
  });
  factory ActivityDto.fromJson(Map<String, dynamic> json) => ActivityDto(
    activityId: json['activityId'] as String?,
    activityCode: json['activityCode'] as String?,
    referenceId: json['referenceId'] as String?,
    commissionAmount: MoneyDto.fromJson(_map(json['commissionAmount'])),
    occurredAtUtc: json['occurredAtUtc'] as String?,
  );
  final String? activityId, activityCode, referenceId, occurredAtUtc;
  final MoneyDto? commissionAmount;
}

class InfluencerWalletResponseDto {
  const InfluencerWalletResponseDto({
    this.availableBalance,
    this.pendingBalance,
    this.lifetimeEarnings,
    this.thisMonthEarned,
    this.thisMonthWithdrawn,
    this.currencyCode,
    this.hasActiveWithdrawalRequest,
    this.withdrawalPolicy,
    this.bankInfo,
    this.recentTransactions = const [],
  });
  factory InfluencerWalletResponseDto.fromJson(Map<String, dynamic> json) =>
      InfluencerWalletResponseDto(
        availableBalance: MoneyDto.fromJson(_map(json['availableBalance'])),
        pendingBalance: MoneyDto.fromJson(_map(json['pendingBalance'])),
        lifetimeEarnings: MoneyDto.fromJson(_map(json['lifetimeEarnings'])),
        thisMonthEarned: MoneyDto.fromJson(_map(json['thisMonthEarned'])),
        thisMonthWithdrawn: MoneyDto.fromJson(_map(json['thisMonthWithdrawn'])),
        currencyCode: json['currencyCode'] as String?,
        hasActiveWithdrawalRequest: json['hasActiveWithdrawalRequest'] as bool?,
        withdrawalPolicy: WithdrawalPolicyDto.fromJson(
          _map(json['withdrawalPolicy']),
        ),
        bankInfo: BankInfoDto.fromJson(_map(json['bankInfo'])),
        recentTransactions: _maps(
          json['recentTransactions'],
        ).map(InfluencerWithdrawalResponseDto.fromJson).toList(),
      );
  final MoneyDto? availableBalance,
      pendingBalance,
      lifetimeEarnings,
      thisMonthEarned,
      thisMonthWithdrawn;
  final String? currencyCode;
  final bool? hasActiveWithdrawalRequest;
  final WithdrawalPolicyDto? withdrawalPolicy;
  final BankInfoDto? bankInfo;
  final List<InfluencerWithdrawalResponseDto> recentTransactions;
}

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
    this.recentActivities = const [],
  });
  factory InfluencerHomeResponseDto.fromJson(Map<String, dynamic> json) =>
      InfluencerHomeResponseDto(
        totalCommissions: MoneyDto.fromJson(_map(json['totalCommissions'])),
        thisWeekCommissionsDiff: MoneyDto.fromJson(
          _map(json['thisWeekCommissionsDiff']),
        ),
        kpis: KpisDto.fromJson(_map(json['kpis'])),
        influencerCode: json['influencerCode'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        currencyCode: json['currencyCode'] as String?,
        referralLink: json['referralLink'] as String?,
        qrCodeData: json['qrCodeData'] as String?,
        bankInfo: BankInfoDto.fromJson(_map(json['bankInfo'])),
        wallet: InfluencerWalletResponseDto.fromJson(_map(json['wallet'])),
        recentActivities: _maps(
          json['recentActivities'],
        ).map(ActivityDto.fromJson).toList(),
      );
  final MoneyDto? totalCommissions, thisWeekCommissionsDiff;
  final KpisDto? kpis;
  final String? influencerCode,
      avatarUrl,
      currencyCode,
      referralLink,
      qrCodeData;
  final BankInfoDto? bankInfo;
  final InfluencerWalletResponseDto? wallet;
  final List<ActivityDto> recentActivities;
}

class InfluencerSocialLinksDto {
  const InfluencerSocialLinksDto({
    this.tiktok,
    this.instagram,
    this.whatsapp,
    this.telegram,
    this.youtube,
    this.snapchat,
  });
  factory InfluencerSocialLinksDto.fromJson(Map<String, dynamic> json) =>
      InfluencerSocialLinksDto(
        tiktok: json['tiktok'] as String?,
        instagram: json['instagram'] as String?,
        whatsapp: json['whatsapp'] as String?,
        telegram: json['telegram'] as String?,
        youtube: json['youtube'] as String?,
        snapchat: json['snapchat'] as String?,
      );
  final String? tiktok, instagram, whatsapp, telegram, youtube, snapchat;
}

class InfluencerProfileResponseDto {
  const InfluencerProfileResponseDto({
    this.influencerProfileId,
    this.displayName,
    this.influencerCode,
    this.commissionRate,
    this.isActive,
    this.status,
    this.avatarUrl,
    this.hasCompletedSocialOnboarding,
    this.partnerTermsUrl,
    this.bankInfo,
    this.socialLinks,
  });
  factory InfluencerProfileResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => InfluencerProfileResponseDto(
    influencerProfileId: json['influencerProfileId'] as String?,
    displayName: json['displayName'] as String?,
    influencerCode: json['influencerCode'] as String?,
    commissionRate: _double(json['commissionRate']),
    isActive: json['isActive'] as bool?,
    status: json['status'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
    hasCompletedSocialOnboarding: json['hasCompletedSocialOnboarding'] as bool?,
    partnerTermsUrl: json['partnerTermsUrl'] as String?,
    bankInfo: BankInfoDto.fromJson(_map(json['bankInfo'])),
    socialLinks: InfluencerSocialLinksDto.fromJson(_map(json['socialLinks'])),
  );
  final String? influencerProfileId,
      displayName,
      influencerCode,
      status,
      avatarUrl,
      partnerTermsUrl;
  final double? commissionRate;
  final bool? isActive, hasCompletedSocialOnboarding;
  final BankInfoDto? bankInfo;
  final InfluencerSocialLinksDto? socialLinks;
}

class InfluencerBankAccountResponseDto extends BankInfoDto {
  const InfluencerBankAccountResponseDto({
    super.bankName,
    super.accountHolderName,
    super.iban,
    super.maskedIban,
    super.isConfigured,
  });
  factory InfluencerBankAccountResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => InfluencerBankAccountResponseDto(
    bankName: json['bankName'] as String?,
    accountHolderName: json['accountHolderName'] as String?,
    iban: json['iban'] as String?,
    maskedIban: json['maskedIban'] as String?,
    isConfigured: json['isConfigured'] as bool?,
  );
}

class InfluencerWithdrawalResponseDto {
  const InfluencerWithdrawalResponseDto({
    this.withdrawalId,
    this.referenceNumber,
    this.amount,
    this.status,
    this.method,
    this.bankDetails,
    this.requestedAtUtc,
    this.reviewedAtUtc,
    this.completedAtUtc,
    this.rejectionReason,
  });
  factory InfluencerWithdrawalResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => InfluencerWithdrawalResponseDto(
    withdrawalId: (json['withdrawalId'] ?? json['id']) as String?,
    referenceNumber: json['referenceNumber'] as String?,
    amount: MoneyDto.fromJson(_map(json['amount'])),
    status: json['status'] as String?,
    method: (json['method'] ?? json['withdrawalMethod']) as String?,
    bankDetails: BankInfoDto.fromJson(_map(json['bankDetails'])),
    requestedAtUtc: (json['requestedAtUtc'] ?? json['requestedAt']) as String?,
    reviewedAtUtc: json['reviewedAtUtc'] as String?,
    completedAtUtc: (json['completedAtUtc'] ?? json['processedAt']) as String?,
    rejectionReason: json['rejectionReason'] as String?,
  );
  final String? withdrawalId,
      referenceNumber,
      status,
      method,
      requestedAtUtc,
      reviewedAtUtc,
      completedAtUtc,
      rejectionReason;
  final MoneyDto? amount;
  final BankInfoDto? bankDetails;
}

class InfluencerWithdrawalRequestDto {
  const InfluencerWithdrawalRequestDto({
    required this.amount,
    required this.withdrawalMethod,
    required this.saveAsDefaultBank,
    required this.correlationId,
    this.bankName,
    this.accountHolderName,
    this.iban,
  });
  final double amount;
  final String withdrawalMethod, correlationId;
  final bool saveAsDefaultBank;
  final String? bankName, accountHolderName, iban;
  Map<String, dynamic> toJson() => <String, dynamic>{
    'amount': amount,
    'withdrawalMethod': withdrawalMethod,
    if (bankName != null) 'bankName': bankName,
    if (accountHolderName != null) 'accountHolderName': accountHolderName,
    if (iban != null) 'iban': iban,
    'saveAsDefaultBank': saveAsDefaultBank,
    'correlationId': correlationId,
  };
}

class InfluencerBankAccountRequestDto {
  const InfluencerBankAccountRequestDto({
    required this.bankName,
    required this.accountHolderName,
    required this.iban,
  });
  final String bankName, accountHolderName, iban;
  Map<String, dynamic> toJson() => {
    'bankName': bankName,
    'accountHolderName': accountHolderName,
    'iban': iban,
  };
}

class InfluencerSocialLinksRequestDto extends InfluencerSocialLinksDto {
  const InfluencerSocialLinksRequestDto({
    super.tiktok,
    super.instagram,
    super.whatsapp,
    super.telegram,
    super.youtube,
    super.snapchat,
  });
  Map<String, dynamic> toJson() => {
    'tiktok': tiktok,
    'instagram': instagram,
    'whatsapp': whatsapp,
    'telegram': telegram,
    'youtube': youtube,
    'snapchat': snapchat,
  };
}

class ComparisonDto {
  const ComparisonDto({
    this.clicksChangePercentage,
    this.ordersChangePercentage,
    this.netCommissionChangePercentage,
  });
  factory ComparisonDto.fromJson(Map<String, dynamic> json) => ComparisonDto(
    clicksChangePercentage: _double(json['clicksChangePercentage']),
    ordersChangePercentage: _double(json['ordersChangePercentage']),
    netCommissionChangePercentage: _double(
      json['netCommissionChangePercentage'],
    ),
  );
  final double? clicksChangePercentage,
      ordersChangePercentage,
      netCommissionChangePercentage;
}

class EarningsPointDto {
  const EarningsPointDto({this.dateUtc, this.amount, this.clicks, this.orders});
  factory EarningsPointDto.fromJson(Map<String, dynamic> json) =>
      EarningsPointDto(
        dateUtc: json['dateUtc'] as String?,
        amount: _double(json['amount']),
        clicks: _int(json['clicks']),
        orders: _int(json['orders']),
      );
  final String? dateUtc;
  final double? amount;
  final int? clicks, orders;
}

class TopPackageDto {
  const TopPackageDto({
    this.programId,
    this.bundleId,
    this.nameAr,
    this.nameEn,
    this.totalRevenue,
    this.orderCount,
    this.totalCommission,
  });
  factory TopPackageDto.fromJson(Map<String, dynamic> json) => TopPackageDto(
    programId: json['programId'] as String?,
    bundleId: json['bundleId'] as String?,
    nameAr: json['nameAr'] as String?,
    nameEn: json['nameEn'] as String?,
    totalRevenue: _double(json['totalRevenue']),
    orderCount: _int(json['orderCount']),
    totalCommission: _double(json['totalCommission']),
  );
  final String? programId, bundleId, nameAr, nameEn;
  final double? totalRevenue, totalCommission;
  final int? orderCount;
}

class InfluencerAnalyticsResponseDto {
  const InfluencerAnalyticsResponseDto({
    this.period,
    this.currencyCode,
    this.granularity,
    this.totalEarnings,
    this.comparison,
    this.earningsChart = const [],
    this.overviewKpis,
    this.topPackages = const [],
  });
  factory InfluencerAnalyticsResponseDto.fromJson(Map<String, dynamic> json) =>
      InfluencerAnalyticsResponseDto(
        period: json['period'] as String?,
        currencyCode: json['currencyCode'] as String?,
        granularity: json['granularity'] as String?,
        totalEarnings: MoneyDto.fromJson(_map(json['totalEarnings'])),
        comparison: ComparisonDto.fromJson(_map(json['comparison'])),
        earningsChart: _maps(
          json['earningsChart'],
        ).map(EarningsPointDto.fromJson).toList(),
        overviewKpis: KpisDto.fromJson(_map(json['overviewKpis'])),
        topPackages: _maps(
          json['topPackages'],
        ).map(TopPackageDto.fromJson).toList(),
      );
  final String? period, currencyCode, granularity;
  final MoneyDto? totalEarnings;
  final ComparisonDto? comparison;
  final List<EarningsPointDto> earningsChart;
  final KpisDto? overviewKpis;
  final List<TopPackageDto> topPackages;
}

class InfluencerBankDto {
  const InfluencerBankDto({
    this.id,
    this.code,
    this.nameAr,
    this.nameEn,
    this.isActive,
  });
  factory InfluencerBankDto.fromJson(Map<String, dynamic> json) =>
      InfluencerBankDto(
        id: json['id'] as String?,
        code: json['code'] as String?,
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
        isActive: json['isActive'] as bool?,
      );
  final String? id, code, nameAr, nameEn;
  final bool? isActive;
}

class InfluencerLinksResponseDto {
  const InfluencerLinksResponseDto({
    this.influencerCode,
    this.referralLink,
    this.qrCodeData,
    this.quickStats,
  });
  factory InfluencerLinksResponseDto.fromJson(Map<String, dynamic> json) =>
      InfluencerLinksResponseDto(
        influencerCode: json['influencerCode'] as String?,
        referralLink: json['referralLink'] as String?,
        qrCodeData: json['qrCodeData'] as String?,
        quickStats: KpisDto.fromJson(_map(json['quickStats'])),
      );
  final String? influencerCode, referralLink, qrCodeData;
  final KpisDto? quickStats;
}

class InfluencerActivitiesPageDto {
  const InfluencerActivitiesPageDto({
    this.items = const [],
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasPreviousPage,
    this.hasNextPage,
  });
  factory InfluencerActivitiesPageDto.fromJson(Map<String, dynamic> json) =>
      InfluencerActivitiesPageDto(
        items: _maps(json['items']).map(ActivityDto.fromJson).toList(),
        page: _int(json['page']),
        pageSize: _int(json['pageSize']),
        totalCount: _int(json['totalCount']),
        totalPages: _int(json['totalPages']),
        hasPreviousPage: json['hasPreviousPage'] as bool?,
        hasNextPage: json['hasNextPage'] as bool?,
      );
  final List<ActivityDto> items;
  final int? page, pageSize, totalCount, totalPages;
  final bool? hasPreviousPage, hasNextPage;
}

class InfluencerWithdrawalsPageDto {
  const InfluencerWithdrawalsPageDto({
    this.items = const [],
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasPreviousPage,
    this.hasNextPage,
  });
  factory InfluencerWithdrawalsPageDto.fromJson(Map<String, dynamic> json) =>
      InfluencerWithdrawalsPageDto(
        items: _maps(
          json['items'],
        ).map(InfluencerWithdrawalResponseDto.fromJson).toList(),
        page: _int(json['page']),
        pageSize: _int(json['pageSize']),
        totalCount: _int(json['totalCount']),
        totalPages: _int(json['totalPages']),
        hasPreviousPage: json['hasPreviousPage'] as bool?,
        hasNextPage: json['hasNextPage'] as bool?,
      );
  final List<InfluencerWithdrawalResponseDto> items;
  final int? page, pageSize, totalCount, totalPages;
  final bool? hasPreviousPage, hasNextPage;
}

class InfluencerSuccessResponseDto {
  const InfluencerSuccessResponseDto({this.isSuccess});
  factory InfluencerSuccessResponseDto.fromJson(Map<String, dynamic> json) =>
      InfluencerSuccessResponseDto(isSuccess: json['isSuccess'] as bool?);
  final bool? isSuccess;
}
