import '../../domain/entities/influencer_wallet_entity.dart';
import '../models/influencer_wallet_dto.dart';

InfluencerWalletMoneyEntity _money(
  InfluencerWalletMoneyDto? value, [
  String currency = 'KWD',
]) => InfluencerWalletMoneyEntity(
  amount: value?.amount ?? 0,
  currency: value?.currency ?? currency,
);
InfluencerWalletBankEntity _bank(InfluencerWalletBankDto? value) =>
    InfluencerWalletBankEntity(
      bankName: value?.bankName ?? '',
      accountHolderName: value?.accountHolderName ?? '',
      iban: value?.iban,
      maskedIban: value?.maskedIban ?? '',
      isConfigured: value?.isConfigured ?? false,
    );
DateTime? _date(String? value) =>
    value == null ? null : DateTime.tryParse(value)?.toUtc();

extension InfluencerWithdrawalDtoMapper on InfluencerWithdrawalResponseDto {
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
    bankInfo: _bank(bankDetails),
    requestedAtUtc: _date(requestedAtUtc),
    reviewedAtUtc: _date(reviewedAtUtc),
    completedAtUtc: _date(completedAtUtc),
    rejectionReason: rejectionReason,
  );
}

extension InfluencerWalletDtoMapper on InfluencerWalletResponseDto {
  InfluencerWalletEntity toEntity() {
    final currency = currencyCode ?? availableBalance?.currency ?? 'KWD';
    return InfluencerWalletEntity(
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
      bankInfo: _bank(bankInfo),
      recentTransactions: (recentTransactions ?? const [])
          .map((e) => e.toEntity())
          .toList(),
    );
  }
}

extension InfluencerWithdrawalsPageDtoMapper on InfluencerWithdrawalsPageDto {
  InfluencerWithdrawalsPageEntity toEntity() => InfluencerWithdrawalsPageEntity(
    items: (items ?? const []).map((e) => e.toEntity()).toList(),
    page: page ?? 1,
    pageSize: pageSize ?? 20,
    totalCount: totalCount ?? 0,
    totalPages: totalPages ?? 0,
    hasPreviousPage: hasPreviousPage ?? false,
    hasNextPage: hasNextPage ?? false,
  );
}
