import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class DeleteCustomerAddressUseCase {
  DeleteCustomerAddressUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<void>> call(String addressId) {
    return _repository.deleteCustomerAddress(addressId);
  }
}
