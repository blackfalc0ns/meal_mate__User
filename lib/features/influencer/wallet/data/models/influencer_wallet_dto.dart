import 'package:json_annotation/json_annotation.dart';

part 'influencer_wallet_dto.g.dart';

@JsonSerializable(createToJson: false)
class InfluencerWalletMoneyDto {
  const InfluencerWalletMoneyDto({this.amount, this.currency});
  factory InfluencerWalletMoneyDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerWalletMoneyDtoFromJson(json);
  final double? amount;
  final String? currency;
}

@JsonSerializable(createToJson: false)
class InfluencerWalletBankDto {
  const InfluencerWalletBankDto({
    this.bankName,
    this.accountHolderName,
    this.iban,
    this.maskedIban,
    this.isConfigured,
  });
  factory InfluencerWalletBankDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerWalletBankDtoFromJson(json);
  final String? bankName, accountHolderName, iban, maskedIban;
  final bool? isConfigured;
}

@JsonSerializable(createToJson: false)
class InfluencerWithdrawalPolicyDto {
  const InfluencerWithdrawalPolicyDto({
    this.minimumAmount,
    this.maximumAmount,
    this.currencyCode,
    this.canWithdraw,
    this.disabledReason,
  });
  factory InfluencerWithdrawalPolicyDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerWithdrawalPolicyDtoFromJson(json);
  final double? minimumAmount, maximumAmount;
  final String? currencyCode, disabledReason;
  final bool? canWithdraw;
}

@JsonSerializable(createToJson: false)
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
  factory InfluencerWithdrawalResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerWithdrawalResponseDtoFromJson(_normalizeWithdrawal(json));
  final String? withdrawalId,
      referenceNumber,
      status,
      method,
      requestedAtUtc,
      reviewedAtUtc,
      completedAtUtc,
      rejectionReason;
  final InfluencerWalletMoneyDto? amount;
  final InfluencerWalletBankDto? bankDetails;
}

@JsonSerializable(createToJson: false)
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
    this.recentTransactions,
  });
  factory InfluencerWalletResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerWalletResponseDtoFromJson(_normalizeWallet(json));
  final InfluencerWalletMoneyDto? availableBalance,
      pendingBalance,
      lifetimeEarnings,
      thisMonthEarned,
      thisMonthWithdrawn;
  final String? currencyCode;
  final bool? hasActiveWithdrawalRequest;
  final InfluencerWithdrawalPolicyDto? withdrawalPolicy;
  final InfluencerWalletBankDto? bankInfo;
  final List<InfluencerWithdrawalResponseDto>? recentTransactions;
}

@JsonSerializable(createFactory: false, includeIfNull: false)
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
  Map<String, dynamic> toJson() => _$InfluencerWithdrawalRequestDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class InfluencerWithdrawalsPageDto {
  const InfluencerWithdrawalsPageDto({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasPreviousPage,
    this.hasNextPage,
  });
  factory InfluencerWithdrawalsPageDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerWithdrawalsPageDtoFromJson(json);
  final List<InfluencerWithdrawalResponseDto>? items;
  final int? page, pageSize, totalCount, totalPages;
  final bool? hasPreviousPage, hasNextPage;
}

Map<String, dynamic> _normalizeWithdrawal(Map<String, dynamic> json) => {
  ...json,
  'withdrawalId': json['withdrawalId'] ?? json['id'],
  'referenceNumber': json['referenceNumber'] ?? json['transferReferenceNumber'],
  'method': json['method'] ?? json['withdrawalMethod'],
  'requestedAtUtc': json['requestedAtUtc'] ?? json['requestedAt'],
  'completedAtUtc': json['completedAtUtc'] ?? json['processedAt'],
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
