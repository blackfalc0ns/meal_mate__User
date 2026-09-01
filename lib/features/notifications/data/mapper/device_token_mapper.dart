import 'package:meal_meat_user/features/notifications/data/models/request/device_token_register_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_unregister_request_dto.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_register_request_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/device_token_unregister_request_entity.dart';

extension DeviceTokenRegisterRequestMapper on DeviceTokenRegisterRequestEntity {
  DeviceTokenRegisterRequestDto toDto() {
    return DeviceTokenRegisterRequestDto(
      token: token,
      platform: platform,
      deviceId: deviceId,
    );
  }
}

extension DeviceTokenUnregisterRequestMapper
    on DeviceTokenUnregisterRequestEntity {
  DeviceTokenUnregisterRequestDto toDto() {
    return DeviceTokenUnregisterRequestDto(token: token);
  }
}
