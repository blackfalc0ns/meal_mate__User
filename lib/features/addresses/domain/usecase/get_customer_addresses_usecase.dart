import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@injectable
class GetCustomerAddressesUseCase {
  GetCustomerAddressesUseCase(this._repository);

  final AddressesRepository _repository;

  Future<ApiResult<List<CustomerAddressEntity>>> call() {
    return _repository.getCustomerAddresses();
  }
}
