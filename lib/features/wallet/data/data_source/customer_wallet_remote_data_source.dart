import 'package:meal_meat_user/features/wallet/data/models/customer_referral_summary_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_wallet_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/wallet_transactions_response_dto.dart';

abstract interface class CustomerWalletRemoteDataSource {
  Future<CustomerWalletResponseDto> getWallet();

  Future<WalletTransactionsResponseDto> getTransactions({
    String? walletType,
    int? page,
    int? pageSize,
  });

  Future<CustomerReferralSummaryResponseDto> getReferralsSummary();
}
