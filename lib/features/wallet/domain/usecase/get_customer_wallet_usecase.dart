import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/customer_wallet_entity.dart';
import 'package:meal_meat_user/features/wallet/domain/repo/customer_wallet_repository.dart';

@injectable
class GetCustomerWalletUseCase {
  const GetCustomerWalletUseCase(this._repository);

  final CustomerWalletRepository _repository;

  Future<ApiResult<CustomerWalletEntity>> call() {
    return _repository.getWallet();
  }
}
