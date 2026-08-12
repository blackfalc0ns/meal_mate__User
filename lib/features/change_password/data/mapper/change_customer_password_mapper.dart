import 'package:meal_meat_user/features/change_password/data/models/request/change_customer_password_request_dto.dart';
import 'package:meal_meat_user/features/change_password/domain/entities/change_customer_password_request_entity.dart';

extension ChangeCustomerPasswordRequestEntityMapper
    on ChangeCustomerPasswordRequestEntity {
  ChangeCustomerPasswordRequestDto toDto() {
    return ChangeCustomerPasswordRequestDto(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
