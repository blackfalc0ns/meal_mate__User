import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class UpdateCustomerProfileUseCase {
  UpdateCustomerProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<void>> call(UpdateCustomerProfileRequestEntity request) {
    return _repository.updateCustomerProfile(request);
  }
}
