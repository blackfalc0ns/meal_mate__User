import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/customer_wallet_entity.dart';

abstract interface class CustomerWalletRepository {
  Future<ApiResult<CustomerWalletEntity>> getWallet();

  Future<ApiResult<CustomerWalletTransactionsEntity>> getTransactions({
    String? walletType,
    int? page,
    int? pageSize,
  });

  Future<ApiResult<CustomerReferralEntity>> getReferralsSummary();
}
