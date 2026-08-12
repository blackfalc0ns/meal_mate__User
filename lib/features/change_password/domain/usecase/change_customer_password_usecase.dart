import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/change_password/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/change_password/domain/repo/change_password_repository.dart';

@injectable
class ChangeCustomerPasswordUseCase {
  ChangeCustomerPasswordUseCase(this._repository);

  final ChangePasswordRepository _repository;

  Future<ApiResult<void>> call(ChangeCustomerPasswordRequestEntity request) {
    return _repository.changeCustomerPassword(request);
  }
}
