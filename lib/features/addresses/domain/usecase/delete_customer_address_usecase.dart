import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@injectable
class DeleteCustomerAddressUseCase {
  DeleteCustomerAddressUseCase(this._repository);

  final AddressesRepository _repository;

  Future<ApiResult<void>> call(String addressId) {
    return _repository.deleteCustomerAddress(addressId);
  }
}
