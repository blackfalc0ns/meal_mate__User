import 'package:meal_meat_user/features/notifications/data/models/request/device_token_register_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_unregister_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/response/notifications_page_response_dto.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<NotificationsPageResponseDto> getCustomerNotifications({
    required int page,
    required int pageSize,
  });

  Future<void> markCustomerNotificationRead(String id);

  Future<void> markAllCustomerNotificationsRead();

  Future<void> registerDeviceToken(DeviceTokenRegisterRequestDto request);

  Future<void> unregisterDeviceToken(DeviceTokenUnregisterRequestDto request);
}
