import 'package:meal_meat_user/features/notifications/data/models/request/device_token_register_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_unregister_request_dto.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<void> registerDeviceToken(DeviceTokenRegisterRequestDto request);

  Future<void> unregisterDeviceToken(DeviceTokenUnregisterRequestDto request);
}
