import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/change_password/domain/entities/change_customer_password_request_entity.dart';

abstract interface class ChangePasswordRepository {
  Future<ApiResult<void>> changeCustomerPassword(
    ChangeCustomerPasswordRequestEntity request,
  );
}
