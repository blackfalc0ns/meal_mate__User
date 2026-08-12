import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class GetCustomerProfileUseCase {
  GetCustomerProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<CustomerProfileEntity>> call() {
    return _repository.getCustomerProfile();
  }
}
