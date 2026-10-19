import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/wallet/data/data_source/customer_wallet_remote_data_source.dart';
import 'package:meal_meat_user/features/wallet/data/mapper/customer_wallet_mapper.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/customer_wallet_entity.dart';
import 'package:meal_meat_user/features/wallet/domain/repo/customer_wallet_repository.dart';

@Injectable(as: CustomerWalletRepository)
class CustomerWalletRepositoryImpl implements CustomerWalletRepository {
  const CustomerWalletRepositoryImpl(this._remoteDataSource);

  final CustomerWalletRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CustomerWalletEntity>> getWallet() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getWallet();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CustomerWalletTransactionsEntity>> getTransactions({
    String? walletType,
    int? page,
    int? pageSize,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTransactions(
        walletType: walletType,
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CustomerReferralEntity>> getReferralsSummary() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getReferralsSummary();
      return response.toEntity();
    });
  }
}
