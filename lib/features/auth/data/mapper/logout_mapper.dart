import 'package:meal_meat_user/features/auth/data/models/request/logout_request_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';

extension LogoutRequestEntityMapper on LogoutRequestEntity {
  LogoutRequestDto toDto() {
    return LogoutRequestDto(refreshToken: refreshToken);
  }
}
