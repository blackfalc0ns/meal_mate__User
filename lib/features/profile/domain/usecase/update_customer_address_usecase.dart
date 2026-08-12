import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class UpdateCustomerAddressUseCase {
  UpdateCustomerAddressUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<void>> call(
    String addressId,
    CustomerAddressRequestEntity request,
  ) {
    return _repository.updateCustomerAddress(addressId, request);
  }
}
