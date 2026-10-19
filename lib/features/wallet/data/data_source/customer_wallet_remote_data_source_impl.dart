import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/wallet/data/data_source/customer_wallet_remote_data_source.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_referral_summary_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_wallet_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/wallet_transactions_response_dto.dart';

@LazySingleton(as: CustomerWalletRemoteDataSource)
class CustomerWalletRemoteDataSourceImpl
    implements CustomerWalletRemoteDataSource {
  const CustomerWalletRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<CustomerWalletResponseDto> getWallet() {
    return _apiServices.getCustomerWallet();
  }

  @override
  Future<WalletTransactionsResponseDto> getTransactions({
    String? walletType,
    int? page,
    int? pageSize,
  }) {
    return _apiServices.getCustomerWalletTransactions(
      walletType,
      page,
      pageSize,
    );
  }

  @override
  Future<CustomerReferralSummaryResponseDto> getReferralsSummary() {
    return _apiServices.getCustomerReferralsSummary();
  }
}
