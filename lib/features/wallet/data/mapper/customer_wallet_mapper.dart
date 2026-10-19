import 'package:meal_meat_user/features/wallet/data/models/customer_referral_summary_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_wallet_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/wallet_transactions_response_dto.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/customer_wallet_entity.dart';

extension CustomerWalletDtoMapper on CustomerWalletResponseDto {
  CustomerWalletEntity toEntity() {
    return CustomerWalletEntity(
      totalBalance: resolvedTotalBalance,
      cashBalance: resolvedCashBalance,
      promotionalBalance: resolvedPromotionalBalance,
      currency: resolvedCurrency,
      updatedAtUtc: updatedAtUtc,
    );
  }
}

extension WalletTransactionItemDtoMapper on WalletTransactionItemDto {
  CustomerWalletTransactionItemEntity toEntity() {
    return CustomerWalletTransactionItemEntity(
      id: id?.toString() ?? '',
      type: type?.toLowerCase() ?? 'credit',
      amount: amount ?? 0.0,
      currency: currency ?? 'KWD',
      walletType: walletType?.toLowerCase() ?? 'cash',
      description: description ?? reason ?? '',
      referenceId: referenceId,
      createdAtUtc: createdAtUtc,
    );
  }
}

extension WalletTransactionsDtoMapper on WalletTransactionsResponseDto {
  CustomerWalletTransactionsEntity toEntity() {
    return CustomerWalletTransactionsEntity(
      page: page ?? 1,
      pageSize: pageSize ?? (items?.length ?? 20),
      totalCount: totalCount ?? (items?.length ?? 0),
      items: items?.map((e) => e.toEntity()).toList() ?? const [],
    );
  }
}

extension CustomerReferralSummaryDtoMapper on CustomerReferralSummaryResponseDto {
  CustomerReferralEntity toEntity() {
    return CustomerReferralEntity(
      code: resolvedCode,
      rewardPercentage: rewardPercentage ?? 0.0,
      totalReferrals: resolvedTotalReferrals,
      completedReferrals: resolvedCompletedReferrals,
      earnedCredits: resolvedEarnedCredits,
      currency: resolvedCurrency,
      shareMessage: shareMessage ?? '',
      shareUrl: shareUrl ?? '',
    );
  }
}
