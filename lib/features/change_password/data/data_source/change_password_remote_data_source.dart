import 'package:meal_meat_user/features/change_password/data/models/request/change_customer_password_request_dto.dart';

abstract interface class ChangePasswordRemoteDataSource {
  Future<void> changeCustomerPassword(ChangeCustomerPasswordRequestDto request);
}
