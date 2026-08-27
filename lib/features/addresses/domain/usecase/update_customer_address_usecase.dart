import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@injectable
class UpdateCustomerAddressUseCase {
  UpdateCustomerAddressUseCase(this._repository);

  final AddressesRepository _repository;

  Future<ApiResult<CustomerAddressEntity>> call(
    String addressId,
    CustomerAddressRequestEntity request,
  ) {
    return _repository.updateCustomerAddress(addressId, request);
  }
}
